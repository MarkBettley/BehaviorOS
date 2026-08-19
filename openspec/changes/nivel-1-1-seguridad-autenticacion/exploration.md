# Exploration: Nivel 1.1 — Patient Identity & Security Slice

## Scope

Explore the minimum safe Nivel 1.1 patient identity/security slice that unlocks Nivel 1.2, without implementing anything. Out of scope: OAuth/social, WebAuthn, advanced MFA/2FA, SSO, full clinical roles, crisis protocol, full compliance, full clinical backend, full frontend, landing, AI, event sourcing, twin, ontology/graph, commerce, advanced realtime, Nivel 1.2 implementation.

## Current State

Nivel 0.2 is archived and approved (evidence `sha256:a0c66c3eb9c1e78c839e2c813fab7b1f18d8d5ff7a423a42bde8e701fe9c4709`). The local Supabase-aligned stack is running with all services healthy: `db`, `auth`, `rest`, `storage`, `meta`, `imgproxy`, `kong`, `studio`.

Relevant runtime facts discovered:

- PostgreSQL 15.1 (Ubuntu 15.1-1.pgdg20.04+1) with extensions `pgcrypto`, `pgjwt`, `uuid-ossp`, `supabase_vault`, `pg_graphql`, `pg_net`.
- `public` schema has **zero tables** and **zero functions/triggers**.
- `auth.users` exists with standard GoTrue columns; RLS is enabled on `auth` tables but **no policies exist**.
- `auth.users` currently contains **0 rows**.
- Roles present: `anon`, `authenticated`, `authenticator`, `service_role` (bypassrls), `supabase_auth_admin`, `supabase_admin`, `postgres`.
- JWT helpers exist: `auth.uid()`, `auth.jwt()`, `auth.role()`.
- DB-level settings: `app.settings.jwt_secret` and `app.settings.jwt_exp=3600` are configured.
- GoTrue settings via `/auth/v1/settings`: `email=true`, `phone=true`, `anonymous_users=false`, `disable_signup=false`, `mailer_autoconfirm=false`, `phone_autoconfirm=true`.
- **No mailer service is defined in `docker-compose.yml`**. With `ENABLE_EMAIL_AUTOCONFIRM=false`, email signups require confirmation that cannot be delivered locally unless autoconfirm is enabled or a mailer is added.
- No `supabase/migrations/` files exist; the project has not committed any migration history.
- `openspec/config.yaml` reports no test runner (`strict_tdd: false`, framework `NOT FOUND`). Existing verification is bash/curl via `scripts/healthcheck.sh`.
- Git repository has no commits on `main` yet.

## Affected Areas

- `supabase/migrations/` — new schema migrations for patient identity, consent, and audit.
- `docker-compose.yml` / `.env.example` — possible env-var additions (baseline containers must not change).
- `scripts/` — new reproducible security/RLS test harness.
- `public` schema — new tables, RLS policies, indexes, functions, triggers.
- `auth.users` — source of truth for identity; `raw_app_meta_data` used for immutable app role.

## Analysis of Required Decisions

### 1. New tables and minimum patient profile fields

Nivel 1.1 only needs identity + consent + audit. Clinical data belongs to later levels.

Recommended minimum tables:

| Table | Purpose | Key fields |
|---|---|---|
| `public.patient_profiles` | Patient-owned minimal profile data | `id uuid pk`, `user_id uuid not null unique refs auth.users(id) on delete cascade`, `display_name text`, `language text default 'es'`, `timezone text`, `created_at timestamptz default now()`, `updated_at timestamptz default now()` |
| `public.consent_versions` | Catalog of versioned consent texts | `id uuid pk`, `scope text not null`, `version text not null`, `content text not null`, `effective_at timestamptz not null`, `superseded_at timestamptz`, `unique(scope, version)` |
| `public.patient_consents` | Historical consent grants/revokes | `id uuid pk`, `user_id uuid not null refs auth.users(id)`, `scope text not null`, `version text not null`, `granted_at timestamptz not null`, `revoked_at timestamptz`, `ip_address inet`, `user_agent text`, `created_at timestamptz default now()` |
| `public.audit_logs` | Immutable security audit trail | `id uuid pk`, `occurred_at timestamptz not null default now()`, `actor_id uuid`, `actor_role text`, `action text not null`, `resource_type text`, `resource_id text`, `outcome text not null`, `origin_ip inet`, `origin_user_agent text`, `context jsonb`, `correlation_id text` |

Indexes: `patient_profiles(user_id)`, `patient_consents(user_id, scope, granted_at)`, `audit_logs(actor_id, occurred_at)`, `audit_logs(action, occurred_at)`.

### 2. Relationship to `auth.users`

`auth.users` is the single identity source. `patient_profiles.user_id` is a `1:1` FK to `auth.users(id) on delete cascade`. No parallel auth table. Registration creates the GoTrue user first; the profile is created immediately after via trigger or post-signup flow.

### 3. Immutable initial `patient` role

Options:

| Approach | How | Pros | Cons |
|---|---|---|---|
| A. GoTrue default DB role | `GOTRUE_JWT_DEFAULT_GROUP_NAME=authenticated` already set; app role stored separately | Simple, no custom hook | JWT `role` claim is `authenticated`, not app role; requires DB lookup for app role |
| B. `raw_app_meta_data` set by DB trigger after insert on `auth.users` | `after insert` trigger runs as `postgres`/`supabase_auth_admin` and sets `raw_app_meta_data = '{"app_role":"patient"}'` | Immutable from user, no external service, survives token refresh | Slightly coupled to auth schema |
| C. Custom Access Token Auth Hook | Adds `app_role` claim to JWT at issuance | Fast RLS/custom claims | Requires hook enablement; local self-hosted hook config is more complex |
| D. Separate `public.user_roles` table | Maps `auth.users.id` → role | Clean RBAC foundation for future roles | Extra join; Nivel 1.1 only has one role |

**Recommended minimum: B for Nivel 1.1** — a trigger on `auth.users` sets `raw_app_meta_data->'app_role'` to `'patient'`. RLS policies read `auth.jwt() -> 'app_metadata' ->> 'app_role'` or join to a helper. This avoids custom hooks in the MVP while guaranteeing the user cannot self-elevate. `raw_user_meta_data` must **never** be used for authorization because it is user-editable.

### 4. JWT claims that should be trusted/used

From the live stack and Supabase docs, the access token can carry:

- `sub` → `auth.uid()` (trusted, UUID of user)
- `role` → Postgres role (`authenticated`/`anon`) — use only for `TO` clause, not for app authorization
- `app_metadata` → from `auth.users.raw_app_meta_data` (trusted for app role if set by server)
- `user_metadata` → from `auth.users.raw_user_meta_data` — **do not trust for authorization**
- `session_id` → correlate with `auth.sessions` for sensitive ops (optional in 1.1)
- `exp`, `iat`, `iss`, `aud` → standard validation handled by PostgREST/Kong

Nivel 1.1 should rely primarily on `(select auth.uid())` for ownership and `auth.jwt() -> 'app_metadata' ->> 'app_role'` for role checks.

### 5. RLS matrix candidate

All new tables must `enable row level security`. Grant `USAGE` on `public` to `anon`, `authenticated`; grant `SELECT, INSERT, UPDATE, DELETE` on tables to `authenticated` and `service_role` as needed, then restrict with policies.

| Table | Action | TO | USING / WITH CHECK |
|---|---|---|---|
| `patient_profiles` | SELECT | authenticated | `(select auth.uid()) = user_id` |
| `patient_profiles` | INSERT | authenticated | `(select auth.uid()) = user_id` AND NOT EXISTS (prevents duplicate) |
| `patient_profiles` | UPDATE | authenticated | USING `(select auth.uid()) = user_id` WITH CHECK `(select auth.uid()) = user_id` |
| `patient_profiles` | DELETE | — | denied (no policy) |
| `patient_consents` | SELECT | authenticated | `(select auth.uid()) = user_id` |
| `patient_consents` | INSERT | authenticated | `(select auth.uid()) = user_id` AND `granted_at` is not null |
| `patient_consents` | UPDATE / DELETE | — | denied |
| `consent_versions` | SELECT | authenticated, anon | `superseded_at IS NULL OR superseded_at > now()` |
| `consent_versions` | INSERT / UPDATE / DELETE | — | denied (seeded/admin only) |
| `audit_logs` | SELECT | authenticated | `(select auth.uid())::text = actor_id::text` |
| `audit_logs` | INSERT / UPDATE / DELETE | — | denied for patients |

**Important:** `UPDATE` requires a matching `SELECT` policy, and `WITH CHECK` is required to prevent reassigning `user_id`.

### 6. Consent history model

Never a single overwritten boolean.

- `consent_versions` holds the canonical texts and version identifiers.
- `patient_consents` records each grant and each revoke as a separate row.
- A revoke is an INSERT with the same `(user_id, scope)` and `revoked_at = now()`; it does not modify the prior grant row.
- Effective consent at any point in time is the latest non-revoked grant per `(user_id, scope)`.
- This gives a complete timestamped, versioned history.

### 7. Audit log model

- `public.audit_logs` is append-only.
- Patients can only `SELECT` rows where `actor_id = auth.uid()`.
- Writes are performed only by `SECURITY DEFINER` functions/triggers in a non-exposed schema (e.g., `security`) or by `service_role`. Patients cannot `INSERT` directly, preventing fabrication of privileged events.
- Critical event taxonomy for Nivel 1.1:
  - `registration` — account created
  - `login` — session created
  - `logout` — session terminated
  - `consent_granted` — consent accepted
  - `consent_revoked` — consent revoked
  - `profile_viewed` — profile accessed
  - `profile_updated` — profile changed
  - `critical_access` — access to sensitive resources (placeholder for 1.2+)

Context stored in `context jsonb` should be minimal and safe: `user_agent`, `ip` at row level; no passwords or tokens.

### 8. Invalid/expired session behavior

- PostgREST/Kong return `401 Unauthorized` when the JWT is missing, malformed, expired, or signed with the wrong secret.
- GoTrue `/auth/v1/token` refresh returns `401` for invalid/expired refresh tokens.
- Nivel 1.1 tests must verify:
  - Missing token → 401 on `/rest/v1/patient_profiles`
  - Expired token → 401
  - Token signed with wrong secret → 401
  - Valid token for deleted user → 401/404 on user endpoints

### 9. Logout semantics in Supabase Auth

Per current Supabase Auth behavior:

- `POST /auth/v1/logout` with a valid access token revokes the refresh token and deletes the session row from `auth.sessions`.
- The access token (JWT) remains technically valid until its `exp` claim passes because JWTs are stateless.
- Nivel 1.1 uses the default 3600 s expiry, so logout + client-side token discard provides acceptable session termination for the MVP.
- For strict logout guarantees, sensitive endpoints in later levels can validate `session_id` against `auth.sessions`; Nivel 1.1 does not require this.

### 10. Migration/rollback shape

The project uses imperative migrations (no `schema_paths` in `config.toml`).

Migration file: `supabase/migrations/YYYYMMDDhhmmss_nivel_1_1_patient_identity_security.sql`

Order:
1. Create `consent_versions` table and seed the initial disclaimer version.
2. Create `patient_profiles` table, enable RLS, create policies.
3. Create `patient_consents` table, enable RLS, create policies.
4. Create `audit_logs` table, enable RLS, create policies.
5. Create helper function to derive effective consent.
6. Create `SECURITY DEFINER` audit write function in a non-exposed schema and trigger(s) on `patient_profiles`/`patient_consents`.
7. Create trigger/function on `auth.users` to set `raw_app_meta_data` role on insert.

Rollback (inverse order, for recovery scripts):
1. Drop auth trigger/function.
2. Drop audit trigger/functions.
3. Drop patient/consent triggers/functions.
4. Drop policies, disable RLS.
5. Drop tables.

### 11. Smallest repeatable tests

Because no test runner exists, use a bash harness plus `curl` and `psql`:

- `scripts/test-nivel-1-1-security.sh`
- Setup: use `service_role` key to create two test users via GoTrue admin API (`/auth/v1/admin/users`) and confirm them.
- Use login endpoint to obtain access/refresh tokens for each patient.
- Run assertions:
  - each patient can `SELECT/INSERT/UPDATE` only their own `patient_profiles`
  - patient A cannot read patient B's profile (RLS isolation)
  - patient can grant consent and the history is versioned
  - patient cannot `UPDATE` or `DELETE` consent history rows
  - patient cannot `INSERT` into `audit_logs`
  - missing/invalid/expired token returns 401
  - logout invalidates refresh token

Two-patient adversarial RLS tests are the core of the harness: create `patient-a@example.com` and `patient-b@example.com`, obtain tokens, and attempt cross-access to profiles/consents/audit rows via the REST API and direct SQL as `authenticated`.

## Approaches

### Option A: Public signup with email autoconfirm (recommended for local dev/tests)

- Set `ENABLE_EMAIL_AUTOCONFIRM=true` in `.env` for local development.
- Patients register via `POST /auth/v1/signup`.
- Trigger sets `raw_app_meta_data->app_role = 'patient'`.
- Profile created by post-signup RPC or trigger.

Pros: matches production signup shape, no manual confirmation step, easy tests.
Cons: local dev only; production must use real confirmation or a different flow.

### Option B: Service-role admin user creation + login

- Keep `ENABLE_EMAIL_AUTOCONFIRM=false`.
- Tests and onboarding create users via `/auth/v1/admin/users` with `service_role`, then confirm them.

Pros: closer to how therapists/admins will create accounts in Nivel 2.1.
Cons: requires exposing `service_role` in local test scripts; public self-registration is blocked without mailer.

### Option C: Phone OTP signup

- Use existing `ENABLE_PHONE_SIGNUP=true` and `ENABLE_PHONE_AUTOCONFIRM=true`.

Pros: works today without mailer.
Cons: phone numbers are harder to generate for repeatable tests; not aligned with the primary patient registration path in the roadmap.

## Recommendation

Adopt **Option A for Nivel 1.1 local development and tests**, with a documented env-var gate (`ENABLE_EMAIL_AUTOCONFIRM=true`) that must be `false` in any real environment. Use a database trigger on `auth.users` to enforce the immutable `patient` role in `raw_app_meta_data`. Build the RLS matrix above, the consent-history model, and the audit log model with `SECURITY DEFINER` writes. Deliver the first `supabase/migrations/` file and a `scripts/test-nivel-1-1-security.sh` bash harness that proves two-patient isolation.

## Risks

- **Blocker — no local mailer**: with `ENABLE_EMAIL_AUTOCONFIRM=false`, public email signup cannot be completed locally. Either enable autoconfirm for local dev or add a mailer service.
- **JWT app metadata freshness**: RLS policies that read `auth.jwt()` see the token as issued; role changes only appear after refresh. For Nivel 1.1 this is acceptable because the role is set once at registration and never changed.
- **Role escalation via raw_user_meta_data**: if any policy accidentally reads `user_metadata`, patients can self-elevate. Must use `raw_app_meta_data` only.
- **Audit write path**: placing audit triggers in `public` without proper `SECURITY DEFINER` and permission revocation could allow patients to tamper with logs.
- **No test runner**: the security suite will be bash-based; this is adequate for Nivel 1.1 but must be replaced or augmented when a test runner is adopted.

## Open Product/Security Decisions for Proposal Round

1. Should local development enable `ENABLE_EMAIL_AUTOCONFIRM=true`, or should we add a local mailer container (e.g., Inbucket) to keep autoconfirm false?
2. Do we want the `patient` role in the JWT claim via a Custom Access Token Hook now, or is reading `raw_app_meta_data` from `auth.jwt()` sufficient for Nivel 1.1?
3. Should patient profile creation be automatic via a database trigger on `auth.users`, or should the client explicitly call a post-signup RPC?
4. Which consent scopes are required for Nivel 1.1? Minimum: `terms_of_service` and `privacy_policy`.
5. Do we need to retain the `patient_profiles` table as the canonical profile source, or should it be a thin view over `auth.users` plus extensions?
6. What is the retention policy for `audit_logs`? Suggest 2 years, matching `security.md` §11.

## Ready for Proposal

Yes. The exploration identifies a coherent minimum slice, a feasible local testing strategy, and explicit product/security decisions that should be resolved before writing the proposal and specs.

## Confirmation

This exploration performed zero implementation or infrastructure changes. All database probes were read-only metadata/`SELECT` queries; all HTTP probes were safe discovery requests that created no users or data. No files were modified except for the creation of this exploration artifact.
