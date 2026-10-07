# Patient Profile Specification

## Purpose

Define the minimal patient profile, its automatic creation after registration, and row-level ownership policies that enforce one-patient-per-row isolation.

## Requirements

### Requirement: Profile auto-created on registration

The system MUST create a `patient_profiles` row within the same transaction as the `auth.users` insert triggered by successful registration.

#### Scenario: Profile exists after registration

- GIVEN a patient completes registration
- WHEN the `patient_profiles` table is queried
- THEN exactly one row exists with `user_id` equal to the new `auth.users.id`

### Requirement: Patient owns exactly one profile

The system MUST enforce that a patient can read and update only the profile row whose `user_id` equals their authenticated UUID. Direct profile deletion by the patient is prohibited; account deletion is outside the scope of Nivel 1.1 and MUST use a future trusted flow.

#### Scenario: Patient reads own profile

- GIVEN a patient with a profile
- WHEN they query `patient_profiles`
- THEN they receive only their own row

#### Scenario: Patient denied another patient's profile

- GIVEN patient A and patient B each have profiles
- WHEN patient A queries `patient_profiles` with a filter for patient B's `user_id`
- THEN the result contains zero rows

#### Scenario: Patient direct DELETE denied

- GIVEN a patient owns a profile
- WHEN they attempt to DELETE their own `patient_profiles` row
- THEN the statement affects zero rows

### Requirement: Prevent user_id reassignment

The system MUST reject any `UPDATE` that would change a profile's `user_id` to a different UUID.

#### Scenario: Reassign user_id fails

- GIVEN a patient owns a profile
- WHEN an update attempts to set `user_id` to another patient's UUID
- THEN the update affects zero rows

### Requirement: RLS policy matrix

The system MUST enable RLS on `patient_profiles` and enforce the following policy matrix exactly:

| Operation | Role | USING | WITH CHECK |
|-----------|------|-------|------------|
| SELECT | authenticated | `(select auth.uid()) = user_id` | — |
| INSERT | authenticated | — | `(select auth.uid()) = user_id` |
| UPDATE | authenticated | `(select auth.uid()) = user_id` | `(select auth.uid()) = user_id` |
| DELETE | authenticated | denied (no policy) | denied (no policy) |
| ALL | anon | denied (no policy) | denied (no policy) |

#### Scenario: RLS matrix enforced across operations

- GIVEN the matrix above is applied
- WHEN patient A performs SELECT/INSERT/UPDATE on their own row and on patient B's row, and DELETE on both rows
- THEN SELECT/INSERT/UPDATE succeed on A's row and affect zero rows on B's row
- AND DELETE affects zero rows on both A's and B's rows

#### Scenario: Anonymous access denied

- GIVEN no valid JWT
- WHEN `anon` role attempts any operation on `patient_profiles`
- THEN the request returns `401 Unauthorized`

### Requirement: Profile fields are minimal

The profile SHOULD contain only `id`, `user_id`, `created_at`, `updated_at`, and optional display fields explicitly added by this change.

#### Scenario: No clinical or sensitive fields

- GIVEN the profile schema is inspected
- WHEN columns are listed
- THEN no clinical history, diagnosis, payment, or government identifier columns exist

## Nivel 1.2 Readiness Contract

Nivel 1.2 MAY rely on:
- a `patient_profiles` row existing for every registered patient;
- `(select auth.uid()) = user_id` as the ownership primitive;
- `patient_profiles` RLS being enforced for SELECT, INSERT, and UPDATE.

Nivel 1.2 MUST NOT expect therapist, admin, or multi-patient household access from this change.
