# Consent Management Specification

## Purpose

Define versioned `terms_of_service` and `privacy_policy` consent texts and immutable per-patient grant/revoke history.

## Requirements

### Requirement: Separate consent scopes

The system MUST maintain two independent consent scopes: `terms_of_service` and `privacy_policy`.

#### Scenario: Scopes are independent

- GIVEN a patient has granted `terms_of_service` version 1.0.0
- WHEN `privacy_policy` version 1.0.0 is published
- THEN the patient has not automatically granted `privacy_policy`

### Requirement: Versioned consent texts

The system MUST store each consent scope's text with a semantic version, effective timestamp, and unique identifier.

#### Scenario: Publish new consent version

- GIVEN an existing `terms_of_service` version 1.0.0
- WHEN version 1.1.0 is published
- THEN both versions remain queryable and version 1.1.0 is marked as the current version

### Requirement: Immutable grant and revoke records

The system MUST record every grant and revoke as an append-only historical row containing scope, version, patient identity, timestamp, and action (`grant` or `revoke`).

#### Scenario: Grant recorded historically

- GIVEN a patient grants `privacy_policy` version 1.0.0
- WHEN the `patient_consents` table is queried
- THEN an append-only row exists with scope `privacy_policy`, version `1.0.0`, the patient's `user_id`, action `grant`, and the current timestamp

#### Scenario: Revoke does not overwrite grant

- GIVEN a patient has granted `privacy_policy`
- WHEN the patient revokes it
- THEN a new row with action `revoke` is inserted and the original grant row remains unchanged

### Requirement: Current consent determination

The system MUST determine the current consent state for a scope by evaluating the most recent grant or revoke record for that scope and patient.

#### Scenario: Current state reflects latest action

- GIVEN a patient granted `terms_of_service` and later revoked it
- WHEN current consent is computed
- THEN the effective state is `revoked`

#### Scenario: Re-grant after revoke

- GIVEN a patient revoked `terms_of_service`
- WHEN the patient grants the current version again
- THEN the effective state returns to `granted` for the current version

### Requirement: Consent RLS matrix

The system MUST enable RLS and enforce the following matrix:

| Table | Operation | Role | USING | WITH CHECK |
|-------|-----------|------|-------|------------|
| `consent_versions` | SELECT | authenticated | `true` (read current/past versions) | — |
| `consent_versions` | INSERT/UPDATE/DELETE | authenticated | denied (no policy) | denied (no policy) |
| `patient_consents` | SELECT | authenticated | `(select auth.uid()) = user_id` | — |
| `patient_consents` | INSERT | authenticated | — | `(select auth.uid()) = user_id` |
| `patient_consents` | UPDATE/DELETE | authenticated | denied (no policy) | denied (no policy) |
| ALL | anon | denied (no policy) | denied (no policy) |

#### Scenario: Patient reads only own consent history

- GIVEN patients A and B have consent records
- WHEN patient A queries `patient_consents`
- THEN only rows with `user_id` equal to patient A's UUID are returned

#### Scenario: Patient cannot modify consent history

- GIVEN a patient has a consent record
- WHEN the patient attempts to update or delete that record
- THEN the operation affects zero rows

## Nivel 1.2 Readiness Contract

Nivel 1.2 MAY rely on:
- `consent_versions` exposing the current published text per scope;
- `patient_consents` providing an immutable grant/revoke history per patient;
- current consent state being derivable from the latest row per patient and scope.

Nivel 1.2 MUST NOT expect consent for clinical data use, marketing, third-party sharing, or minors from this change.
