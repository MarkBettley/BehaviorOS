import asyncio
import os
from logging.config import fileConfig

import sqlalchemy as sa
from sqlalchemy import pool
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config

from alembic import context

config = context.config
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = None


def backend_role_password() -> str:
    password = os.getenv("BACKEND_DB_PASSWORD")
    if not password:
        raise RuntimeError("BACKEND_DB_PASSWORD is required for Alembic")
    if password == os.getenv("POSTGRES_PASSWORD"):
        raise RuntimeError("BACKEND_DB_PASSWORD must differ from POSTGRES_PASSWORD")
    return password


def reconcile_backend_role_password(connection: Connection) -> None:
    role_exists = connection.execute(
        sa.text("SELECT 1 FROM pg_roles WHERE rolname = 'backend_app'")
    ).scalar()
    if not role_exists:
        return
    statement = sa.text("ALTER ROLE backend_app WITH PASSWORD :password").bindparams(
        sa.bindparam(
            "password", value=backend_role_password(), type_=sa.String(), literal_execute=True
        )
    )
    connection.execute(statement)


def migration_database_url() -> str:
    migration_url = os.getenv("MIGRATION_DATABASE_URL")
    if not migration_url:
        raise RuntimeError("MIGRATION_DATABASE_URL is required for Alembic")
    return migration_url


def run_migrations_offline() -> None:
    context.configure(
        url=migration_database_url(),
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection: Connection) -> None:
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()
        reconcile_backend_role_password(connection)


async def run_async_migrations() -> None:
    configuration = config.get_section(config.config_ini_section, {})
    configuration["sqlalchemy.url"] = migration_database_url()
    connectable = async_engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)
    await connectable.dispose()


def run_migrations_online() -> None:
    asyncio.run(run_async_migrations())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
