# Design: Nivel 1.1 — Patient Identity, Authentication & Security

## Technical approach

Keep Supabase Auth/GoTrue as the identity source and implement the approved additive architecture: four migration boundaries for schema, identity/profile, trusted audit/events, and RLS/grants. BehaviorOS emits exactly `registration`, `login`, `logout`, `consent_grant`, `consent_revoke`, and `profile_update`. `profile_read` and `critical_access` remain a Nivel 1.2 trusted backend/RPC handoff; Nivel 1.1 neither emits nor fabricates them.

## Architecture decisions

| Decision | Choice | Tradeoff / rationale |
|---|---|---|
| Identity and ownership | `auth.users` is canonical; `patient_profiles.user_id` is a unique FK. A `BEFORE INSERT` trigger sets `raw_app_meta_data.app_role=patient`; authorization never uses `raw_user_meta_data`. | Preserves GoTrue ownership while preventing client role injection; no blanket role-update trigger, so future trusted administration remains possible. |
| Correlation contract | At the first BehaviorOS-controlled boundary, the trusted operation/event path validates a supplied opaque ID or generates one. It propagates that ID through the operation and persists it on every related audit event. IDs are never derived from passwords, PII, full JWT/access/refresh tokens, keys, or secrets. | No distributed tracing system and no claim that `auth.sessions` supplies request context. |
| Current layer ownership | Registration: the `auth.users` identity/profile trigger owns the bounded event context. Successful login/logout: the proven `auth.sessions` trigger boundary owns event context. Consent and profile update: their trusted database trigger/event boundary owns context after the RLS-checked write. There is no BehaviorOS backend in this slice. | Where GoTrue cannot safely expose a request ID, the trusted event boundary generates the opaque ID locally; implementation MUST stop rather than invent an interceptor/backend. |
| Origin | Capture only at the controlled execution/event boundary from reliable HTTP, channel, backend, or explicit context when available; otherwise persist `NULL`. | Missing origin never blocks registration, login, logout, consent, or profile update; fabrication is forbidden. `auth.sessions` is not authoritative. |
| Pre-auth actor and outcomes | Registration and safely observable failed login use nullable `actor_user_id`; registration may use the newly created identity. Every event records explicit `success` or `failure`; only permitted non-secret context is accepted. | Failed login is recorded only when safely observable before identity exists. If the current GoTrue path cannot intercept it, no fake row and no out-of-scope backend are added. |
| Trusted insertion | `security.write_audit_event` remains non-exposed, `SECURITY DEFINER`, fixed `search_path`, least privilege, and callable only through trusted trigger/internal writer paths. Clients have no unrestricted audit `INSERT`, `UPDATE`, or `DELETE`. | The writer validates the six-event allowlist, actor binding, outcome, correlation format, origin provenance, and secret-free context; trigger-only/internal grants and append-only controls prevent privileged event fabrication. |

## Data flow

```text
BehaviorOS boundary → validate/generate correlation_id + capture origin/NULL
        → GoTrue or RLS-checked operation → trusted trigger/writer → audit_logs
        → actor nullable before identity; outcome explicit; context secret-free
```

Registration atomically creates the identity, patient profile, and registration audit event. Consent grant/revoke remains append-only; revoke inserts a row. Profile updates use ownership RLS and emit `profile_update`. Successful login/logout use `auth.sessions` only as a session/auth signal after the early probe proves the installed behavior; it is not the correlation or origin authority. A safely observable failed login may emit `login/failure`; otherwise the bounded result is no fabricated event. All related events carry the same operation correlation ID.

## RLS, scope, and persistence contract

Preserve the existing exact ownership policies: authenticated patients can access only their own profile and consent history; consent versions are readable; client DELETE is denied; consent history and audit rows are append-only. RLS is enabled on all tables, `anon` has no access, and audit reads remain actor-scoped. Retain the two-year policy, minimal profile, current-consent constraints/indexes, idempotent `1.0.0` seeds, and rollback that preserves `auth.users`, `auth.sessions`, Nivel 0.2 migrations, and volumes. Internal Supabase tables are not modified to impose correlation or origin contracts.

## Phase and verification implications

The four migration boundaries and the existing auth/profile/consent/RLS scope remain unchanged. Later tasks MUST place every feature RED assertion before its GREEN implementation; Phase 3 is only the final integrated GREEN/readback pass, not a place to introduce new RED work. Verification must prove the six-event taxonomy, correlation propagation/generation, nullable pre-auth actor, reliable-or-NULL origin, direct-write denial, anti-fabrication checks, secret safety, and the explicit Nivel 1.2 deferral.

**Implementation status: zero.** This correction changes only this design document and its synchronized Engram artifact; no code, SQL, migration, runtime, test, task, proposal, or spec was modified.
