from __future__ import annotations

from datetime import datetime, timezone
from uuid import UUID

from app.exercises.constants import SEEDED_EXERCISES
from app.exercises.schemas import (
    CompleteRequest,
    CompleteResponse,
    ExerciseResponse,
    SessionStartResponse,
)


class ExerciseNotFoundError(Exception):
    """Raised when a requested exercise does not exist in the catalog."""


class SessionNotFoundError(Exception):
    """Raised when a session does not exist or is not owned by the caller."""


class SessionNotActiveError(Exception):
    """Raised when a session exists but is not in active status."""


async def list_catalog(db: AsyncSession) -> list[ExerciseResponse]:
    """Return the current catalog from the database."""
    from app.exercises import repository

    exercises = await repository.list_exercises(db)
    return [ExerciseResponse.model_validate(ex) for ex in exercises]


async def get_catalog_item(
    db: AsyncSession, exercise_id: str
) -> ExerciseResponse | None:
    """Return a single catalog item by id, or None if absent."""
    from app.exercises import repository

    exercise = await repository.get_exercise_by_id(db, exercise_id)
    return ExerciseResponse.model_validate(exercise) if exercise else None


def get_seeded_catalog() -> list[ExerciseResponse]:
    """Return the static catalog definition seeded by Nivel 1.2 migrations."""
    return [ExerciseResponse(**ex) for ex in SEEDED_EXERCISES]


async def start_exercise(
    db: AsyncSession, patient_id: UUID, exercise_id: str
) -> SessionStartResponse:
    """Start a new active session for the patient and exercise.

    Raises:
        ExerciseNotFoundError: when the exercise id is not in the catalog.
    """
    from app.exercises import repository

    exercise = await repository.get_exercise_by_id(db, exercise_id)
    if exercise is None:
        raise ExerciseNotFoundError(exercise_id)

    session = await repository.create_session(db, patient_id, exercise_id)
    return SessionStartResponse(
        session_id=session.id,
        exercise_id=session.exercise_id,
        started_at=session.started_at,
        status=session.status,
    )


async def complete_exercise(
    db: AsyncSession,
    patient_id: UUID,
    exercise_id: str,
    request: CompleteRequest,
) -> CompleteResponse:
    """Complete an active session owned by the patient.

    The operation is idempotent: completing an already-completed session returns
    the existing state without mutating rows or inserting duplicate telemetry.

    Raises:
        ExerciseNotFoundError: when the exercise id is not in the catalog.
        SessionNotFoundError: when the session id does not exist or is not owned.
        SessionNotActiveError: when the session is not active (e.g. cancelled).
    """
    from app.exercises import repository

    exercise = await repository.get_exercise_by_id(db, exercise_id)
    if exercise is None:
        raise ExerciseNotFoundError(exercise_id)

    session = await repository.get_session_by_id_for_update(db, request.session_id)
    if (
        session is None
        or session.patient_id != patient_id
        or session.exercise_id != exercise_id
    ):
        raise SessionNotFoundError(request.session_id)

    if session.status == "completed":
        return CompleteResponse(
            session_id=session.id,
            exercise_id=session.exercise_id,
            status=session.status,
            completed_at=session.completed_at,
            duration_seconds=session.duration_seconds or 0,
        )

    if session.status != "active":
        raise SessionNotActiveError(request.session_id)

    completed_at = datetime.now(timezone.utc)
    duration_seconds = int((completed_at - session.started_at).total_seconds())

    session.status = "completed"
    session.completed_at = completed_at
    session.duration_seconds = duration_seconds

    await repository.create_telemetry(db, session.id, "duration", duration_seconds)
    await repository.create_telemetry(db, session.id, "completion", 1)
    await repository.create_telemetry(db, session.id, "pauses", request.pauses)
    await repository.create_telemetry(db, session.id, "retries", request.retries)

    return CompleteResponse(
        session_id=session.id,
        exercise_id=session.exercise_id,
        status=session.status,
        completed_at=completed_at,
        duration_seconds=duration_seconds,
    )
