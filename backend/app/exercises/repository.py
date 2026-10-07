from typing import Sequence
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.exercises.models import Exercise, ExerciseSession, ExerciseTelemetry


async def list_exercises(db: AsyncSession) -> Sequence[Exercise]:
    """Return all catalog exercises ordered by id."""
    result = await db.execute(select(Exercise).order_by(Exercise.id))
    return result.scalars().all()


async def get_exercise_by_id(db: AsyncSession, exercise_id: str) -> Exercise | None:
    """Return a single catalog exercise by primary key, or None."""
    result = await db.execute(select(Exercise).where(Exercise.id == exercise_id))
    return result.scalar_one_or_none()


async def create_session(
    db: AsyncSession, patient_id: UUID, exercise_id: str
) -> ExerciseSession:
    """Create and return a new active exercise session for the patient."""
    session = ExerciseSession(
        patient_id=patient_id,
        exercise_id=exercise_id,
        status="active",
    )
    db.add(session)
    await db.flush()
    await db.refresh(session)
    return session


async def get_session_by_id_for_update(
    db: AsyncSession, session_id: UUID
) -> ExerciseSession | None:
    """Return a patient session by id with a row lock, or None."""
    result = await db.execute(
        select(ExerciseSession)
        .where(ExerciseSession.id == session_id)
        .with_for_update(nowait=True)
    )
    return result.scalar_one_or_none()


async def create_telemetry(
    db: AsyncSession, session_id: UUID, variable_name: str, variable_value: float
) -> None:
    """Insert a single telemetry row for a session."""
    telemetry = ExerciseTelemetry(
        session_id=session_id,
        variable_name=variable_name,
        variable_value=variable_value,
    )
    db.add(telemetry)
