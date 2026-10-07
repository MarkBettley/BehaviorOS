from typing import Annotated, Sequence
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.auth import UserClaims, get_current_user
from app.core.db import get_db, set_session_context
from app.exercises import service
from app.exercises.schemas import (
    CompleteRequest,
    CompleteResponse,
    ExerciseResponse,
    SessionStartResponse,
)

router = APIRouter(prefix="/exercises", tags=["exercises"])


def _patient_id(user: UserClaims) -> UUID:
    """Convert the JWT subject claim to a UUID used for ownership columns."""
    try:
        return UUID(user.sub)
    except ValueError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token subject",
        ) from exc


@router.get("", response_model=list[ExerciseResponse])
async def list_exercises(
    user: Annotated[UserClaims, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> Sequence[ExerciseResponse]:
    """Return the authenticated patient's exercise catalog."""
    await set_session_context(db, user.sub)
    return await service.list_catalog(db)


@router.get("/{exercise_id}", response_model=ExerciseResponse)
async def get_exercise(
    exercise_id: str,
    user: Annotated[UserClaims, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> ExerciseResponse:
    """Return a single catalog exercise by id."""
    await set_session_context(db, user.sub)
    exercise = await service.get_catalog_item(db, exercise_id)
    if exercise is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Exercise not found"
        )
    return exercise


@router.post(
    "/{exercise_id}/start",
    response_model=SessionStartResponse,
    status_code=status.HTTP_201_CREATED,
)
async def start_exercise(
    exercise_id: str,
    user: Annotated[UserClaims, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> SessionStartResponse:
    """Create a new active session for the requested exercise."""
    await set_session_context(db, user.sub)
    try:
        response = await service.start_exercise(db, _patient_id(user), exercise_id)
    except service.ExerciseNotFoundError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Exercise not found",
        ) from exc
    await db.commit()
    return response


@router.post("/{exercise_id}/complete", response_model=CompleteResponse)
async def complete_exercise(
    exercise_id: str,
    request: CompleteRequest,
    user: Annotated[UserClaims, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> CompleteResponse:
    """Finalize the active session and record telemetry."""
    await set_session_context(db, user.sub)
    try:
        response = await service.complete_exercise(
            db, _patient_id(user), exercise_id, request
        )
    except service.ExerciseNotFoundError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Exercise not found",
        ) from exc
    except service.SessionNotFoundError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Active session not found",
        ) from exc
    except service.SessionNotActiveError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No active session for this exercise",
        ) from exc
    await db.commit()
    return response
