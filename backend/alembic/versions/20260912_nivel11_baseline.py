"""Nivel 1.1 baseline verification and stamp.

Revision ID: nivel11_baseline
Revises:
Create Date: 2026-09-12 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = "nivel11_baseline"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def _check_table(conn, schema: str, name: str) -> None:
    result = conn.execute(
        sa.text(
            "SELECT 1 FROM information_schema.tables "
            "WHERE table_schema = :schema AND table_name = :name"
        ),
        {"schema": schema, "name": name},
    )
    if result.scalar() != 1:
        raise RuntimeError(f"Nivel 1.1 sentinel table missing: {schema}.{name}")


def _check_policy(conn, name: str) -> None:
    result = conn.execute(
        sa.text("SELECT 1 FROM pg_policies WHERE policyname = :name"),
        {"name": name},
    )
    if result.scalar() != 1:
        raise RuntimeError(f"Nivel 1.1 sentinel policy missing: {name}")


def upgrade() -> None:
    conn = op.get_bind()
    for schema, name in [
        ("auth", "users"),
        ("public", "patient_profiles"),
        ("public", "patient_consents"),
        ("public", "consent_versions"),
        ("public", "audit_logs"),
    ]:
        _check_table(conn, schema, name)
    for policy in [
        "patient_profiles_select_own",
        "patient_profiles_insert_own",
        "patient_profiles_update_own",
        "audit_logs_select_own",
    ]:
        _check_policy(conn, policy)


def downgrade() -> None:
    pass
