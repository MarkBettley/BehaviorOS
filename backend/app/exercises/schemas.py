from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class ExerciseResponse(BaseModel):
    """Public representation of a catalog exercise."""

    model_config = ConfigDict(from_attributes=True)

    id: str
    type: str
    title: str
    description: str | None = None
    instructions: dict | None = None
    duration_seconds: int | None = None


class SessionStartResponse(BaseModel):
    """Response returned when a patient starts an exercise session."""

    model_config = ConfigDict(from_attributes=True)

    session_id: UUID
    exercise_id: str
    started_at: datetime
    status: str


class CompleteRequest(BaseModel):
    """Payload to finalize an active exercise session."""

    session_id: UUID
    pauses: int = Field(default=0, ge=0)
    retries: int = Field(default=0, ge=0)


class CompleteResponse(BaseModel):
    """Response returned when a patient completes an exercise session."""

    model_config = ConfigDict(from_attributes=True)

    session_id: UUID
    exercise_id: str
    status: str
    completed_at: datetime
    duration_seconds: int
