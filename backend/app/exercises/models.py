import uuid
from datetime import datetime

import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    """Declarative base for the exercises domain."""

    pass


# Reference-only metadata for the existing Supabase auth table.
# Does not create or modify auth.users in PostgreSQL.
sa.Table(
    "users",
    Base.metadata,
    sa.Column("id", UUID(as_uuid=True), primary_key=True),
    schema="auth",
)


class Exercise(Base):
    """Catalog of therapeutic exercises."""

    __tablename__ = "exercises"

    id: Mapped[str] = mapped_column(sa.Text, primary_key=True)
    type: Mapped[str] = mapped_column(sa.Text, nullable=False)
    title: Mapped[str] = mapped_column(sa.Text, nullable=False)
    description: Mapped[str | None] = mapped_column(sa.Text, nullable=True)
    instructions: Mapped[dict | None] = mapped_column(sa.JSON, nullable=True)
    duration_seconds: Mapped[int | None] = mapped_column(sa.Integer, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )


class ExerciseSession(Base):
    """Patient-owned instance of an exercise."""

    __tablename__ = "exercise_sessions"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=sa.text("uuid_generate_v4()"),
    )
    patient_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        sa.ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
    )
    exercise_id: Mapped[str] = mapped_column(
        sa.Text, sa.ForeignKey("exercises.id"), nullable=False
    )
    status: Mapped[str] = mapped_column(
        sa.Text, nullable=False, server_default="active"
    )
    started_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )
    completed_at: Mapped[datetime | None] = mapped_column(
        sa.DateTime(timezone=True), nullable=True
    )
    duration_seconds: Mapped[int | None] = mapped_column(sa.Integer, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )


class ExerciseTelemetry(Base):
    """Telemetry variables recorded for an exercise session."""

    __tablename__ = "exercise_telemetry"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=sa.text("uuid_generate_v4()"),
    )
    session_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        sa.ForeignKey("exercise_sessions.id", ondelete="CASCADE"),
        nullable=False,
    )
    variable_name: Mapped[str] = mapped_column(sa.Text, nullable=False)
    variable_value: Mapped[float] = mapped_column(sa.Numeric, nullable=False)
    recorded_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )
    created_at: Mapped[datetime] = mapped_column(
        sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
    )
