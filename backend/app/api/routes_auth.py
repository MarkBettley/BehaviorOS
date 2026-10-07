from datetime import datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.auth import UserClaims, get_current_user
from app.core.db import get_db, set_session_context

router = APIRouter(prefix="/auth", tags=["auth"])


class ProfileResponse(BaseModel):
    id: UUID
    user_id: UUID
    created_at: datetime
    updated_at: datetime


class MeResponse(BaseModel):
    sub: str
    email: str | None = None
    app_role: str | None = None
    profile: ProfileResponse | None = None


@router.get("/me", response_model=MeResponse)
async def me(
    user: Annotated[UserClaims, Depends(get_current_user)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> MeResponse:
    await set_session_context(db, user.sub)
    result = await db.execute(
        text(
            "SELECT id, user_id, created_at, updated_at "
            "FROM public.patient_profiles WHERE user_id = CAST(:user_id AS uuid)"
        ),
        {"user_id": user.sub},
    )
    row = result.mappings().one_or_none()
    profile = ProfileResponse(**row) if row else None
    return MeResponse(
        sub=user.sub,
        email=user.email,
        app_role=user.app_role,
        profile=profile,
    )
