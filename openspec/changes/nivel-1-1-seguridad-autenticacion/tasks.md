# Tasks: Nivel 1.1 — Auth & Security

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: pending
400-line budget risk: High

| PR | Slices/LOC | D | Sc | B/OOS | V | Rb | X/F |
|---|---|---|---|---|---|---|---|
| PR1 | S1-S2 63-110 | archived N0.2 | probe+schema | no reg/login/profile/consent/audit/RLS; OOS S3-S8/P3/N1.2 | schema/readback | PR1 schema/migrations; keep evidence | base schema; F=PR2 |
| PR2 | S3-S6 185-300 | PR1/base schema | reg/autoconfirm/login/JWT/logout/profile/consent | no S7/S8/P3/denylist/OAuth/MFA/WebAuthn/SSO/N1.2 | triples+negatives; env auth; role override; no denylist | PR2 code/migrations; keep PR1/history | session/profile/consent; F=PR3 |
| PR3 | S7-S8+P3 158-260 | PR1+PR2 | audit/trusted writer/RLS/evidence | no new Auth/denylist/OAuth/MFA/WebAuthn/SSO/clinical roles/features/N1.2 | triples, evidence, writer INSERT-only, policy readback | PR3 policies/audit/code; keep PR1/2/history/evidence | sdd-verify-ready; F=verify→archive if PASS |

## Phase 1: Probe + Schema
- [ ] S1 RED: probe `auth.sessions`; confirm INSERT/DELETE.
- [ ] S1 GREEN: minimal harness/adapter; no secrets.
- [ ] S1 READBACK: repeat probe; record evidence; STOP.
- [ ] S2 RED: fail tables/columns/types/defaults/constraints/PK/FK/indexes/grants/schema.
- [ ] S2 GREEN: apply schema in baseline migrations.
- [ ] S2 READBACK: inspect schema; rerun.

## Phase 2: Identity, Session, Profile, Consent
- [ ] S3 RED: local `ENABLE_EMAIL_AUTOCONFIRM=true`; other env `false`; registration succeeds; external `role!=patient` rejected.
- [ ] S3 GREEN: approved config/protection only.
- [ ] S3 READBACK: env, setting, expected/observed outcome, final role; no secrets.
- [ ] S4 RED: NO access-JWT denylist/revocation list; no mechanism invalidates an access JWT before `exp`; `session/refresh revocation != access-JWT denylist`; test: login gets a JWT with `exp`; logout revokes session/refresh; JWT accepted until `exp`; after `exp` rejected; refresh/session denied.
- [ ] S4 GREEN: logout revokes session/refresh; no access-token denylist; JWT stays valid until `exp`, then is rejected.
- [ ] S4 READBACK: record `exp`, logout, session/refresh, no-denylist evidence, pre-`exp` JWT, post-`exp` JWT, denied continuation.
- [ ] S5 RED: OWN allowed, OTHER denied; A cannot reassign `user_id`/role; B cannot modify A.
- [ ] S5 GREEN: minimum profile restrictions only.
- [ ] S5 READBACK: reassignment/escalation blocked.
- [ ] S6 RED: approved scopes only; acceptance binds version/scopes/patient/timestamp/correlation; nullable origin; immutable history; grant→revoke→re-grant preserves state/events.
- [ ] S6 GREEN: approved consent model only.
- [ ] S6 READBACK: state/version/history/events proven.

## Phase 3: Audit, RLS, Integration
- [ ] S7 RED: six events; id/type/timestamp/outcome; correlation; origin NULL-if-safe; failed login; append-only; writer INSERT-only.
- [ ] S7 GREEN: writer/emission only.
- [ ] S7 READBACK: records/negatives/no deferred events; writer cannot UPDATE/DELETE.
- [ ] S8 RED: run every matrix cell (`table×operation×actor/context`) and capture `{table,operation,actor/context,expected ALLOW|DENY,observed result,PASS|FAIL}`.
- [ ] S8 GREEN: RLS policies/grants only; `USING`/`WITH CHECK`/`auth.uid()`/ownership/user_id/role.
- [ ] S8 READBACK: policy `{table, policy_name, op, roles, USING, WITH CHECK, auth.uid(), ownership, user_id, role}`; each table×SELECT/INSERT/UPDATE/DELETE cell log `{actor/context,operation,expected,observed,PASS/FAIL}`; trusted writer INSERT ALLOW, UPDATE DENY, DELETE DENY; authenticated patient SELECT own ALLOW, other's DENY, INSERT/UPDATE/DELETE DENY; anonymous SELECT/INSERT/UPDATE/DELETE DENY; rerun every RLS cell incl. DENY, OWN, A→B, B→A, anon, trusted writer.
- [ ] P3.1 suite; no new RED/impl.
- [ ] P3.2 READBACK DoD evidence; `sdd-verify` ready.
- [ ] P3.3 final READBACK; stop before Nivel1.2.
