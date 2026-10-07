# Security Test Harness Specification

## Purpose

Define a reproducible, lightweight test harness that proves two-patient isolation, auth edge cases, RLS enforcement, consent history, and audit integrity.

## Requirements

### Requirement: Reproducible harness

The system MUST provide `scripts/test-nivel-1-1-security.sh` running bash/curl/psql tests against the local Supabase stack without manual steps.

#### Scenario: Harness runs from clean state

- GIVEN the local stack is running
- WHEN `scripts/test-nivel-1-1-security.sh` is executed
- THEN it exits 0 and prints a summary of passed assertions

### Requirement: Two-patient adversarial isolation

The harness MUST create patients A and B and verify A cannot read or modify B's profile, consents, or audit events.

#### Scenario: Cross-patient SELECT denied

- GIVEN patient A and patient B each have profiles
- WHEN the harness queries patient B's profile using patient A's JWT
- THEN the response contains zero rows

#### Scenario: Cross-patient UPDATE denied

- GIVEN patient A and patient B each have profiles
- WHEN the harness updates patient B's profile using patient A's JWT
- THEN the update affects zero rows

### Requirement: Auth lifecycle coverage

The harness MUST verify successful registration, successful login, invalid credential rejection, valid token acceptance, and logout behavior.

#### Scenario: Invalid credentials rejected

- GIVEN a registered patient
- WHEN login is attempted with the wrong password
- THEN the response is `400` or `401`

#### Scenario: Expired token rejected when reproducible

- GIVEN a short-lived token can be issued or manipulated in the test environment
- WHEN the harness uses that expired token
- THEN the request returns `401 Unauthorized`

### Requirement: RLS functional enforcement

The harness MUST assert that RLS is enabled on `patient_profiles`, `patient_consents`, and `audit_logs`, and that ownership predicates are enforced for SELECT, INSERT, UPDATE, and DELETE.

#### Scenario: RLS enabled on patient tables

- GIVEN the schema is inspected via `psql`
- WHEN `relrowsecurity` is checked for each patient-owned table
- THEN it is `true`

#### Scenario: Unauthorized INSERT rejected

- GIVEN patient A's JWT
- WHEN the harness inserts a `patient_profiles` row with `user_id` set to patient B
- THEN the insert is rejected

### Requirement: Consent version and history

The harness MUST verify that consent versions are published, grants are recorded, revokes append without overwriting, and current state follows the latest action.

#### Scenario: Consent history immutable

- GIVEN a patient grants and then revokes `privacy_policy`
- WHEN the consent history is queried
- THEN two rows exist and the original grant row is unchanged

### Requirement: Audit event creation and direct-write denial

The harness MUST confirm that registration, login, logout, consent grant/revoke, and profile update create audit events, that patients cannot directly write audit rows, and MUST NOT assert `profile_read` or `critical_access` events in Nivel 1.1.

#### Scenario: Mandatory audit events created

- GIVEN the harness executes registration, login, logout, consent grant/revoke, and profile update
- WHEN the audit log is queried
- THEN corresponding event rows exist for each action
- AND no `profile_read` or `critical_access` rows are asserted

#### Scenario: Direct audit insert denied

- GIVEN a valid patient JWT
- WHEN the harness attempts to insert into `audit_logs` via the REST API
- THEN the response is `401 Unauthorized` or `403 Forbidden`

### Requirement: Safe cleanup

The harness MUST delete test patients using the Supabase Auth admin API or equivalent service-role path, and MUST NOT leave test data that weakens RLS or exposes service-role credentials to clients.

#### Scenario: Cleanup removes test identities

- GIVEN the harness has completed assertions
- WHEN cleanup runs
- THEN test patients are removed from `auth.users` and their dependent rows are removed or orphaned rows are documented

## Nivel 1.2 Readiness Contract

Nivel 1.2 MAY rely on:
- `scripts/test-nivel-1-1-security.sh` passing as a pre-condition for auth-dependent work;
- the existence of deterministic adversarial ownership tests for every patient-owned table.

Nivel 1.2 MUST NOT expect clinical API tests, frontend automation, or performance benchmarks from this change.
