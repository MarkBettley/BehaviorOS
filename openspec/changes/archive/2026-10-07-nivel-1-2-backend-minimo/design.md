# Design: Nivel 1.2 — Backend mínimo

## Technical Approach

Add one FastAPI/Uvicorn service on port 8001. GoTrue remains the owner of signup, login, refresh, and logout. FastAPI validates bearer JWTs locally with PyJWT, `SUPABASE_JWT_SECRET`, hard-coded `algorithms=["HS256"]`, and enforced `exp`; `sub` is the identity and `app_metadata.app_role` is authoritative. Mount only the specified `/api/v1` routes, with `/api/v1/openapi.json` and `/docs`.

## Architecture Decisions

| Option | Tradeoff | Decision |
|---|---|---|
| One service vs split services | One transaction boundary; fewer moving parts. | One `backend` service. |
| Direct SQLAlchemy vs PostgREST | Direct async SQL supports atomic completion. | SQLAlchemy 2.x with `postgresql+asyncpg`. |
| Local HS256 vs JWKS | HS256 is the confirmed Nivel 1.1 contract; migration is deferred. | Hard-coded HS256 validation; never authorize from `user_metadata`. |
| Plain table vs TimescaleDB | Plain PostgreSQL avoids the PG17 extension dependency. | Indexed table with exactly four telemetry variables. |
| Alembic adoption vs raw continuation | Versioned additive changes without rewriting Nivel 1.1. | No-op baseline stamp, then additive Nivel 1.2 revisions. |

## Data Flow and RLS Context

```text
JWT → FastAPI dependency → validated sub/claims → transaction-local DB context
                                                    ↓
                                      RLS + explicit ownership predicate
                                                    ↓
                                  catalog → owned session → four rows
```

Every request acquires an `AsyncSession` from `async_sessionmaker(expire_on_commit=False)`. Before protected queries, the session opens a transaction and executes `SET LOCAL ROLE authenticated`, `set_config('request.jwt.claim.sub', :sub, true)`, and the transaction-local settings required by existing `auth.uid()`/RLS functions. The URL uses a dedicated least-privilege backend login (not `postgres`); only migrations/bootstrap may use an administrative connection. Settings are cleared by commit/rollback before pool reuse, and the dependency always closes the session. Policies follow Nivel 1.1: `TO authenticated`, `auth.uid() = owner_id`, and `WITH CHECK` for writes; explicit predicates remain defense in depth. Cross-owner lookups return deterministic `404 Not Found`.

Completion locks the owned session in one transaction. Active completion sets status/timestamps and inserts exactly `duration`, `completion`, `pauses`, and `retries`. Repeating a completed request returns `200 OK` without updates or duplicate rows.

## File Changes

| File | Action | Description |
|---|---|---|
| `docker-compose.yml` | Modify | Add backend, health dependency, port 8001, network, async DB URL, JWT settings, and dedicated DB-user wiring. |
| `.env.example` | Modify | Replace the synchronous localhost `DATABASE_URL` with `postgresql+asyncpg://...@db:...`; document non-secret `BACKEND_DB_USER`, `POSTGRES_HOST=db`, and password-variable wiring without values. |
| `backend/` | Create | FastAPI app, settings, async session lifecycle, JWT dependency, routers, models, Dockerfile, and Alembic async setup. |
| `backend/alembic/versions/` | Create | Baseline stamp and additive catalog/session/telemetry schema, seed, grants, and RLS. |
| `scripts/test-nivel-1-2-backend.sh` | Create | Deterministic Bash/curl/psql verification. |

## Interfaces / Contracts

`GET /health` returns exactly `200` and `{"status":"ok"}`. `/auth/me` returns `200` with `sub`, `email`, `app_role`, and a profile object; a valid identity without a `patient_profiles` row returns the same identity fields with `profile: null` (or the specified absent profile block). Missing, malformed, expired, wrong-signature, unexpected-algorithm, and valid `is_anonymous: true` JWTs are rejected (`401`; anonymous protected resources may use `403`). No auth lifecycle endpoints are added.

## Testing Strategy

The Bash/curl/psql harness is the core proof; no requirement depends on a future runner. It checks every scenario in both specs: exact health body; JWT success/missing/invalid/expired/algorithm cases; `/auth/me` fields, unauthenticated rejection, null-profile identity, and anonymous-JWT rejection; OpenAPI/docs; one-item `EX_1` catalog and retrieval; start success/404; completion success/400/idempotent retry; cross-patient completion/read 404; four telemetry rows; ownership and direct RLS reads. It also asserts no duplicate mutation and pooled-connection reset.

## Threat Matrix

| Boundary | Applicability | Design response | Planned RED tests |
|---|---|---|---|
| Documentation-like paths | N/A — no executable-file classification | None | None |
| Git repository selection | N/A — no Git automation | None | None |
| Commit state | N/A — no commit automation | None | None |
| Push state | N/A — no push automation | None | None |
| PR commands | N/A — no PR automation | None | None |

Routing/process integration is limited to static FastAPI routes and Docker startup; the harness covers route, auth, and startup failures.

## Migration / Rollout

Use two explicit phases. **Baseline phase:** on a fresh database, apply the existing ordered Nivel 1.1 raw-SQL migrations and verify sentinel tables/policies; on an existing database, do not rerun them—verify the same sentinels. Only after either verification succeeds, run `alembic stamp nivel11_baseline` using the administrative migration URL. **Additive phase:** run `alembic upgrade nivel12_head`; only these revisions create Nivel 1.2 tables, seed `EX_1`, grants, role provisioning, and RLS. Never let application startup silently stamp or alter Nivel 1.1. Rollback removes only additive revisions and the backend service; preserve the Nivel 1.1 volume and artifacts. No TimescaleDB dependency or migration is introduced.

## Open Questions

- None blocking. Future asymmetric JWT/JWKS validation remains out of scope.
