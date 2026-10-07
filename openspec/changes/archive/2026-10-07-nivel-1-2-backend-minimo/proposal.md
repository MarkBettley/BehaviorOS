# Proposal: Nivel 1.2 — Backend mínimo

## Intent

Unlock Nivel 1.3 (frontend básico) by standing up the minimum FastAPI backend that validates Supabase JWTs, resolves patient identity, and delivers one end-to-end therapeutic exercise with minimal telemetry. No backend code exists today; `.env.example` already declares unused FastAPI variables.

## Scope

### In Scope
- `backend` Docker service (FastAPI/Uvicorn) wired into `docker-compose.yml` on port 8001.
- JWT validation (HS256, hard-coded `algorithms`, `exp` enforced) via `SUPABASE_JWT_SECRET`.
- `/api/v1/health`, `/api/v1/auth/me` (identity + profile resolution), protected exercise endpoints.
- Guided mindfulness breathing as first exercise: `GET /api/v1/exercises`, `GET /api/v1/exercises/{id}`, `POST /api/v1/exercises/{id}/start`, `POST /api/v1/exercises/{id}/complete`.
- Telemetry: duration, completion, pauses, retries — plain indexed PostgreSQL table.
- SQLAlchemy 2.x async + Alembic (baseline-stamped over Nivel 1.1 raw-SQL schema).
- Versioned OpenAPI contract (`/api/v1/openapi.json`, `/docs`).

### Out of Scope
- signup/login/refresh/logout (remain GoTrue); frontend; TimescaleDB; Redis; AI/commerce; event sourcing; Nivel 1.3+.

## Capabilities

### New Capabilities
- `backend-api`: FastAPI service, JWT validation, `/api/v1/health` + `/api/v1/auth/me`, identity/profile resolution, resource protection.
- `therapeutic-exercise`: exercise catalog, sessions, telemetry; mindfulness breathing seeded.

### Modified Capabilities
None. Existing specs' readiness contracts already anticipate Nivel 1.2 read-only reliance; no requirement-level change.

## Approach

Option 1 (monolith container). PyJWT local HS256 verification (never trust token `alg`), `sub` = identity, `app_metadata.app_role` authoritative (never `user_metadata`). SQLAlchemy 2.x async engine (`postgresql+asyncpg://`) + Alembic `async` template with a stamped baseline over Nivel 1.1 migrations. Plain telemetry table indexed on `(session_id, variable_name, timestamp)` — defers TimescaleDB (PG17 drops it). Backend connects to Postgres directly; patient ownership enforced via RLS. Bash/curl smoke test `scripts/test-nivel-1-2-backend.sh`.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `docker-compose.yml` | Modified | Add `backend` service, port 8001 |
| `backend/` | New | FastAPI app, routers, models, settings, Dockerfile, Alembic |
| `.env.example` | Modified | Consume existing backend vars |
| `scripts/` | New | Backend smoke test |
| Volumes | None | No volume changes |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Greenfield bootstrap | High | Isolated `backend/` dir; no Nivel 1.1 files touched |
| Migration divergence | Med | Alembic baseline-stamped; documented boundary |
| No test runner | Med | Extend bash/curl harness pattern |
| Auth boundary blur | Low | Backend never reimplements GoTrue flows |
| Port collision | Low | Pin 8001; keep Kong routes separate |

## Rollback Plan

Remove the `backend` service block from `docker-compose.yml`, revert `.env.example`, delete `backend/` and `scripts/test-nivel-1-2-backend.sh`. New tables are additive: `DROP TABLE` if needed. No Nivel 1.1 artifact modified.

## Dependencies

- Nivel 1.1 archived schema (`auth.users`, `patient_profiles`, RLS matrix).
- `SUPABASE_JWT_SECRET` (HS256).

## Success Criteria

- [ ] `docker compose up` brings `backend` healthy on 8001.
- [ ] `/api/v1/health` returns 200; `/api/v1/auth/me` returns identity for a valid JWT, 401 for invalid/missing.
- [ ] Mindfulness breathing runs start→complete with duration/completion/pauses/retries persisted.
- [ ] Patient cannot read another patient's sessions/telemetry.
- [ ] `scripts/test-nivel-1-2-backend.sh` exits 0.
- [ ] `/api/v1/openapi.json` serves the versioned contract.
