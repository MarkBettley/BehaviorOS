"""Nivel 1.2 additive schema: exercises, sessions, telemetry, grants, RLS.

Revision ID: nivel12_additive
Revises: nivel11_baseline
Create Date: 2026-09-12 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects.postgresql import UUID

revision: str = "nivel12_additive"
down_revision: Union[str, None] = "nivel11_baseline"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute(sa.text("GRANT USAGE ON SCHEMA public TO backend_app"))
    op.execute(sa.text("GRANT authenticated TO backend_app"))

    # Catalog: one seeded exercise for Nivel 1.2.
    op.create_table(
        "exercises",
        sa.Column("id", sa.Text, primary_key=True),
        sa.Column("type", sa.Text, nullable=False),
        sa.Column("title", sa.Text, nullable=False),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("instructions", sa.JSON, nullable=True),
        sa.Column("duration_seconds", sa.Integer, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        schema="public",
    )

    op.create_table(
        "exercise_sessions",
        sa.Column(
            "id",
            UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("uuid_generate_v4()"),
        ),
        sa.Column(
            "patient_id",
            UUID(as_uuid=True),
            sa.ForeignKey("auth.users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "exercise_id",
            sa.Text,
            sa.ForeignKey("public.exercises.id"),
            nullable=False,
        ),
        sa.Column(
            "status",
            sa.Text,
            sa.CheckConstraint("status IN ('active','completed','cancelled')"),
            nullable=False,
            server_default="active",
        ),
        sa.Column(
            "started_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column("completed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("duration_seconds", sa.Integer, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        schema="public",
    )
    op.create_index(
        "ix_exercise_sessions_patient_status",
        "exercise_sessions",
        ["patient_id", "status"],
    )
    op.create_index(
        "ix_exercise_sessions_patient_exercise",
        "exercise_sessions",
        ["patient_id", "exercise_id", "status"],
    )

    op.create_table(
        "exercise_telemetry",
        sa.Column(
            "id",
            UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("uuid_generate_v4()"),
        ),
        sa.Column(
            "session_id",
            UUID(as_uuid=True),
            sa.ForeignKey("public.exercise_sessions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "variable_name",
            sa.Text,
            sa.CheckConstraint(
                "variable_name IN ('duration','completion','pauses','retries')"
            ),
            nullable=False,
        ),
        sa.Column("variable_value", sa.Numeric, nullable=False),
        sa.Column(
            "recorded_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        schema="public",
    )
    op.create_index(
        "ix_exercise_telemetry_session_var_ts",
        "exercise_telemetry",
        ["session_id", "variable_name", "recorded_at"],
    )

    # Seed the first therapeutic exercise.
    op.execute(
        sa.text(
            """
            INSERT INTO public.exercises (id, type, title, description, instructions, duration_seconds)
            VALUES (
              'EX_1',
              'mindfulness',
              'Respiración mindfulness guiada',
              'Ejercicio de respiración consciente para reducir la ansiedad.',
              '{"steps": ["Inhala 4 segundos", "Mantén 4 segundos", "Exhala 6 segundos"]}'::jsonb,
              180
            )
            ON CONFLICT (id) DO NOTHING;
            """
        )
    )

    # Lock down new tables and expose only the intended operations.
    for tbl in ("exercises", "exercise_sessions", "exercise_telemetry"):
        op.execute(sa.text(f"ALTER TABLE public.{tbl} ENABLE ROW LEVEL SECURITY"))
        op.execute(
            sa.text(f"REVOKE ALL ON public.{tbl} FROM PUBLIC, anon, authenticated")
        )

    op.execute(sa.text("GRANT SELECT ON public.exercises TO authenticated"))
    op.execute(sa.text("GRANT SELECT, INSERT, UPDATE ON public.exercise_sessions TO authenticated"))
    op.execute(sa.text("GRANT SELECT, INSERT ON public.exercise_telemetry TO authenticated"))
    op.execute(sa.text("GRANT ALL ON public.exercises, public.exercise_sessions, public.exercise_telemetry TO service_role"))

    op.execute(sa.text("""
        CREATE POLICY "exercises_select_all"
          ON public.exercises FOR SELECT TO authenticated USING (true)
    """))
    op.execute(sa.text("""
        CREATE POLICY "exercise_sessions_select_own"
          ON public.exercise_sessions FOR SELECT TO authenticated
          USING ((select auth.uid()) = patient_id)
    """))
    op.execute(sa.text("""
        CREATE POLICY "exercise_sessions_insert_own"
          ON public.exercise_sessions FOR INSERT TO authenticated
          WITH CHECK ((select auth.uid()) = patient_id)
    """))
    op.execute(sa.text("""
        CREATE POLICY "exercise_sessions_update_own"
          ON public.exercise_sessions FOR UPDATE TO authenticated
          USING ((select auth.uid()) = patient_id)
          WITH CHECK ((select auth.uid()) = patient_id)
    """))
    op.execute(sa.text("""
        CREATE POLICY "exercise_telemetry_select_own"
          ON public.exercise_telemetry FOR SELECT TO authenticated
          USING (session_id IN (SELECT id FROM public.exercise_sessions WHERE patient_id = auth.uid()))
    """))
    op.execute(sa.text("""
        CREATE POLICY "exercise_telemetry_insert_own"
          ON public.exercise_telemetry FOR INSERT TO authenticated
          WITH CHECK (session_id IN (SELECT id FROM public.exercise_sessions WHERE patient_id = auth.uid()))
    """))


def downgrade() -> None:
    for tbl in ("exercise_telemetry", "exercise_sessions", "exercises"):
        op.execute(sa.text(f"DROP TABLE IF EXISTS public.{tbl} CASCADE"))
    op.execute(sa.text("REVOKE authenticated FROM backend_app"))
    op.execute(sa.text("REVOKE USAGE ON SCHEMA public FROM backend_app"))
