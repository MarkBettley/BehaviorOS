# Proposal: Nivel 1.1 — Patient Identity, Authentication & Security Slice

## Intent

Nivel 0.2 delivers a healthy Supabase local stack, but BehaviorOS has no patient identity, ownership boundary, or auditable consent. This change introduces the minimum safe authentication layer so Nivel 1.2 API work can rely on authenticated patients, row-level isolation, and versioned consent history.

## Scope

### In Scope
- Patient registration, login, and logout via Supabase Auth (email + password).
- Immutable `patient` role enforced server-side.
- Minimal patient profile owned by the authenticated user.
- Exact two-patient ownership isolation through Row Level Security (RLS).
- Versioned `terms_of_service` and `privacy_policy` consent history.
- Append-only security audit log covering registration, login, logout, consent grant/revoke, and profile update.
- Reproducible adversarial security test harness.
- Readiness contract for Nivel 1.2 API work.

### Out of Scope
- OAuth/social, WebAuthn/passkeys, advanced MFA/2FA, SSO.
- Full clinical roles/permissions, crisis protocol, full compliance.
- Clinical backend/frontend, landing, AI, event sourcing/twin/ontology/graph, commerce, advanced realtime.
- Nivel 1.2 implementation.
- Reliable audit emission for `profile_read` and `critical_access` events: direct PostgREST SELECT cannot trigger PostgreSQL audit events, so these events require a trusted backend/RPC in Nivel 1.2. This is a readiness handoff, not a blocker or a fake client-generated event.

## Capabilities

### New Capabilities
- `patient-registration-auth`: Sign-up, sign-in, sign-out, JWT validation/expiration, invalid-token rejection, and server-set `patient` role.
- `patient-profile`: Minimal profile auto-created on registration, readable/editable only by its owner.
- `consent-management`: Versioned consent texts and per-patient grant/revoke history.
- `audit-logging`: Append-only security events for registration, login, logout, consent grant/revoke, and profile update, with a two-year retention policy and no passwords/tokens/secrets.
- `security-test-harness`: Bash/curl/psql tests proving two-patient RLS isolation and session edge cases.

### Modified Capabilities
- None.

## Approach

Use Supabase Auth/GoTrue as the single identity source. Local development and tests enable `ENABLE_EMAIL_AUTOCONFIRM` only; production and real environments keep real email verification. A database trigger on `auth.users` sets the immutable `patient` role in `raw_app_meta_data` and creates a minimal `patient_profiles` row. RLS policies enforce `(select auth.uid()) = user_id` ownership on patient tables; audit logs are written only by `SECURITY DEFINER` functions in a non-exposed schema. Consent grants and revokes are append-only historical rows. Exact SQL policy syntax is reserved for the spec/design phase.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `openspec/specs/patient-registration-auth/` | New | Auth flows and session requirements |
| `openspec/specs/patient-profile/` | New | Profile ownership and RLS |
| `openspec/specs/consent-management/` | New | Versioned consent requirements |
| `openspec/specs/audit-logging/` | New | Audit event taxonomy and retention |
| `openspec/specs/security-test-harness/` | New | Reproducible adversarial tests |
| `supabase/migrations/` | New | Schema, RLS, triggers, functions |
| `docker-compose.yml` / `.env.example` | Modified | `ENABLE_EMAIL_AUTOCONFIRM` env note (local only) |
| `scripts/test-nivel-1-1-security.sh` | New | Two-patient adversarial test harness |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Local autoconfirm leaks to production | Medium | Document env gate; production provisioning checklist rejects autoconfirm |
| RLS policy mistakes expose cross-patient data | Medium | Mandatory two-patient adversarial tests in harness |
| Role in `raw_app_meta_data` stale until refresh | Low | Role is set once at registration and never changed |
| Audit write path exposed in `public` schema | Low | Use non-exposed schema + `SECURITY DEFINER` with `auth.uid()` guard |

## Rollback Plan

Stop services and restore the pre-migration database from backup, or run the inverse rollback SQL (drop auth trigger/function, drop audit triggers/functions, drop patient/consent policies and RLS, drop tables). Preserve `auth.users` rows during rollback so existing identities are not lost.

## Dependencies

- Nivel 0.2 base infrastructure verified and authorized.
- Supabase CLI/local stack available.

## Success Criteria

- [ ] Patient can register, login, and logout with a valid JWT.
- [ ] Invalid, missing, or expired token is rejected with `401`.
- [ ] `patient` role is set automatically and is immutable from the client.
- [ ] Patient can read and update only their own profile; cross-patient access is denied.
- [ ] Consent grant/revoke is recorded with version history.
- [ ] Mandatory audit events (registration, login, logout, consent grant/revoke, profile update) are logged without passwords, tokens, or secrets.
- [ ] `scripts/test-nivel-1-1-security.sh` passes with two-patient adversarial assertions.
