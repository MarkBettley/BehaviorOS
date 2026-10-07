# Patient Registration & Authentication Specification

## Purpose

Define email/password registration, session lifecycle, JWT handling, and the immutable server-controlled `patient` role.

## Requirements

### Requirement: Registration via Supabase Auth

The system MUST accept patient registration with email and password through Supabase Auth/GoTrue.

#### Scenario: Successful registration

- GIVEN a valid email and password meeting Supabase Auth strength rules
- WHEN the patient registers
- THEN the system creates an `auth.users` row and returns the user identity

#### Scenario: Duplicate registration rejected

- GIVEN an email already present in `auth.users`
- WHEN a new registration uses that email
- THEN the system rejects it with a deterministic error

### Requirement: Local autoconfirm only

The system MUST enable `ENABLE_EMAIL_AUTOCONFIRM=true` only in local and test environments.

#### Scenario: Local registration completes without mailer

- GIVEN `ENABLE_EMAIL_AUTOCONFIRM=true` is set locally
- WHEN a patient registers
- THEN the account is confirmed immediately

#### Scenario: Production requires real verification

- GIVEN a non-local environment with `ENABLE_EMAIL_AUTOCONFIRM=false`
- WHEN a patient registers
- THEN email confirmation is required before activation

### Requirement: Immutable patient role

The system MUST set the initial role to exactly `patient` in `raw_app_meta_data` and MUST NOT allow the client to modify it.

#### Scenario: Role set automatically on registration

- GIVEN a new patient completes registration
- WHEN the `auth.users` row is inspected
- THEN `raw_app_meta_data->>'app_role'` equals `patient`

#### Scenario: Client role override ignored

- GIVEN a registration request includes metadata claiming another role
- WHEN the account is created
- THEN the stored application role remains `patient`

### Requirement: Valid login and session

The system MUST issue a valid access JWT and refresh token when credentials are correct.

#### Scenario: Successful login

- GIVEN a registered patient with valid credentials
- WHEN the patient logs in
- THEN the response contains an access JWT with `sub` equal to the patient UUID and a refresh token

#### Scenario: Access token authorizes requests

- GIVEN a valid access JWT
- WHEN it is sent in the `Authorization: Bearer <token>` header
- THEN authenticated endpoints accept the request while the token is unexpired

### Requirement: Invalid credentials rejected

The system MUST reject login requests with incorrect credentials.

#### Scenario: Wrong password and unknown email rejected

- GIVEN a registered patient and an email not in `auth.users`
- WHEN login is attempted with the wrong password and with the unknown email
- THEN both requests return the same `400` or `401` error

### Requirement: Invalid or expired JWT rejected

The system MUST reject missing, malformed, wrong-signature, and expired access JWTs with `401`.

#### Scenario: Missing and malformed token rejected

- GIVEN requests with no `Authorization` header and a non-Bearer header
- WHEN processed
- THEN both return `401`

#### Scenario: Wrong-signature and expired token rejected

- GIVEN a JWT signed with the wrong key and a JWT with past `exp`
- WHEN processed
- THEN both return `401`

### Requirement: Logout ends current session

The system MUST revoke the current refresh token and session on logout; the access JWT remains usable until its `exp` claim per Supabase semantics.

#### Scenario: Current session logout

- GIVEN a logged-in patient
- WHEN logout is called with the current refresh token
- THEN the refresh token is revoked and cannot be used to refresh
- AND the client discards the access token

#### Scenario: Logout does not invalidate access token before exp

- GIVEN a patient who has called logout
- WHEN the existing access token is used before its `exp`
- THEN Supabase continues to honor it

## Nivel 1.2 Readiness Contract

Nivel 1.2 MAY rely on:
- patient identity in `auth.users` with UUID `sub`;
- immutable `patient` role in `raw_app_meta_data`;
- valid access JWTs validated by PostgREST/Kong;
- deterministic rejection of missing, malformed, wrong-signature, and expired tokens.

Nivel 1.2 MUST NOT expect OAuth, social login, MFA, WebAuthn, SSO, or admin/therapist role authorization from this change.
