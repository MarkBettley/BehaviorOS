# Security Audit Logging Specification

## Purpose

Define an append-only security audit log for authentication, consent, and profile events without secrets or tampering.

## Requirements

### Requirement: Audit event taxonomy

The system MUST record `registration`, `login`, `logout`, `consent_grant`, `consent_revoke`, and `profile_update` events. The schema MAY reserve `profile_read` and `critical_access` for Nivel 1.2; Nivel 1.1 MUST NOT generate or fabricate them.

#### Scenario: Mandatory events logged

- GIVEN a patient registers, logs in, logs out, grants and revokes consent, and updates their profile
- WHEN audit log is inspected
- THEN events exist for the six mandatory types with the patient as actor if identifiable

#### Scenario: Deferred events not emitted

- GIVEN a patient reads their profile or performs `critical_access`
- WHEN audit log is inspected in Nivel 1.1
- THEN no `profile_read`/`critical_access` rows exist

### Requirement: Event payload fields

Every audit event MUST include event identifier, `event_type`, `occurred_at`, and `outcome`. For the six critical operation events, the system MUST include `correlation_id`. `actor_user_id` MUST be included when an identifiable user exists; registration MAY record actor context matching identity creation. `origin` MAY be recorded only from reliable context, is nullable, MUST NOT be fabricated, and its absence MUST NOT block the operation. `auth.sessions` is not authoritative for `origin` or `correlation_id`. When `correlation_id` is absent or invalid at controlled BehaviorOS entry, the system MUST generate an opaque non-PII identifier and propagate it. The system MUST NOT use a JWT, access token, refresh token, password, service-role key, or secret as `correlation_id`.

#### Scenario: Successful critical operation events

- GIVEN a patient logs in, logs out, grants or revokes consent, or registers
- WHEN audit rows are inspected
- THEN each event has present `correlation_id`, `actor_user_id` when identifiable, `outcome` `success`, and null-allowed `origin`

#### Scenario: Failed login event

- GIVEN a failed login that can be emitted safely
- WHEN audit row is inspected
- THEN `event_type` is `login`, `outcome` is `failure`, `correlation_id` is present, `actor_user_id` is absent or null, `origin` may be null, and no credentials stored

#### Scenario: Missing origin or correlation_id does not block

- GIVEN a controlled operation lacks origin or a valid `correlation_id`
- WHEN audit event is written
- THEN operation succeeds, `origin` is null, and system generated an opaque non-PII ID

### Requirement: No secrets in audit logs

The system MUST NOT write passwords, full JWTs, access tokens, refresh tokens, API keys, service-role keys, or other secrets into audit context.

#### Scenario: Audit context excludes secrets

- GIVEN a patient logs in or registers
- WHEN audit context is inspected
- THEN no password, JWT, refresh token, service-role key, hash, or token is present

### Requirement: Trusted write path only

Audit rows MUST be inserted only through trusted backend code, database triggers, or `SECURITY DEFINER` functions in a non-exposed schema with safe `search_path` and `auth.uid()` checks.

#### Scenario: Patient write attempts denied

- GIVEN a patient with a valid JWT
- WHEN they insert directly into `audit_logs` or call a function writing an event for another user
- THEN the insert is rejected and the function rejects the call or writes no row

### Requirement: Two-year retention

The system MUST retain audit logs at least two years from `occurred_at`.

#### Scenario: Retention policy declared

- GIVEN the audit schema is inspected
- WHEN retention configuration is reviewed
- THEN a documented two-year retention rule or scheduled cleanup exists

## Nivel 1.2 Readiness Contract

Nivel 1.2 MAY rely on:
- an append-only `audit_logs` table with event identifier, `actor_user_id`, `event_type`, `occurred_at`, and `outcome`;
- the six Nivel 1.1 audit events;
- patients unable to mutate audit rows.

Nivel 1.2 MAY extend the taxonomy with `profile_read` and `critical_access` through a trusted backend/RPC, because PostgreSQL cannot audit direct SELECT with triggers. Nivel 1.1 MUST NOT emit these events.

Nivel 1.2 MUST NOT expect `profile_read` or `critical_access` events, full compliance reporting, clinical audit trails, or immutable off-site archiving from this change.
