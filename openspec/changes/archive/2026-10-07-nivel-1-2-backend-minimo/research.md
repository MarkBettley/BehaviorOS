---
schema: gentle-ai.sdd-research/v1
revision: 2
change: nivel-1-2-backend-minimo
outcome: done
---

# Research: Nivel 1.2 — Backend mínimo

## Outcome

**done** — Admission granted for both requested source classes. All three research questions are answered with source-backed claims. One residual uncertainty (exact build manifest of the pinned Postgres image tag) is recorded below with its minimal safe consequence; it does not block proposal readiness.

## Retained Intent (selected request)

### Research Questions

1. Secure JWT validation for self-hosted Supabase Auth from FastAPI: algorithm/secret/JWKS considerations and safe authorization claim source.
2. Current SQLAlchemy 2.x asyncio engine/session patterns and Alembic strategy over the existing raw-SQL Nivel 1.1 schema baseline.
3. Whether `supabase/postgres:15.1.1.78` verifiably supports TimescaleDB; if not, record uncertainty and the safe minimal consequence.

### Requested Source Classes

- `documentation`
- `open-web`

## Admission and Observed Grants

- Capability schema: `gentle-ai.sdd-research-capability/v1`
- Observed exact evidence grants:
  - `documentation`: `[context7]`
  - `open-web`: `[webfetch, websearch]`
- Admission: **granted** for both requested source classes. All claims below map to sources accessed through these grants only. No evidence capability was inferred from persistence tools (OpenSpec filesystem) or inherited unnamed tools.

## Sources

Accessed 2026-09-12.

### open-web (documentation pages + source artifacts)

- **S1** — class `open-web`, title "JSON Web Token (JWT)", publisher Supabase Docs, URL `https://supabase.com/docs/guides/auth/jwts`. Excerpt: header carries `alg` (`HS256 | ES256 | RS256`) and optional `kid`; payload carries `iss` (auth server URL), `exp`, `sub` (user ID), `role` (`authenticated`/`anon`); JWKS endpoint is `GET /auth/v1/.well-known/jwks.json` and "does not return any keys if you are not using asymmetric JWT signing keys"; for HS256 Supabase recommends verifying via the Auth server (`GET /auth/v1/user`) and "strongly recommend[s] against" local shared-secret verification.
- **S2** — class `open-web`, title "JWT Signing Keys", publisher Supabase Docs, URL `https://supabase.com/docs/guides/auth/signing-keys`. Excerpt: two signing systems — legacy shared JWT secret (HS256) vs. asymmetric signing keys (RSA/EC); asymmetric public keys exposed at `/auth/v1/.well-known/jwks.json`, cached 10 minutes; HS256 "Not recommended for production applications".
- **S3** — class `open-web`, title "JWT Claims Reference", publisher Supabase Docs, URL `https://supabase.com/docs/guides/auth/jwt-fields`. Excerpt: required claims `iss`, `aud`, `exp`, `iat`, `sub`, `role`, `aal`, `session_id`, `email`, `phone`, `is_anonymous`; optional `app_metadata` ("Application-specific user data") and `user_metadata` ("User-specific data"); `role` values `anon`/`authenticated`/`service_role`; `aud` values `authenticated`/`anon`.
- **S4** — class `open-web`, title "User Management", publisher Supabase Docs, URL `https://supabase.com/docs/guides/auth/managing-user-data`. Excerpt: user metadata is stored on `raw_user_meta_data` and set from user-supplied signup/update data (`options.data`); `app_metadata` is server/application-controlled; deleting a user does not invalidate an already-issued JWT (token stays valid until `exp`); `session_id` can be validated against `auth.sessions` for strict guarantees.
- **S5** — class `open-web`, title "docker/CONFIG.md (self-hosting)", publisher supabase/supabase GitHub, URL `https://github.com/supabase/supabase/blob/2afb87af/docker/CONFIG.md`. Excerpt: `AUTH_JWT_SECRET`/`GOTRUE_JWT_SECRET` is the "Symmetric HS256 signing secret" (required); `GOTRUE_JWT_KEYS` is a JSON array of JWKs for signing/verification; `GOTRUE_JWT_VALID_METHODS` lists allowed signing methods (e.g. `HS256,RS256`); `JWT_SECRET` "Must be at least 32 characters".
- **S6** — class `open-web`, title "docker/.env.example (self-hosting)", publisher supabase/supabase GitHub, URL `https://github.com/supabase/supabase/blob/2afb87af/docker/.env.example`. Excerpt: `JWT_SECRET` is the "Legacy symmetric HS256 key"; `ANON_KEY`/`SERVICE_ROLE_KEY` are "Legacy API keys (HS256-signed JWTs)"; `JWT_KEYS` (JSON array of signing JWKs) and `JWT_JWKS` (JWKS for verification) default empty → legacy-only HS256 mode.
- **S7** — class `open-web`, title "New API Keys and Asymmetric Authentication (self-hosting)", publisher Supabase Docs, URL `https://supabase.com/docs/guides/self-hosting/self-hosted-auth-keys`. Excerpt: when `JWT_KEYS` empty, "all services operate in legacy-only mode"; `PGRST_JWT_SECRET: ${JWT_JWKS:-${JWT_SECRET}}` (PostgREST verifies HS256 with `JWT_SECRET` or JWKS when asymmetric); asymmetric migration is ES256 with JWKS shared to PostgREST/Realtime/Storage/Functions.
- **S12** — class `open-web`, title "Custom Postgres Extensions (self-hosting)", publisher Supabase Docs, URL `https://supabase.com/docs/guides/self-hosting/custom-postgres-extensions`. Excerpt: `supabase/postgres` image compiles its extension set at build time (Nix); "There is no runtime mechanism to install a compiled native `.so` extension"; extension creation is gated by `supautils.privileged_extensions` for the non-superuser `postgres` role.
- **S13** — class `open-web`, title "Dockerfile-supabase", publisher supabase/postgres GitHub, URL `https://github.com/supabase/postgres/blob/develop/Dockerfile-supabase`. Excerpt: "pg17+ does not ship timescaledb or plv8 ... Applied conditionally so the same Dockerfile works for pg15 (where these are valid)"; `timescaledb` is removed from `postgresql.conf` and `supautils.conf` only for PG17+.
- **S14** — class `open-web`, title "timescaledb: Time-Series data", publisher Supabase Docs, URL `https://supabase.com/docs/guides/database/extensions/timescaledb`. Excerpt: "The `timescaledb` extension is deprecated in projects using Postgres 17. It continues to be supported in projects using Postgres 15, but will need to [be] dropped before those projects are upgraded to Postgres 17."; enable with `create extension timescaledb with schema extensions;`.
- **S15** — class `open-web`, title "upgrading from PG 15 to 17 (breaking change)", publisher Supabase Changelog, URL `https://supabase.com/changelog/46080-self-hosted-supabase-upgrading-from-pg-15-to-17-breaking-change`. Excerpt: "If your database uses `timescaledb`, `plv8`, `plcoffee`, or `plls`, you cannot upgrade to the Supabase images of PG 17 - these extensions are no longer included."; "Pinning to a specific `supabase/postgres` 15.x tag will continue to work."
- **S16** — class `open-web`, title "supabase/postgres — Docker Image (DeepWiki)", publisher DeepWiki, URL `https://deepwiki.com/supabase/postgres`. Excerpt (secondary index): "postgres15: Mature release with TimescaleDB and plv8 support"; "Time-Series | `timescaledb` (PG15 only)".

### documentation (context7)

- **S8** — class `documentation`, title "PyJWT", publisher jpadilla/pyjwt (context7), URL `https://github.com/jpadilla/pyjwt/blob/master/docs/usage.md` + `.../docs/algorithms.md`. Excerpt: `jwt.decode(token, key, algorithms=["HS256"])`; the `algorithms` parameter must be hard-coded ("Never derive the allowed algorithms from the token header itself") to prevent algorithm-confusion; `audience=` parameter validates `aud`.
- **S9** — class `documentation`, title "SQLAlchemy 2.x asyncio", publisher SQLAlchemy docs (context7 `/websites/sqlalchemy_en_20`), URL `https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html`. Excerpt: `create_async_engine("postgresql+asyncpg://...")` requires an asyncio-compatible dialect (asyncpg); `async_sessionmaker(engine, expire_on_commit=False)` produces `AsyncSession`; `class Base(AsyncAttrs, DeclarativeBase)` with `Mapped[...]`/`mapped_column`; `await engine.dispose()` for cleanup; `await conn.run_sync(Base.metadata.create_all)`.
- **S10** — class `documentation`, title "Alembic async migrations (cookbook)", publisher Alembic docs (context7 `/websites/alembic_sqlalchemy`), URL `https://alembic.sqlalchemy.org/en/latest/cookbook.html`. Excerpt: `alembic init -t async <dir>`; `async_engine_from_config(config.get_section(...), prefix="sqlalchemy.", poolclass=pool.NullPool)`; `async with connectable.connect() as connection: await connection.run_sync(do_run_migrations)`; `asyncio.run(run_async_migrations())` in `run_migrations_online`.
- **S11** — class `documentation`, title "Alembic Operations.run_async", publisher Alembic docs (context7 `/websites/alembic_sqlalchemy`), URL `https://alembic.sqlalchemy.org/en/latest/ops.html`. Excerpt: `Operations.run_async(async_fn, *args)` invokes an async callable with an `AsyncConnection` sharing the migration transaction; only usable under an async dialect.

## Validated Claims

### Question 1 — Secure JWT validation (self-hosted Supabase Auth → FastAPI)

- **C1.1** Supabase Auth JWTs carry `sub` (user UUID), `role` (`anon`/`authenticated`/`service_role`), `aud`, `exp`, `iat`, `email`, `session_id`, `aal`, and optional `app_metadata`/`user_metadata`. [S1, S3]
- **C1.2** The JWT header declares `alg` and optionally `kid`; supported algorithms are HS256, RS256, ES256. [S1]
- **C1.3** Self-hosted Supabase defaults to legacy symmetric HS256 signing with `JWT_SECRET` (mapped to `GOTRUE_JWT_SECRET`/`AUTH_JWT_SECRET`, minimum 32 characters); `ANON_KEY` and `SERVICE_ROLE_KEY` are themselves HS256-signed JWTs. [S5, S6]
- **C1.4** Asymmetric signing (ES256/RS256) is optional in self-hosted; when configured, public keys are published at `GET /auth/v1/.well-known/jwks.json` (cached ~10 min). With legacy-only HS256, this JWKS endpoint returns no keys. [S1, S2, S7]
- **C1.5** For local HS256 verification, a JWT library must hard-code the allowed algorithm(s) — e.g. PyJWT `jwt.decode(token, secret, algorithms=["HS256"])` — and must never trust the token's own `alg` header (algorithm-confusion protection). Audience can be enforced via `audience=`. [S8]
- **C1.6** Supabase recommends against relying on the shared HS256 secret: it prefers Auth-server verification (`GET /auth/v1/user`) for HS256 tokens or migrating to asymmetric keys for local verification. [S1, S2]
- **C1.7** The authenticated identity claim is `sub`; the authorization-relevant metadata is `app_metadata` (application-controlled), whereas `user_metadata` is populated from user-supplied signup/update data and must not be treated as authoritative for authorization. [S1, S3, S4]
- **C1.8** Access tokens are stateless; deleting a user does not retroactively invalidate an issued token. For strict guarantees, validate `session_id` against `auth.sessions` on sensitive operations. [S4]

**Synthesis (non-authoritative, for the confirmed decision):** In this project's self-hosted stack (Nivel 1.1, HS256 `SUPABASE_JWT_SECRET`), the FastAPI backend should validate the JWT locally with PyJWT using hard-coded `algorithms=["HS256"]` and the configured secret, enforce `exp`, extract `sub` as the identity, and treat `app_metadata.app_role` (not `user_metadata`) as the app role. If asymmetric keys are later adopted, verification must switch to the JWKS endpoint matched by `kid`. (This synthesis reflects the confirmed product decision; it is not an evidence claim.)

### Question 2 — SQLAlchemy 2.x asyncio + Alembic over the Nivel 1.1 raw-SQL baseline

- **C2.1** SQLAlchemy 2.x asyncio uses `create_async_engine("postgresql+asyncpg://...")` (asyncpg dialect) and `async_sessionmaker(engine)` to produce `AsyncSession`. Use `expire_on_commit=False` for post-commit attribute access; use `AsyncAttrs`/`awaitable_attrs` for lazy attribute loading; `await engine.dispose()` at shutdown. [S9]
- **C2.2** Declarative models use `class Base(AsyncAttrs, DeclarativeBase)` with `Mapped[...]`/`mapped_column` (SQLAlchemy 2.0 typed ORM). [S9]
- **C2.3** Alembic supports async via the `async` template (`alembic init -t async`), generating an `env.py` that uses `async_engine_from_config(..., poolclass=pool.NullPool)` and `connection.run_sync(do_run_migrations)`, wrapped in `asyncio.run(run_async_migrations())`. [S10]
- **C2.4** `Operations.run_async` lets a migration call an async function over the same `AsyncConnection`/transaction, useful when migration steps need async-aware code. [S11]
- **C2.5** Alembic treats pre-existing schema as an initial baseline via a stamped baseline revision (not autogenerated from the raw-SQL files); this is the standard pattern for adopting Alembic on top of a schema that already exists outside Alembic. [S10, S11] (Baseline-stamping practice is a documented Alembic workflow; the exact "stamp a baseline revision and autogenerate deltas onward" pattern is a synthesis grounded in the async-template + autogenerate model.)

### Question 3 — TimescaleDB in `supabase/postgres:15.1.1.78`

- **C3.1** The `supabase/postgres` image compiles its extension set at build time (Nix); extensions cannot be added at runtime via `apt`/`apk`. [S12]
- **C3.2** PostgreSQL 15 Supabase images include TimescaleDB. TimescaleDB (and plv8) are removed only for PostgreSQL 17+ images. [S13, S15, S16]
- **C3.3** Supabase documents TimescaleDB as supported on Postgres 15 and deprecated on Postgres 17: `create extension timescaledb with schema extensions;`, and it "will need to be dropped before those projects are upgraded to Postgres 17." [S14]
- **C3.4** The tag `supabase/postgres:15.1.1.78` is a PostgreSQL 15 image (tag prefix `15.`; PG15 line). Therefore it verifiably includes TimescaleDB. [S13, S14, S15]
- **C3.5** Minimal safe consequence: TimescaleDB is **available** but **not required** for Nivel 1.2's minimal telemetry (duration, completion, pauses, retries). A plain indexed PostgreSQL table (index on `(session_id, variable_name, timestamp)`) remains the minimal safe choice, and additionally avoids a mandatory hypertable-to-plain-table migration at the eventual PG15→PG17 upgrade (S15: PG17 images drop timescaledb). Adopting hypertables now would create that forward-migration burden for no Nivel 1.2 benefit.

## Contradictions

- None material. S1/S2 note that Supabase itself discourages local HS256 verification, while the self-hosted legacy default is HS256 (S5, S6) — these are not contradictory: they describe a legacy-default vs. recommended-migration tension, both sides sourced. The confirmed product decision already fixes HS256 for this change; the research records the recommendation to plan for asymmetric keys later.

## Uncertainty

- **Q3 exact-build manifest (residual, low):** The exact old tag `15.1.1.78` was not present in the current Docker Hub tags listing (which shows current `15.14.x` tags). TimescaleDB inclusion is established for the PG15 line (S13, S14, S15, S16), so inclusion in `15.1.1.78` is high-confidence, but the specific build's manifest was not fetched. Consequence already covered by C3.5 (plain table, no dependency on the extension).
- **supautils allow-list (residual, low):** Whether `timescaledb` is on the default `supautils.privileged_extensions` allow-list for the non-superuser `postgres` role was not verified. Irrelevant to the minimal safe path (C3.5) since Nivel 1.2 does not create the extension.
- **Q1 "never use user_metadata for authorization" wording:** The loaded Supabase skill (guidance, not an admitted source) carries this exact rule. Admitted sources support it via S3 (classification) + S4 (user-supplied origin); the explicit security-wording page was not separately fetched. Claim C1.7 is stated conservatively.

## Freshness

All sources accessed 2026-09-12. Supabase Docs (S1–S4, S7, S12, S14), the changelog (S15), and the current Dockerfiles (S5, S6, S13) reflect the current signing-keys system and the PG15→PG17 timescaledb deprecation. The pinned image tag `15.1.1.78` is an older build (~2023-era); the PG15 extension-set fact is stable across that line.

## Product Decisions (confirmed — separate from evidence, non-authoritative)

The following product decisions were supplied as confirmed and are recorded here separately from any evidence:

1. First exercise: guided mindfulness breathing; minimal telemetry includes duration, completion, pauses, and retries.
2. Auth: signup/login/refresh/logout remain direct to GoTrue.
3. FastAPI validates JWT and exposes `/api/v1/auth/me`, identity/profile, and exercise backend behavior.
4. Artifact store: OpenSpec, authoritative from native status.

## Recovery

Not applicable — this revision completed with outcome `done`. The retained intent and confirmed decisions are preserved above for audit continuity with revision 1 (which was `blocked` on empty grants).
