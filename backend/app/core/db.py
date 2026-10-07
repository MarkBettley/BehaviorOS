from typing import AsyncGenerator

import sqlalchemy as sa
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.settings import settings

engine = create_async_engine(
    settings.DATABASE_URL,
    pool_size=settings.DATABASE_POOL_SIZE,
    max_overflow=settings.DATABASE_MAX_OVERFLOW,
    pool_pre_ping=True,
)
async_session_maker = async_sessionmaker(engine, expire_on_commit=False)


async def set_session_context(session: AsyncSession, sub: str) -> None:
    """Configure the transaction-local JWT claim required by Nivel 1.1 RLS."""
    await session.execute(sa.text("SET LOCAL ROLE authenticated"))
    await session.execute(
        sa.text("SELECT set_config('request.jwt.claim.sub', :sub, true)"),
        {"sub": sub},
    )


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        try:
            yield session
        finally:
            await session.close()
