# Tasks: Nivel 1.2 — Backend mínimo

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 900-1400 |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Suggested split | PR 1 infra/migrations → PR 2 auth/API → PR 3 exercise/harness |
| Delivery strategy | ask-on-risk |
| Chain strategy | stacked-to-main |

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: stacked-to-main
400-line budget risk: High

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Backend container, Alembic baseline, additive schema | PR 1 | `alembic upgrade nivel12_head` | `docker compose up backend db` | `docker-compose.yml`, `.env.example`, `backend/alembic/` |
| 2 | JWT, DB session context, health/auth/OpenAPI | PR 2 | `bash scripts/test-nivel-1-2-backend.sh auth` | `curl :8001/api/v1/health` | `backend/app/core/`, `backend/app/api/` |
| 3 | Exercise catalog/session/telemetry and full smoke | PR 3 | `bash scripts/test-nivel-1-2-backend.sh` | start→complete EX_1 scenario | `backend/app/exercises/`, `scripts/test-nivel-1-2-backend.sh` |

## Phase 1: Foundation / Infrastructure

- [x] 1.1 Add `backend/Dockerfile`, `backend/pyproject.toml`, and `backend/app/main.py` with FastAPI/Uvicorn on port 8001.
- [x] 1.2 Modify `docker-compose.yml` and `.env.example` for the backend service, async DB URL, JWT secret, and dedicated DB-user wiring.
- [x] 1.3 Create `backend/alembic/` async setup with a `nivel11_baseline` stamp flow that only verifies Nivel 1.1 sentinels.
- [x] 1.4 Create additive `backend/alembic/versions/` revisions for EX_1 catalog, sessions, telemetry, grants, indexes, and RLS.

## Phase 2: Backend API / Auth

- [x] 2.1 Add `backend/app/core/settings.py`, `backend/app/core/db.py`, and request-scoped transaction-local RLS context reset.
- [x] 2.2 Add `backend/app/core/auth.py` validating HS256 JWTs, `exp`, `sub`, `app_metadata.app_role`, and rejecting missing/invalid/expired/alg-none/anonymous tokens.
- [x] 2.3 Add `backend/app/api/routes_health.py`, `backend/app/api/routes_auth.py`, and versioned OpenAPI/docs wiring in `backend/app/main.py` for the /api/v1 and /docs routes.
- [x] 2.4 Implement `/api/v1/auth/me` profile lookup from `patient_profiles`, returning `profile: null` when absent.

## Phase 3: Exercise Implementation

- [x] 3.1 Add `backend/app/exercises/models.py` and repository/service code for exactly one seeded mindfulness exercise `EX_1`.
- [x] 3.2 Implement `GET /api/v1/exercises` and `GET /api/v1/exercises/EX_1` with authenticated patient access.
- [x] 3.3 Implement start/complete routes with owned active-session locking, 404 for foreign sessions, 400 without active session, and idempotent completion.
- [x] 3.4 Persist exactly four telemetry variables: duration, completion, pauses, and retries.

## Phase 4: Verification Harness

- [x] 4.1 Create `scripts/test-nivel-1-2-backend.sh` covering health, OpenAPI/docs, JWT failures, `/auth/me`, catalog, start, complete, idempotency, and RLS reads.
- [x] 4.2 Add harness fixtures/helpers in `scripts/test-nivel-1-2-backend.sh` for two patients and direct patient-role database queries.
- [x] 4.3 Run `bash scripts/test-nivel-1-2-backend.sh` and record failures before applying fixes, then require exit 0.
