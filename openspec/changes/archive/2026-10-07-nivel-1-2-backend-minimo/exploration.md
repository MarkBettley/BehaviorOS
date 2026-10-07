# Exploration: Nivel 1.2 — Backend mínimo

## Scope

Explore the minimum Nivel 1.2 backend slice that unlocks Nivel 1.3 (frontend básico), without implementing anything. Out of scope: frontend, landing, AI, full commerce, event sourcing, Behavioral Twin, ontology/graph, full clinical backend, advanced realtime, Nivel 1.3+ implementation, production deployment automation.

## Current State

Nivel 1.1 is archived and approved at `openspec/changes/archive/2026-09-10-nivel-1-1-seguridad-autenticacion/`. The local Supabase-aligned stack from Nivel 0.2 remains healthy and includes Postgres 15, GoTrue, PostgREST, Storage, Kong, Studio, and imgproxy.

Relevant runtime facts discovered:

- **No backend application code exists.** There is no `backend/` directory and no FastAPI/Python service in `docker-compose.yml`.
- **Backend environment variables are already declared** in `.env.example` (FastAPI host/port, `API_PREFIX=/api/v1`, database URL, Supabase keys, JWT settings, Redis placeholders), but they are not consumed by any service.
- **Nivel 1.1 migrations exist in `migrations/`** (untracked in git) and implement `auth.users` integration, `patient_profiles`, consent history, audit writer, and RLS matrix. The active migration path has not been moved under `supabase/migrations/`.
- **`docker-compose.yml` exposes Kong on port 8000** and there is no `backend` service. Any new FastAPI service must pick a non-conflicting port (`.env.example` suggests `APP_PORT=8001`).
- **No test runner is configured.** `openspec/config.yaml` reports `framework: NOT FOUND`, `strict_tdd: false`, and verification is bash/curl/psql via `scripts/healthcheck.sh`.
- **TimescaleDB, Redis, Temporal, and MinIO are not in the current `docker-compose.yml`**. The roadmap specs reference them for telemetry, cache/queues, workflows, and storage scaling, but they were omitted from Nivel 0.2.
- **`PGRST_DB_SCHEMAS=public,storage`** is configured; a FastAPI backend would connect directly to Postgres (not through PostgREST) and validate JWTs using `SUPABASE_JWT_SECRET`.
- **Main specs under `openspec/specs/`** now cover patient registration/auth, patient profile, consent management, audit logging, and security test harness from Nivel 1.1.

## Affected Areas

- `docker-compose.yml` — needs a new `backend` service (FastAPI/Uvicorn) and likely dependency ordering against `db`/`kong`.
- `.env.example` / `.env` — backend variables already exist but may need additions (e.g., backend image tag, OpenAPI path, exercise seed data).
- New `backend/` directory — FastAPI application, routers, models/schemas, settings, entrypoint, and dependency wiring.
- `migrations/` or `supabase/migrations/` — new schema migrations for the Nivel 1.2 exercise/telemetry domain.
- `scripts/` — new backend health/exercise smoke tests (bash/curl) until a test runner is adopted.
- `openspec/specs/200-Backend/` — source specs for API graph, database graph, transaction engine, and events/workflows.

## Analysis of Required Decisions

### 1. Minimum backend shape

The roadmap DoD requires: "API REST FastAPI con endpoints de auth y de 1 ejercicio terapéutico; esquema en Supabase; telemetría mínima del ejercicio persistida; contrato OpenAPI versionado."

Recommended minimum deliverables:

| Component | Purpose | Notes |
|---|---|---|
| FastAPI service container | Host `/api/v1` REST API | Uvicorn, auto-reload in dev, health endpoint |
| Auth router | Proxy/validate Supabase Auth flows | Reuse GoTrue for tokens; backend only validates JWT and reads `auth.users`/`patient_profiles` |
| Exercise router | List catalog, start session, complete session, submit telemetry | One concrete therapeutic exercise (product decision) |
| Exercise schema | `exercises_catalog`, `exercise_sessions`, `exercise_telemetry` | Align with `database-graph.md` §4.4 but minimal |
| Telemetry persistence | Store completion status, duration, score, and a few telemetry variables | JSONB/relational; defer TimescaleDB hypertables unless required |
| OpenAPI contract | `/openapi.json` and `/docs` | FastAPI generates this natively |

### 2. Auth integration boundary

Nivel 1.1 already provides:

- `auth.users` with UUID `sub`;
- immutable `patient` role in `raw_app_meta_data`;
- JWT validation by PostgREST/Kong;
- `patient_profiles` with RLS.

The backend MUST:

- Validate the Supabase JWT using `SUPABASE_JWT_SECRET` and HS256;
- Extract `sub` as the authenticated user id;
- Treat `app_metadata.app_role` as the authoritative app role (never `user_metadata`);
- Use `service_role` key only for admin/bootstrap operations, never expose it to clients.

Options for auth endpoint responsibility:

| Approach | Description | Pros | Cons |
|---|---|---|---|
| A. Backend owns `/auth/*` | FastAPI exposes `/api/v1/auth/login`, `/register`, `/refresh`, `/logout` and calls GoTrue internally | Single API surface for frontend; can add correlation/audit uniformly | More code; risk of duplicating GoTrue semantics |
| B. Frontend calls GoTrue directly; backend only validates JWT | Auth endpoints remain at Kong/GoTrue; FastAPI validates tokens on protected routes | Less backend code; matches Nivel 1.1 architecture | Frontend must manage two base URLs or Kong routing must proxy `/auth` |
| C. Hybrid — backend exposes thin `/auth/me` and token refresh helper | Direct GoTrue for signup/login; backend helpers for profile and refresh | Balanced; minimal duplication | Slightly fragmented auth surface |

**Recommended minimum for Nivel 1.2: Approach B for signup/login/logout** (keep GoTrue as the source of truth) **plus Approach A for `/auth/me` and refresh helper** if the frontend needs a unified backend surface. This avoids reimplementing GoTrue while giving the frontend a single `/api/v1` contract for exercise and profile data.

### 3. Where to place the backend service

| Approach | Description | Pros | Cons |
|---|---|---|---|
| A. Add `backend` service to `docker-compose.yml` | FastAPI container alongside Supabase services | Reproducible `docker compose up`; matches roadmap "backend desplegable localmente" | Adds build context/image; needs port 8001 free |
| B. Run FastAPI locally outside Docker | `uvicorn` on host against local Supabase | Fastest iteration; no Docker build | Not reproducible across machines; harder to verify |
| C. Hybrid — Dockerfile provided but not wired into compose | Developers run backend manually or extend compose | Flexible | Requires manual steps; weak verification |

**Recommendation: A** — add a `backend` service to `docker-compose.yml` with a local `Dockerfile` (or Python slim image with mounted source). This satisfies the DoD and keeps verification reproducible.

### 4. Exercise domain selection

The `database-graph.md` catalog defines many exercise types (`defusion`, `acceptance`, `values`, `exposure`, `mindfulness`, `regulation`, `social`, `neuropsychology`) and a full `exercises_catalog` table. Nivel 1.2 only needs **one** therapeutic exercise end-to-end.

Recommended minimum:

- Seed one exercise in `exercises_catalog` (e.g., a defusion or mindfulness exercise with metadata);
- Endpoints: `GET /api/v1/exercises`, `GET /api/v1/exercises/{id}`, `POST /api/v1/exercises/{id}/start`, `POST /api/v1/exercises/{id}/complete`;
- `exercise_sessions` records start/end/duration/completion_status/score;
- `exercise_telemetry` records a small set of variables (e.g., latency, errors, retries) as JSONB rows;
- Patient can only read/write their own sessions/telemetry (RLS).

This is a **product decision**: which process and mechanic the first exercise trains.

### 5. Database access layer

| Approach | Description | Pros | Cons |
|---|---|---|---|
| A. SQLAlchemy 2.0 + Alembic | Full ORM and migration tool as spec'd in `database-graph.md` | Mature, typed, matches long-term architecture | More setup; Alembic migration history must align with existing raw SQL migrations |
| B. `supabase-py` client | Use Supabase client from FastAPI | Simple for auth/RLS reads | Less control; not ideal for complex transactions |
| C. `asyncpg` + hand-written SQL | Lightweight async Postgres driver | Fast, explicit | More boilerplate; no migration framework |

**Recommendation: A** — SQLAlchemy 2.0 with async support and Alembic. This matches the project specs and the long-term backend architecture. Existing Nivel 1.1 raw SQL migrations can remain as baseline; Nivel 1.2 adds Alembic-managed migrations on top.

### 6. Schema and migration strategy

Current state:

- Nivel 1.1 migrations are in `migrations/` as raw SQL files (untracked in git).
- `supabase/migrations/` does not exist.
- `supabase/config.toml` uses imperative migrations (no `schema_paths`).

Options:

| Approach | Description | Pros | Cons |
|---|---|---|---|
| A. Keep raw SQL in `migrations/` for Nivel 1.2 | Continue the Nivel 1.1 pattern | Consistent with current untracked work | No version tracking in Alembic; harder to evolve |
| B. Introduce Alembic in `backend/migrations/` | New Python-managed migrations for backend schema | Matches `database-graph.md` recommendation | Two migration systems during transition |
| C. Move all migrations to `supabase/migrations/` and add Alembic separately | Supabase CLI-managed raw SQL + Alembic for backend app | Clean separation | More moving parts |

**Recommendation: B with future path to C** — introduce Alembic under `backend/migrations/` for Nivel 1.2 tables. Nivel 1.1 migrations remain as the baseline schema. A future change can unify the migration strategy.

### 7. Telemetry table design

`database-graph.md` recommends TimescaleDB hypertables for `exercise_telemetry`. TimescaleDB is **not** in the current Docker Compose image (`supabase/postgres:15.1.1.78` may or may not include the extension).

Options:

| Approach | Description | Pros | Cons |
|---|---|---|---|
| A. Plain PostgreSQL table with indexes | Defer hypertables | Works today; no infra change | Less optimal for high-volume telemetry later |
| B. Try to enable TimescaleDB extension | Matches spec | Ideal for time-series | Requires extension availability; adds complexity |

**Recommendation: A for Nivel 1.2** — use a regular PostgreSQL table with indexes on `(session_id, variable_name, timestamp)`. Document the future migration to TimescaleDB hypertable.

### 8. Testing approach

No test runner exists. The pattern from Nivel 1.1 is bash/curl/psql smoke tests.

Recommended minimum tests:

- `scripts/test-nivel-1-2-backend.sh` that:
  - waits for backend health (`GET /api/v1/health`);
  - registers/logs in a patient via GoTrue;
  - calls `GET /api/v1/exercises` with JWT and gets the seeded exercise;
  - calls `POST /api/v1/exercises/{id}/start` and receives a session id;
  - calls `POST /api/v1/exercises/{id}/complete` with telemetry;
  - verifies the patient can read only their own session/telemetry;
  - verifies missing/invalid JWT returns `401`.

### 9. OpenAPI version strategy

FastAPI natively serves `/openapi.json` and `/docs`. The roadmap requires a versioned OpenAPI contract.

Recommended:

- Version the API URL as `/api/v1` (already in `.env.example`).
- Set `openapi_url=/api/v1/openapi.json` and `docs_url=/api/v1/docs`.
- Document that the contract is version 1.0.0 for Nivel 1.2.

## Approaches

### Option 1: FastAPI monolith container with SQLAlchemy/Alembic (recommended)

Add a `backend/` directory with FastAPI, SQLAlchemy 2.0 async models, Alembic migrations, Pydantic schemas, JWT dependency, routers for `/auth` (thin) and `/exercises`, and a `Dockerfile`. Wire it into `docker-compose.yml` on port 8001.

- **Pros**: matches roadmap specs, produces versioned OpenAPI, establishes long-term architecture, reproducible local deployment.
- **Cons**: more initial setup than a thin wrapper; Alembic migration history must be bootstrapped carefully on top of Nivel 1.1 schema.
- **Effort**: Medium.

### Option 2: PostgREST-first with FastAPI only for exercise logic

Keep auth/profile reads through PostgREST/Kong. FastAPI only implements `/exercises` endpoints, connects to Postgres directly, and aggregates OpenAPI manually or via a gateway.

- **Pros**: less backend code; leverages existing RLS/policies.
- **Cons**: frontend still needs to know about two APIs or requires a custom gateway; harder to produce a single OpenAPI contract; does not match the "FastAPI con endpoints de auth" wording in the DoD.
- **Effort**: Low-Medium.

### Option 3: FastAPI local-only, defer containerization

Implement the FastAPI app but run it on the host with `uvicorn`, connecting to the local Supabase stack. Do not modify `docker-compose.yml`.

- **Pros**: fastest to start coding; no Docker build cycles.
- **Cons**: not reproducible; contradicts "backend desplegable localmente"; harder to verify in CI.
- **Effort**: Low.

## Recommendation

Adopt **Option 1** for Nivel 1.2. Add a `backend` Docker service with FastAPI, SQLAlchemy 2.0 async, Alembic, and Pydantic. Expose `/api/v1/health`, `/api/v1/auth/me`, and the first `/api/v1/exercises` endpoints. Seed one therapeutic exercise and persist session/telemetry with patient ownership enforced by RLS. Use bash/curl smoke tests until a test runner is adopted. Keep Nivel 1.1 raw SQL migrations as baseline and introduce Alembic-managed migrations for new backend tables.

## Risks

- **Greenfield backend**: no existing code, Dockerfile, or container wiring; significant bootstrap work.
- **Migration strategy divergence**: Nivel 1.1 migrations are untracked raw SQL; adding Alembic creates a transition boundary that must be documented.
- **No test runner**: verification relies on bash scripts, limiting regression safety until Nivel 4.6 testing refinements.
- **TimescaleDB/Redis/Temporal absent**: any telemetry/event workflow beyond a minimal relational table must explicitly defer those technologies or add infrastructure.
- **Exercise product decision**: the choice of the first exercise (process, mechanic, clinical framing) is not a technical decision and must be confirmed.
- **Auth boundary confusion**: the backend must not reimplement GoTrue signup/login; it should validate JWTs and optionally expose thin `/auth/me` helpers.
- **Port collision**: FastAPI default `APP_PORT=8001` must remain free and Kong routes must not conflict.

## Open Product/Technical Decisions for Proposal Round

1. **Which therapeutic exercise is the first one?** (process target, mechanic, duration, telemetry variables)
2. **Should the FastAPI service be added to `docker-compose.yml` now or run locally?**
3. **Should the backend expose `/auth/*` endpoints or rely on direct GoTrue calls?**
4. **Should Nivel 1.2 introduce Alembic under `backend/migrations/` or continue raw SQL in `migrations/`?**
5. **Should `exercise_telemetry` use plain PostgreSQL rows (defer TimescaleDB) or enable TimescaleDB extension?**
6. **Should the backend connect to Postgres directly or through PostgREST for reads?**
7. **What is the minimal schema for `exercises_catalog` seed data?**
8. **Should Redis be added for caching/sessions, or deferred entirely?**

## External Research Useful?

Yes, limited:

- Confirm Supabase self-hosted JWT validation patterns for FastAPI (best-practice libraries such as `pyjwt`/`python-jose` with RS256/HS256).
- Review FastAPI project layout conventions and SQLAlchemy 2.0 async patterns if the team is not already aligned.
- Verify whether `supabase/postgres:15.1.1.78` includes the TimescaleDB extension if telemetry hypertables are desired.

## Ready for Proposal

Yes. The exploration identifies a coherent minimum backend slice, the required integration boundaries with Nivel 1.1, the greenfield nature of the work, and explicit product/technical decisions that should be resolved before writing the proposal and specs.

## Confirmation

This exploration performed zero implementation or infrastructure changes. No code was written, no migrations were applied, and no git state was modified beyond the creation of this exploration artifact.
