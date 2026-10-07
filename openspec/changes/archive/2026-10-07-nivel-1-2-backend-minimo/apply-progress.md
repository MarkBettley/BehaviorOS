# Apply Progress: Nivel 1.2 — Backend mínimo

**Change**: `nivel-1-2-backend-minimo`
**Primary work unit**: `Task 4.2 verification harness hardening`
**Mode**: Standard (strict TDD not active)
**Chain strategy**: `stacked-to-main`
**Native attempt token**: `sha256:cfece670facae727a59d99847a2339e9e1665700b7785ba162876afe355bf421` acquired for Task 3.4; settlement owned by parent.
**Previous native attempt token**: `sha256:2ca2d68b62147478af73db216de4995fa3ec842ef5e79f5d755a0beaedf97e68` acquired for Task 4.1; settlement owned by parent.
**Current native attempt token**: `sha256:7146efeaa8b77d134ebdc401e3c2e1dfa1737995d8e7ae97225545038a4f652c` acquired for Task 4.2; settlement owned by parent.
**PR boundary**: Autonomous verification-harness hardening slice (Task 4.2): make `scripts/test-nivel-1-2-backend.sh` cleanup safe and specific under partial fixture creation, and update apply-progress metadata/evidence to reflect the corrected state.

## Completed Tasks

### PR1 Foundation (tasks 1.1–1.3)

- [x] 1.1 Add `backend/Dockerfile`, `backend/pyproject.toml`, and `backend/app/main.py` with FastAPI/Uvicorn on port 8001.
- [x] 1.2 Modify `docker-compose.yml` and `.env.example` for the backend service, async DB URL, JWT secret, and dedicated DB-user wiring.
- [x] 1.3 Create `backend/alembic/` async setup with a `nivel11_baseline` stamp flow that only verifies Nivel 1.1 sentinels.

### PR2 Part A (tasks 1.4, 2.1, 2.2)

- [x] 1.4 Create additive `backend/alembic/versions/` revisions for EX_1 catalog, sessions, telemetry, grants, indexes, and RLS.
- [x] 2.1 Add `backend/app/core/settings.py`, `backend/app/core/db.py`, and request-scoped transaction-local RLS context reset.
- [x] 2.2 Add `backend/app/core/auth.py` validating HS256 JWTs, `exp`, `sub`, `app_metadata.app_role`, and rejecting missing/invalid/expired/alg-none/anonymous tokens.

### PR2 Part B (tasks 2.3, 2.4)

- [x] 2.3 Add `backend/app/api/routes_health.py`, `backend/app/api/routes_auth.py`, and versioned OpenAPI/docs wiring in `backend/app/main.py` for the /api/v1 and /docs routes.
- [x] 2.4 Implement `/api/v1/auth/me` profile lookup from `patient_profiles`, returning `profile: null` when absent.

### PR3 Part A (Task 3.1)

- [x] 3.1 Add `backend/app/exercises/models.py` and repository/service code for exactly one seeded mindfulness exercise `EX_1`.

### PR3 Part B (Task 3.2)

- [x] 3.2 Implement `GET /api/v1/exercises` and `GET /api/v1/exercises/EX_1` with authenticated patient access.

### PR3 Part C (Task 3.3)

- [x] 3.3 Implement start/complete routes with owned active-session locking, 404 for foreign sessions, 400 without active session, and idempotent completion.

### PR3 Part D (Task 3.4)

- [x] 3.4 Persist exactly four telemetry variables: duration, completion, pauses, and retries.

### Task 4.1 (Verification Harness Slice)

- [x] 4.1 Create `scripts/test-nivel-1-2-backend.sh` covering health, OpenAPI/docs, JWT failures, `/auth/me`, catalog, start, complete, idempotency, and RLS reads.

### Task 4.2 (Verification Harness Hardening)

- [x] 4.2 Add harness fixtures/helpers in `scripts/test-nivel-1-2-backend.sh` for two patients and direct patient-role database queries.

## Touched Files

### PR1 Foundation (tasks 1.1–1.3)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/Dockerfile` | Created | Python 3.11 slim image, installs editable backend, exposes 8001, runs Uvicorn. |
| `backend/pyproject.toml` | Created | Project metadata and dependencies: FastAPI, Uvicorn, Pydantic Settings, SQLAlchemy 2 async, asyncpg, Alembic, PyJWT. |
| `backend/app/__init__.py` | Created | Package marker. |
| `backend/app/main.py` | Created | FastAPI app with `/api/v1/health`, `/docs`, and `/api/v1/openapi.json`. |
| `backend/alembic.ini` | Created | Async Alembic config with `postgresql+asyncpg` URL placeholder. |
| `backend/alembic/__init__.py` | Created | Package marker. |
| `backend/alembic/env.py` | Created | Async Alembic environment; uses `MIGRATION_DATABASE_URL` when present. |
| `backend/alembic/script.py.mako` | Created | Standard revision template. |
| `backend/alembic/versions/__init__.py` | Created | Package marker. |
| `backend/alembic/versions/20260912_nivel11_baseline.py` | Created | Baseline revision `nivel11_baseline` that verifies Nivel 1.1 sentinel tables and RLS policies. |
| `docker-compose.yml` | Modified | Added `backend` service on `${APP_PORT:-8001}:8001`, depends on `db` healthy, `.env` loaded, Python-based healthcheck. |
| `.env.example` | Modified | Switched `DATABASE_URL` to `postgresql+asyncpg` with `BACKEND_DB_USER`/`BACKEND_DB_PASSWORD`; added `MIGRATION_DATABASE_URL`. |

### PR2 Part A (tasks 1.4, 2.1, 2.2)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/alembic/versions/20260912_nivel12_additive.py` | Created | Additive revision: `backend_app` role, `exercises`, `exercise_sessions`, `exercise_telemetry`, indexes, RLS, grants, and `EX_1` seed. |
| `backend/app/core/__init__.py` | Created | Package marker. |
| `backend/app/core/settings.py` | Created | Pydantic Settings loading `DATABASE_URL`, `SUPABASE_JWT_SECRET`, pool sizing, and API prefix. |
| `backend/app/core/db.py` | Created | Async SQLAlchemy engine/sessionmaker and transaction-local RLS context reset. |
| `backend/app/core/auth.py` | Created | PyJWT HS256 validation, `exp` enforcement, anonymous-token rejection, and `UserClaims` dependency. |

### PR2 Part B (tasks 2.3, 2.4)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/app/api/routes_health.py` | Created | FastAPI router for `GET /api/v1/health` returning `{"status":"ok"}`. |
| `backend/app/api/routes_auth.py` | Created | FastAPI router for `GET /api/v1/auth/me`; sets RLS context and reads own `patient_profiles` row. |
| `backend/app/main.py` | Modified | Replaced inline health route with `include_router` for `/api/v1` health and auth routers; kept `/docs` and `/api/v1/openapi.json`. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked 2.3 and 2.4 complete. |

### PR3 Part A (Task 3.1)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/app/exercises/__init__.py` | Created | Package marker. |
| `backend/app/exercises/constants.py` | Created | Plain-Python static definition of the single seeded mindfulness exercise `EX_1`; dependency-free so the catalog contract can be asserted without runtime packages. |
| `backend/app/exercises/models.py` | Created | SQLAlchemy 2.0 ORM models for `exercises`, `exercise_sessions`, and `exercise_telemetry` matching the additive migration schema and RLS ownership columns. |
| `backend/app/exercises/schemas.py` | Created | Pydantic response schema `ExerciseResponse` with `from_attributes` for ORM serialization. |
| `backend/app/exercises/repository.py` | Created | Async repository functions `list_exercises` and `get_exercise_by_id` for catalog access. |
| `backend/app/exercises/service.py` | Created | Service functions `list_catalog`, `get_catalog_item`, and `get_seeded_catalog`; DB-bound functions lazily import repository to keep the static catalog importable without installed dependencies. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked Task 3.1 complete. |

### PR3 Part B (Task 3.2)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/app/api/routes_exercises.py` | Created | FastAPI router for authenticated `GET /api/v1/exercises` and `GET /api/v1/exercises/{exercise_id}`; uses `get_current_user`, request-scoped DB session, and RLS context reset; returns 404 for unknown exercise ids. |
| `backend/app/main.py` | Modified | Imported and included `routes_exercises.router` under `/api/v1`. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked Task 3.2 complete. |

### PR3 Part C (Task 3.3)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/app/exercises/schemas.py` | Modified | Added `SessionStartResponse`, `CompleteRequest`, and `CompleteResponse` Pydantic schemas. |
| `backend/app/exercises/repository.py` | Modified | Added `create_session`, `get_session_by_id_for_update` (with `FOR UPDATE`), and `create_telemetry`. |
| `backend/app/exercises/service.py` | Modified | Added `start_exercise`, `complete_exercise`, domain exceptions, and idempotent completion logic that records the four telemetry variables required by the completion contract. |
| `backend/app/api/routes_exercises.py` | Modified | Added authenticated `POST /api/v1/exercises/{exercise_id}/start` (201) and `POST /api/v1/exercises/{exercise_id}/complete` endpoints with RLS context reset and explicit `db.commit()`. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked Task 3.3 complete. |

### PR3 Part D (Task 3.4)

| File | Action | What Was Done |
|------|--------|---------------|
| `backend/app/exercises/service.py` | Modified | Added explicit `session.patient_id != patient_id` ownership predicate to `complete_exercise` as defense in depth, preserving the existing RLS ownership enforcement. |
| `scripts/assert-nivel-1-2-telemetry-3_4.py` | Created | Deterministic AST assertion that `complete_exercise` inserts exactly the four telemetry variables once on active completion and none on the already-completed path, and that patient ownership is checked explicitly. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked Task 3.4 complete. |

### Task 4.1 (Verification Harness Slice)

| File | Action | What Was Done |
|------|--------|---------------|
| `scripts/test-nivel-1-2-backend.sh` | Created | Deterministic Bash/curl/psql smoke test covering health, OpenAPI/docs, JWT failure modes, `/auth/me`, exercise catalog, start/complete/idempotency, and direct RLS reads as the patient role. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked Task 4.1 complete. |

### Task 4.2 (Verification Harness Hardening)

| File | Action | What Was Done |
|------|--------|---------------|
| `scripts/test-nivel-1-2-backend.sh` | Modified | Hardened harness: kept patients A/B, added `curl_capture` to record body and HTTP status from a single request, wrapped direct PostgreSQL RLS queries in an explicit transaction as role `authenticated` with transaction-local identity, replaced tautological RLS assertions with service-role expected counts and explicit cross-patient checks, and extended cleanup to remove synthetic sessions/telemetry. |
| `openspec/changes/nivel-1-2-backend-minimo/tasks.md` | Modified | Marked Task 4.2 complete. |
| `openspec/changes/nivel-1-2-backend-minimo/apply-progress.md` | Modified | Merged Task 4.2 evidence and status. |

## Work Unit Evidence

### PR1 Foundation (tasks 1.1–1.3)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `docker compose config -q`: exit 0, no output |
| | `python3 -c "import pathlib, tomllib; tomllib.loads(pathlib.Path('backend/pyproject.toml').read_text())"`: exit 0, no output |
| Parent independent spot check | `git diff --check`: exit 0, no output (after budget correction) |
| Runtime harness command/scenario and exact result | `N/A` — this slice is static foundation/infrastructure wiring. No running service boundary is required; the backend container and Alembic baseline are not executed until the database and additive schema slice are in place. |
| Rollback boundary | Revert `docker-compose.yml` and `.env.example`, delete `backend/` directory. No Nivel 1.1 files are modified. |

### PR2 Part A (tasks 1.4, 2.1, 2.2)

| Evidence | Required value |
|---|---|
| Focused tests | `docker compose config -q`: exit 0; `python3 -c "...tomllib..."`: exit 0; `git diff --check`: exit 0 |
| Runtime harness | `N/A` — schema and core auth/DB wiring; no HTTP routes changed in this slice. |
| Rollback boundary | Delete `backend/app/core/` and `backend/alembic/versions/20260912_nivel12_additive.py`; run `alembic downgrade nivel11_baseline`. `backend/app/main.py` is unchanged from PR1. |

### PR2 Part B (tasks 2.3, 2.4)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `docker compose config -q`: exit 0, no output |
| | `python3 -c "import pathlib, tomllib; tomllib.loads(pathlib.Path('backend/pyproject.toml').read_text())"`: exit 0, no output |
| | `python3 -m py_compile backend/app/api/routes_health.py backend/app/api/routes_auth.py backend/app/main.py`: exit 0, no output |
| | `git diff --check`: exit 0, no output |
| Runtime harness command/scenario and exact result | `N/A` — this slice adds protected HTTP routes but does not start the service or exercise flows; the full HTTP smoke harness is intentionally deferred to the exercise/harness slice (tasks 3.x–4.x). |
| Rollback boundary | Revert `backend/app/main.py` to PR1 state and delete `backend/app/api/routes_health.py` and `backend/app/api/routes_auth.py`. No core auth, DB, or schema files are touched. |

### PR3 Part A (Task 3.1)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `python3 -m compileall -q backend/app/exercises`: exit 0, no output |
| | `git diff --check`: exit 0, no output |
| | Static catalog assertion: `python3 -c "import sys; sys.path.insert(0, 'backend'); from app.exercises.constants import SEEDED_EXERCISES; assert len(SEEDED_EXERCISES) == 1; assert SEEDED_EXERCISES[0]['id'] == 'EX_1'; assert SEEDED_EXERCISES[0]['type'] == 'mindfulness'; print('OK: exactly one seeded mindfulness exercise EX_1')"`: exit 0, prints `OK: exactly one seeded mindfulness exercise EX_1` |
| Runtime harness command/scenario and exact result | `N/A` — this slice creates domain models, repository, and service code only; no HTTP routes or running service boundary is introduced. Runtime verification is deferred to the routes/harness slice (tasks 3.2–4.3). |
| Rollback boundary | Delete `backend/app/exercises/`. No prior approved work (`backend/app/core/`, `backend/app/api/`, `backend/app/main.py`, `backend/alembic/`, `docker-compose.yml`, `.env.example`) is modified. |

### PR3 Part B (Task 3.2)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `python3 -m compileall -q backend/app`: exit 0, no output |
| | `git diff --check`: exit 0, no output |
| | AST/static route assertion (see Verification Results): exit 0, prints route/auth/no-start-complete confirmation |
| Runtime harness command/scenario and exact result | `N/A` — this slice adds protected HTTP routes but does not start the service or exercise flows; the full HTTP smoke harness is intentionally deferred to Tasks 3.3–4.3. |
| Rollback boundary | Delete `backend/app/api/routes_exercises.py` and revert the two-line `routes_exercises` import/include in `backend/app/main.py`. No Task 3.1 domain code, auth/DB core, or schema files are touched. |

### PR3 Part C (Task 3.3)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `python3 -m compileall -q backend/app`: exit 0, no output |
| | `git diff --check`: exit 0, no output |
| | AST/static route assertion (see Verification Results): exit 0, prints start/complete route/auth/commit confirmation |
| Runtime harness command/scenario and exact result | `N/A` — this slice adds protected HTTP routes and session/telemetry domain code but does not start the service or run the full smoke harness; the runtime HTTP smoke harness is intentionally deferred to Tasks 4.1–4.3. |
| Rollback boundary | Revert the four modified files (`backend/app/exercises/schemas.py`, `backend/app/exercises/repository.py`, `backend/app/exercises/service.py`, `backend/app/api/routes_exercises.py`) to their Task 3.2 state. No prior approved work is modified outside these files. |

### PR3 Part D (Task 3.4)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `python3 -m compileall -q backend/app`: exit 0, no output |
| | `python3 scripts/assert-nivel-1-2-telemetry-3_4.py`: exit 0, prints `OK: exactly four telemetry variables persisted once on active completion; none on idempotent path; patient ownership enforced` |
| | `git diff --check`: exit 0, no output |
| Runtime harness command/scenario and exact result | `N/A` — this slice refines the telemetry persistence contract and adds a focused AST-based proof; the end-to-end HTTP smoke harness that exercises real database persistence is intentionally deferred to Tasks 4.1–4.3. |
| Rollback boundary | Revert the two-line ownership predicate addition in `backend/app/exercises/service.py` and delete `scripts/assert-nivel-1-2-telemetry-3_4.py`. No prior approved work outside these files is modified. |

### Task 4.1 (Verification Harness Slice)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `bash -n scripts/test-nivel-1-2-backend.sh`: exit 0, no output |
| | `git diff --check`: exit 0, no output |
| Runtime harness command/scenario and exact result | `./scripts/test-nivel-1-2-backend.sh`: exited 1 with `[ENV FAIL] Backend not reachable at http://localhost:8001/api/v1/health (HTTP 000)`. The local `backend` service is not running (`curl` returned HTTP 000), so the end-to-end HTTP/database assertions could not execute. The script is structurally complete and ready to run once the backend container is healthy. |
| Rollback boundary | Delete `scripts/test-nivel-1-2-backend.sh`. No prior approved backend code, migrations, or infrastructure files are modified. |

### Task 4.2 (Verification Harness Hardening)

| Evidence | Required value |
|---|---|
| Focused test command and exact result | `bash -n scripts/test-nivel-1-2-backend.sh`: exit 0, no output |
| | `git diff --check`: exit 0, no output |
| Corrective rerun evidence | Gate failure discovered at `scripts/test-nivel-1-2-backend.sh:104-110`: cleanup required both patient IDs to be set, so partial fixture creation would leave synthetic data behind. Corrected by replacing the all-or-nothing `cleanup()` block with a `cleanup_patient()` helper invoked per existing patient; deletion predicates remain specific to each patient's own sessions/telemetry/profile/auth user. |
| Runtime harness command/scenario and exact result | `N/A` — full integration test (Task 4.3) was intentionally not run per scope restrictions; the harness will be executed when the backend service is available. |
| Rollback boundary | Revert `scripts/test-nivel-1-2-backend.sh` to the Task 4.1 version. No backend code, migrations, credentials, or other harness files are modified. |

## Verification Results

- `python3 -m compileall -q backend/app`: exit 0
- `git diff --check`: exit 0
- AST/static route assertion (Task 3.3): exit 0, `OK: start/complete routes registered with auth dependency and commit calls`
- Telemetry persistence assertion (Task 3.4): exit 0, `OK: exactly four telemetry variables persisted once on active completion; none on idempotent path; patient ownership enforced`
- `bash -n scripts/test-nivel-1-2-backend.sh` (Task 4.1): exit 0, no output
- `./scripts/test-nivel-1-2-backend.sh` (Task 4.1): exit 1, `[ENV FAIL] Backend not reachable at http://localhost:8001/api/v1/health (HTTP 000)`
- `bash -n scripts/test-nivel-1-2-backend.sh` (Task 4.2): exit 0, no output
- `git diff --check` (Task 4.2): exit 0, no output
- Full integration test `./scripts/test-nivel-1-2-backend.sh` was NOT run for Task 4.2 per the authorized scope.

## Changed-Line Count

### PR1 Foundation (historical)

- Additions: 265
- Deletions: 1
- **Total changed lines: 398** (266 code + 52 tasks.md + 80 apply-progress.md)

### PR2 Part A (historical)

- **Total changed lines: 398** — authored scope for tasks 1.4, 2.1, and 2.2 (code, `tasks.md`, and `apply-progress.md` updates), within the 400-line review budget.

### PR2 Part B (historical)

- Code: 13 (`routes_health.py`) + 50 (`routes_auth.py`) + 7 net (`main.py` modifications) = ~70 authored code lines
- `tasks.md`: 2 checkbox marks
- `apply-progress.md`: ~70 lines of merged progress + new PR2 Part B section
- **Total changed lines: ~142** for this work unit, well within the 400-line review budget.

### PR3 Part A (historical)

- Code: 1 (`__init__.py`) + 22 (`constants.py`) + 92 (`models.py`) + 14 (`schemas.py`) + 18 (`repository.py`) + 27 (`service.py`) = 174 authored code lines
- `tasks.md`: 1 checkbox mark
- `apply-progress.md`: ~80 lines of merged progress + new PR3 Part A section
- **Total changed lines: ~255** for this work unit, within the 400-line review budget.

### PR3 Part B (historical)

- Code: 37 (`routes_exercises.py`) + 2 net (`main.py` import/include) = 39 authored code lines
- `tasks.md`: 1 checkbox mark
- `apply-progress.md`: ~50 lines of merged progress + new PR3 Part B section
- **Total changed lines: ~90** for this work unit, well within the 400-line review budget.

### PR3 Part C (historical)

- Code: 36 (`schemas.py`) + 42 (`repository.py`) + 104 (`service.py`) + 74 (`routes_exercises.py`) = 256 authored code lines
- `tasks.md`: 2 line changes (1 checkbox mark)
- `apply-progress.md`: 47 line changes
- **Total changed lines: 305** (292 insertions + 13 deletions) for this work unit, within the 400-line review budget.

### PR3 Part D (current)

- Code: 6 changed lines in `backend/app/exercises/service.py` (explicit ownership predicate) + 155 lines in `scripts/assert-nivel-1-2-telemetry-3_4.py`
- `tasks.md`: 2 changed lines (1 checkbox mark)
- `apply-progress.md`: 42 changed lines
- **Total changed lines: 205** for this work unit, well within the 400-line review budget.

### Task 4.1 (current)

- Code: 249 lines in `scripts/test-nivel-1-2-backend.sh`
- `tasks.md`: 1 checkbox mark
- `apply-progress.md`: ~45 lines of merged progress + new Task 4.1 section
- **Total changed lines: ~295** for this work unit, within the 400-line review budget.

### Task 4.2 (current)

- Code: ~55 changed lines in `scripts/test-nivel-1-2-backend.sh`
- `tasks.md`: 1 checkbox mark
- `apply-progress.md`: ~35 lines of merged progress + new Task 4.2 section
- **Total changed lines: ~91** for this work unit, well within the 400-line review budget.

## Remaining Tasks

- [x] 4.2 Add harness fixtures/helpers in `scripts/test-nivel-1-2-backend.sh` for two patients and direct patient-role database queries.
- [ ] 4.3 Run `bash scripts/test-nivel-1-2-backend.sh` and record failures before applying fixes, then require exit 0.

## Deviations from Design

None — implementation matches design.

## Issues Found

- **Cleanup gate failure (corrected in this rerun)**. `scripts/test-nivel-1-2-backend.sh:104-110` ran cleanup only when both `PA_ID` and `PB_ID` were non-empty. If fixture creation was partial (e.g., only patient A created successfully), the trap would leave synthetic sessions, telemetry, profile rows, and auth users in the database. The fix introduces `cleanup_patient()` and calls it independently for each existing patient ID, preserving the original per-patient deletion predicates (sessions/telemetry/profile/auth user scoped to that patient only). The correction was applied before runtime integration, and no other behavior was changed.

## Risks

- `backend_app` password is set from `POSTGRES_PASSWORD` during migration; a populated `.env` is required for the backend container to connect.
- `/auth/me` relies on the Nivel 1.1 `auth.uid()` primitive reading `request.jwt.claim.sub`; the transaction-local RLS context reset must be called before every protected query.
- Future exercise models in other domains may want a shared declarative base; `Base` is currently local to `backend/app/exercises/models.py` to avoid modifying prior approved work.
- Task 3.3 start/complete routes must be registered after `/exercises/{exercise_id}` to avoid path-shadowing; the current slice leaves room for that ordering.

## Status

- PR1 foundation (tasks 1.1–1.3): applied and merged previously.
- PR2 Part A (tasks 1.4, 2.1, 2.2): applied, verified, and native attempt settlement completed.
- PR2 Part B (tasks 2.3, 2.4): applied, verified, and native attempt settlement completed.
- PR3 Part A (Task 3.1): applied and verified; native attempt settlement completed.
- PR3 Part B (Task 3.2): applied and verified; native attempt settlement completed.
- PR3 Part C (Task 3.3): applied and verified; native attempt settlement pending parent.
- PR3 Part D (Task 3.4): applied and verified; native attempt settlement pending parent.
- Task 4.1: script implemented, syntax check passed, and runtime harness attempted. End-to-end execution is blocked because the local backend service is not running (HTTP 000 from `curl http://localhost:8001/api/v1/health`).
- Task 4.2: one authorized corrective rerun completed. The partial-fixture cleanup gate failure in `scripts/test-nivel-1-2-backend.sh:104-110` was discovered and fixed; static checks (`bash -n`, `git diff --check`) pass. Full integration execution remains deferred to Task 4.3.
- Task 4.3: completed — final integration `/tmp/behavioros-task43-verified.log`, PASS=50, FAIL=0, exit=0.
- Generation-18 remediation: completed (see below).

## Generation-18 Remediation — Post-1.2 configuration and imgproxy security stabilization

**Work unit**: Post-1.2 configuration and imgproxy security stabilization
**Evidence goal**: Resolve Compose variable warnings; secure imgproxy file access and signing compatibly with Storage; verify behavior without data loss.
**Mode**: Standard (strict TDD not active)
**Max attempts**: 1
**Attempt token**: `sha256:9f68f5dfd43ac3cc7e9041e912afaaaa8864a14178e00666b57fe993b6fb4d7f`

### Baseline

- `docker compose config` and `docker compose --env-file .env config` both exited 0 with 6 interpolation warnings: 3x `BACKEND_DB_USER`, 3x `BACKEND_DB_PASSWORD`.
- Backend health endpoint returned HTTP 200, `{"status":"ok"}`.
- Temporary Storage/imgproxy render probe succeeded end-to-end: bucket create 200, upload 200, transformed render 200 `image/png`, object delete 200, bucket delete 200, matching bucket count 0.
- imgproxy v3.8.0 had no key/salt; Storage v1.0.6 emitted unsigned `local://` requests.

### Changes Applied

| File | Action | What Was Done |
|---|---|---|
| `.env` | Modified | Reordered `BACKEND_DB_USER` and `BACKEND_DB_PASSWORD` assignments before `DATABASE_URL`; moved `MIGRATION_DATABASE_URL` after `DATABASE_URL` to keep backend-related DB variables contiguous. No credential values changed, printed, or exposed. |
| `.env.example` | Modified | Reordered `BACKEND_DB_USER` and `BACKEND_DB_PASSWORD` assignments before `DATABASE_URL`; moved associated comments and `MIGRATION_DATABASE_URL` accordingly. No values changed. |
| `docker-compose.yml` | Modified | Added `IMGPROXY_ALLOWED_SOURCES: "local://"` to imgproxy service to restrict source URLs to the local filesystem transport used by Storage. |

### Verification Results

| Command | Result |
|---|---|
| `docker compose config >/dev/null` | exit 0, no interpolation warnings |
| `docker compose --env-file .env config >/dev/null` | exit 0, no interpolation warnings |
| `git diff --check` | exit 0, no output |
| `docker compose up -d --no-deps --force-recreate imgproxy` | Container `behavioralos-imgproxy` recreated and healthy |
| `docker compose ps` | All services up; backend and imgproxy healthy |
| `curl -fsS -o /dev/null -w '%{http_code}\n' http://localhost:8001/api/v1/health` | `200` |
| Storage/imgproxy probe (create bucket, upload PNG, render 100x100, delete object, delete bucket, audit count) | HTTP 200 at every step; rendered `image/png`; matching bucket count 0 |

### Limitations and Decisions

- `IMGPROXY_KEY` and `IMGPROXY_SALT` were NOT added; enabling signed URLs would break compatibility with Storage v1.0.6, which emits unsigned requests.
- `IMGPROXY_LOCAL_FILESYSTEM_ROOT` was NOT changed from `/` to `/var/lib/storage`. imgproxy logs show Storage requests target `local:////var/lib/storage/...`; changing the root would duplicate the `/var/lib/storage` prefix and break rendering. This hardening was rejected based on real probe evidence rather than invented path rewrites.
- The `.env` file is untracked, so its structural reorder does not appear in `git diff`; the change is captured in filesystem state and this artifact.

### Rollback / Reversion

- Reorder: move `BACKEND_DB_USER`, `BACKEND_DB_PASSWORD`, and `MIGRATION_DATABASE_URL` back to their prior positions in `.env` and `.env.example`.
- imgproxy restriction: remove `IMGPROXY_ALLOWED_SOURCES: "local://"` from `docker-compose.yml` and run `docker compose up -d --no-deps --force-recreate imgproxy`.
- These changes are independent of Nivel 1.1 and of the completed Tasks 1.1–4.3 implementation.

### Risks

- `IMGPROXY_ALLOWED_SOURCES: "local://"` prevents imgproxy from fetching HTTP(S) sources, which matches current Storage behavior but would need revisiting if Storage is later configured to use S3 or other remote sources.
- The root-path duplication risk means `IMGPROXY_LOCAL_FILESYSTEM_ROOT` cannot be safely tightened without a coordinated Storage-side URL change.
- `.env` is untracked; new environments must copy the reordered `.env.example` before warnings are resolved.

### Status

- Remediation complete. No tasks advanced or altered. Verification evidence refreshed for generation-18 objective.

## Task 4.3 — Backend integration execution

- Initial execution recorded in `/tmp/behavioros-task43-first-run.log`: shell environment expansion failed under `nounset`.
- Second execution recorded in `/tmp/behavioros-task43-second-run.log`: JWT helper referenced a local variable before initialization; subsequent integration assertions failed.
- Third execution recorded in `/tmp/behavioros-task43-third-run.log`: PASS=35, FAIL=12. Diagnosed missing SQLAlchemy metadata for `auth.users` and an incompatible no-profile test fixture.
- Fourth execution recorded in `/tmp/behavioros-task43-fourth-run.log`: PASS=47, FAIL=1. Remaining issue was the harness interpreting JSON null as Python `None`.
- Corrected environment loading, JWT helper, reference-only ORM metadata, synthetic patient B profile fixture, and JSON-null assertion.
- Final integration: `/tmp/behavioros-task43-verified.log`, PASS=50, FAIL=0, exit=0.
- Verified nonempty patient A sessions and telemetry before direct patient-role RLS assertions.
- Post-run audit found zero synthetic users; Bash syntax and `git diff --check` passed.
- Deployment limitation: the corrected ORM model was copied into the running backend container. The existing Docker image has not been rebuilt or independently verified with the correction.
- Cleanup limitation: the harness suppresses individual cleanup SQL errors; the post-run synthetic-user count was verified as zero.
- Scope: Nivel 1.2 only; no intentional modifications to archived Nivel 1.1, database volumes, or existing secrets.

## Generation-19 Verification — Backend Docker image reproducibility

**Work unit**: Post-1.2 backend Docker image reproducibility  
**Evidence goal**: Build the backend image from the repository and verify corrected SQLAlchemy metadata and migrations in isolation, without replacing running services or altering persistent data.  
**Mode**: Standard (strict TDD not active)  
**Attempt token**: `sha256:d6707b6d5c7e64fb4d12caddb6bf13c80cc8c627c30cfddfa1c70cbf6f588c35`

### Baseline Comparison

| Target | Image / Binding | `models.py` SHA-256 | Result |
|---|---|---:|---|
| Repository | `backend/app/exercises/models.py` | `d480f8f44477c2a7d86757219f343d73d681a7001dd1eafd5869daddff7e4efd` | Contains reference-only `auth.users` SQLAlchemy metadata and `auth.users.id` FK. |
| Operational image | `behavioralos-backend:latest`, image ID `sha256:58acf79c86a28c419d4819cce39dbb78dbb59ca12ab9a774f207e1e5e2dc6783`, created `2026-09-19T03:20:09.333599964Z` | `28f125bed7dbac9d0fba07a833dafaad4578b9a73e20cf270f2cb12229c041f3` | Stale relative to repository. |
| Live container | `behavioralos-backend`, bound to image ID `sha256:58acf79c86a28c419d4819cce39dbb78dbb59ca12ab9a774f207e1e5e2dc6783`, container created `2026-09-19T05:41:13.670943644Z`, started `2026-10-03T17:51:36.653861966Z` | `d480f8f44477c2a7d86757219f343d73d681a7001dd1eafd5869daddff7e4efd` | `docker diff` reports `C /app/app/exercises/models.py`; live container contains a manual mutation relative to its image. |
| New isolated image | `behavioros-backend:gen19-repro-d6707b6d`, image ID `sha256:098eb6501e20c8ceceb2255058c2ae1bac1a8aafc6a18865be480cd0aad41c65`, created `2026-10-03T19:12:21.550952127Z` | `d480f8f44477c2a7d86757219f343d73d681a7001dd1eafd5869daddff7e4efd` | Rebuilt from repository and matches repository source. |

### Build Evidence

| Command | Result |
|---|---|
| `DOCKER_BUILDKIT=1 docker build --progress=plain -f backend/Dockerfile -t behavioros-backend:gen19-repro-d6707b6d backend` | exit 0; build context was `backend`; Dockerfile copied `pyproject.toml`, installed editable package dependencies, then copied `app`, `alembic`, and `alembic.ini`. |

### Isolated Verification Results

| Check | Command / Scope | Result |
|---|---|---|
| New image source hash | `docker run --rm --network none --entrypoint python behavioros-backend:gen19-repro-d6707b6d -c ...` | SHA-256 `d480f8f44477c2a7d86757219f343d73d681a7001dd1eafd5869daddff7e4efd`; matches repository. |
| SQLAlchemy metadata | Import `app.exercises.models`, assert `Base.metadata.tables` contains `auth.users`, and assert `ExerciseSession.patient_id` FK resolves to schema `auth` | exit 0; `OK auth.users metadata and patient FK target schema=auth`. |
| Python dependencies | `docker run --rm --network none --entrypoint python behavioros-backend:gen19-repro-d6707b6d -m pip check` | exit 0; `No broken requirements found.` |
| Alembic files present | Assert `/app/alembic/env.py`, `/app/alembic.ini`, and both Nivel 1.1/1.2 revisions exist | exit 0; expected files present. |
| Alembic head | `docker run --rm --network none --entrypoint alembic behavioros-backend:gen19-repro-d6707b6d heads` | exit 0; `nivel12_additive (head)`. |
| FastAPI/module imports | Import `app.main`, API routers, models, and service with dummy non-operational env vars and `--network none` | exit 0; `OK imported app modules`. |
| Container startup from image bytes | `docker run -d --name behavioros-backend-gen19-repro-d6707b6d --network bridge -p 127.0.0.1:18001:8001 ... behavioros-backend:gen19-repro-d6707b6d` | Container ran from image ID `sha256:098eb6501e20c8ceceb2255058c2ae1bac1a8aafc6a18865be480cd0aad41c65`; `mounts=0`, network `bridge`; no bind-mounted source. |
| Non-DB HTTP checks | `GET /`, `GET /docs`, `GET /api/v1/openapi.json` on `127.0.0.1:18001` | `/` redirected to docs with HTTP 200; `/docs` returned HTTP 200 HTML; OpenAPI returned HTTP 200 with expected Nivel 1.2 paths. |
| DB-bound health behavior | `GET /api/v1/health` with dummy `DATABASE_URL=postgresql+asyncpg://dummy:dummy@127.0.0.1:1/dummy` | HTTP 500 with `ConnectionRefusedError`, expected because no operational or disposable database was attached. |
| Ephemeral test container cleanup | `docker rm -f behavioros-backend-gen19-repro-d6707b6d` | Removed only the isolated test container; the independent image was intentionally kept. |

### Limitations and Non-Executed Checks

- Full `/api/v1/health` success and authenticated exercise flows were not executed because they require a database. This phase intentionally did not connect to the operational Compose network or operational database, and no disposable database/migration environment was created within the bounded verification slice.
- Alembic migrations were not run against any existing database. Only migration presence and Alembic head discovery were verified inside the image.
- The operational backend image tag and running service were not replaced, recreated, or rebound to the new image.

### Acceptance Disposition

- PASS: repository Docker build produces an independent backend image containing the corrected `models.py` bytes.
- PASS: the new image contains the expected reference-only `auth.users` metadata and Alembic migration files.
- PASS: Python dependencies are internally consistent and application modules import under safe dummy settings.
- PASS WITH LIMITATION: process startup and non-DB HTTP routes work from image bytes without bind mounts; DB-backed behavior was not fully re-exercised in this isolated phase.

### Maintainer Notes

- Detect a stale image by comparing the repository file hash, the same file hash inside the image, and the live container hash, then compare the container's bound image ID with the inspected image ID. A live container matching source while its image does not match source indicates a manual container mutation.
- `docker cp` or editing files inside a running container is not reproducible because the changed bytes live in that container's writable layer, not in the Dockerfile or image history. The next container created from the same image will not contain those changes.
- Verify a newly built image by building from the correct context, inspecting the new image ID/tag, and running hash plus semantic assertions inside the image before replacing any service.

### Status

- Generation-19 bounded verification complete.
- Operational image, operational backend container, operational Compose network, and operational database were untouched.
- `finish`, settlement, reset, rescope, archive, commit, push, cleanup/prune, credential regeneration, service replacement, and volume deletion were not run.

### Disposable database continuation — isolated schema bootstrap blocked

**Continuation objective**: Continue generation-19 verification with the already-built image `behavioros-backend:gen19-repro-d6707b6d` and a disposable database only. No image build/rebuild was run.

**Isolation setup used**:

- Disposable networks and containers were created with unique `behavioros-gen19disp-*` names only.
- Disposable database image: `supabase/postgres:15.1.1.78`, matching the repository Compose declaration.
- Disposable backend image: `behavioros-backend:gen19-repro-d6707b6d`, retained after cleanup.
- No bind mounts, named volumes, operational Compose network attachment, or operational database connection were used for the disposable containers.
- Operational pre-checks observed `behavioralos-backend`, `behavioralos-db`, and `behavioralos-auth` still attached only to `behavioralos-network`; the operational network ID remained `86b65d5fcf11288813ced8d6b4a98101fc8ad568e22dcbc1740d26573749edea` with 9 containers during the checks.

**Executed command results**:

| Scope | Result |
|---|---|
| Start disposable DB on unique network | Passed. DB container reported `mounts=0`, attached only to its unique network, and `pg_isready` passed. |
| Pre-write isolation query | Passed. Target database was `postgres` in the disposable container. It had `auth.users` but not `auth.sessions`. |
| Apply Nivel 1.1 repository SQL migrations in sorted order | Failed at `migrations/20260909040000_nivel_1_1_audit_writer.sql`; PostgreSQL raised `ERROR: relation "auth.sessions" does not exist` while creating login/logout audit triggers. |
| Diagnose missing dependency with isolated GoTrue | Attempted with `supabase/gotrue:v2.158.1` and test-local settings only. GoTrue could not reliably bootstrap over the pre-existing partial `auth` schema in `supabase/postgres:15.1.1.78`; the final failure was `ERROR: type "auth.factor_type" does not exist` during `20240729123726_add_mfa_phone_config.up.sql`. |
| Repository DB init scripts | `volumes/db/roles.sql` cannot be safely replayed post-init with `psql -U postgres` in this image because reserved roles cannot be modified that way; `volumes/db/jwt.sql` likewise failed post-init with `permission denied to set parameter "app.settings.jwt_secret"`. These are Compose init scripts, not safe post-init migrations. |
| Alembic upgrade from independent backend image | Not executed. The disposable database did not reach the required Nivel 1.1 baseline because `auth.sessions` was absent. |
| Backend startup against disposable DB | Not executed. Starting the backend would be misleading before the required baseline and Alembic upgrade completed. |
| DB-backed functional checks | Not executed. The existing 50-check harness requires a fully bootstrapped local Supabase Auth/Kong topology or equivalent auth schema; the isolated topology could not reach that state without fabricating missing Auth schema internals. |

**Cleanup proof**:

- Failed disposable runs were cleaned by the bounded trap.
- Post-cleanup checks for each attempted `gen19disp-*` suffix returned `0` matching containers and `0` matching networks.
- No broad cleanup, prune, operational volume deletion, service recreation, or image removal was run.
- The independent backend image was intentionally kept.

**Acceptance disposition**:

- PASS: disposable container/network isolation was enforced before any write.
- PASS: cleanup removed only the disposable harness resources.
- FAIL: disposable schema bootstrap could not reach the Nivel 1.1 baseline from repository SQL plus declared images in this isolated topology.
- UNEXECUTED: Alembic upgrade, `/api/v1/health` against the disposable DB, and DB-backed functional checks from the independent image.

**Primary failure and consequence**:

- Primary failure: the repository's Nivel 1.1 audit migration assumes `auth.sessions`, but `supabase/postgres:15.1.1.78` starts with `auth.users` and no `auth.sessions` in this disposable DB-only topology.
- Verification consequence: generation-19 cannot be accepted as fully DB-backed in disposable isolation yet; the prior image-only evidence remains valid, but runtime DB-backed acceptance is blocked.

**Governance confirmation**:

- No source/config/spec/design/tasks/completed-task files were modified except this evidence continuation.
- `finish`, settlement, reset, rescope, archive, commit, push, prune, credential regeneration, operational service replacement, and operational volume deletion were not run.

**Changed-line count for this continuation**: 50 lines appended to `openspec/changes/nivel-1-2-backend-minimo/apply-progress.md`.

### Attempt 20 continuation — canonical Auth-first disposable bootstrap verified

**Native authority**: parent-confirmed token `sha256:1e7e5773d80fa849f6fac844756cd52ed3e575b69f4397b8ad75a718bf5e0f39`; settlement is remediation-bound to failed evidence `sha256:19a1c1e7957f53a928fac4db7acd607f126e564ebdaf2c0bbfdb15462612bb76`. `finish`, settlement, reset, rescope, archive, commit, push, prune, credential regeneration, operational service replacement, and operational volume deletion were not run.

**Canonical bootstrap ownership/order proven**:

1. `supabase/postgres:15.1.1.78` plus repository DB init scripts owns base database roles/settings/webhooks and initially exposes `auth.users` but not the complete GoTrue Auth schema (`auth.sessions` was `NULL` before Auth startup).
2. `supabase/gotrue:v2.158.1` owns the complete Auth migration chain. Starting GoTrue against the fresh initialized DB created `auth.sessions`, `auth.factor_type`, and `auth.schema_migrations` with 59 rows. No Auth tables, enums, migration rows, or functions were fabricated.
3. Repository Nivel 1.1 SQL migrations apply only after GoTrue completes Auth ownership. In sorted order they then created/verified `patient_profiles`, `audit_logs`, and the `trg_audit_login` trigger on `auth.sessions`.
4. The repository backend role provisioning step is required before Nivel 1.2 Alembic because the additive migration grants privileges to `backend_app`.
5. Nivel 1.2 Alembic then upgraded from `behavioros-backend:gen19-repro-d6707b6d` to `nivel12_additive` and seeded `EX_1`.

**Isolation proof**:

- Created only attempt-20 resources: `behavioros-gen19-attempt20-net`, `behavioros-gen19-attempt20-db`, `behavioros-gen19-attempt20-auth`, and `behavioros-gen19-attempt20-backend`, all labeled `attempt=20` / `work_unit=gen19-repro`.
- The disposable DB was attached only to `behavioros-gen19-attempt20-net`; it had exactly three safe read-only repository mounts for `volumes/db/{webhooks,jwt,roles}.sql` and no named or operational data volume.
- The disposable backend was started from image ID `sha256:098eb6501e20c8ceceb2255058c2ae1bac1a8aafc6a18865be480cd0aad41c65` with `mounts=0` on the attempt network only.
- Operational pre/post checks showed `behavioralos-db`, `behavioralos-auth`, and `behavioralos-backend` remained on `behavioralos-network` with the same operational network ID `86b65d5fcf11288813ced8d6b4a98101fc8ad568e22dcbc1740d26573749edea`.

**Command/result summary**:

| Step | Result |
|---|---|
| Create attempt-20 network and disposable DB with repo init scripts read-only | Passed; DB healthy; target `postgres` database confirmed. |
| Pre-Auth schema inspection | `auth.users=auth.users`; `auth.sessions=NULL`. |
| Start isolated GoTrue `supabase/gotrue:v2.158.1` | Passed; `/health` returned 200. |
| Post-GoTrue schema inspection | `auth.sessions=auth.sessions`; `auth.factor_type=auth.factor_type`; `auth.schema_migrations=auth.schema_migrations`; migration rows `59`. |
| Apply repository SQL migrations `migrations/*.sql` in sorted order | Passed; `patient_profiles`, `audit_logs`, and `trg_audit_login` present. |
| Provision disposable `backend_app` role | Passed; test-local credentials were not printed. |
| Run Alembic from `behavioros-backend:gen19-repro-d6707b6d` | Passed; `alembic_version=nivel12_additive`, `public.exercises` present, `EX_1` count `1`. |
| Start backend image with no bind mounts against disposable DB | Passed; `/api/v1/health` returned HTTP 200. |
| Manual authenticated/backend exercise checks | Passed `33`, failed `0`. Covered health/docs/OpenAPI, JWT rejection cases, `/auth/me`, catalog, start, completion, idempotency, cancelled-session rejection, and direct RLS reads. |
| `scripts/test-nivel-1-2-backend.sh` | Not run: the script hardcodes `docker compose exec db`, so even with API/Kong endpoint overrides it would target the operational Compose DB, violating isolation. |
| Cleanup | Passed; only attempt-20 containers/network were removed; residual matching containers `0`, networks `0`; independent backend image retained. |

**Acceptance disposition**:

- PASS: canonical clean initialization order is Auth-first after DB init scripts, before BehaviorOS Nivel 1.1 SQL.
- PASS: independent backend image can run Alembic to head and serve `/api/v1/health` HTTP 200 against a fully disposable DB.
- PASS: manual isolated authenticated/exercise verification passed `33/33` checks.
- UNEXECUTED: repository harness script was not executed because its DB access path is operational-Compose-bound and unsafe for the isolated attempt-20 topology.
- PASS WITH LIMITATION: full evidence is runtime-backed in disposable isolation, but the existing harness needs a safe DB endpoint/container override before it can be executed without touching operational Compose.

**Canonical root cause of prior failed evidence**: the previous attempt applied BehaviorOS Nivel 1.1 SQL against a DB state where GoTrue had not first completed its Auth migration chain. `supabase/postgres:15.1.1.78` alone provides only a partial Auth baseline for this requirement; `auth.sessions` and `auth.factor_type` are GoTrue-owned migration outputs.

**Changed-line count for attempt 20 continuation**: 46 lines appended to `openspec/changes/nivel-1-2-backend-minimo/apply-progress.md`.
