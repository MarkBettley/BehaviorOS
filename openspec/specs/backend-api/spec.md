# Backend API Specification

## Purpose

Define the minimum FastAPI backend that validates Supabase JWTs, resolves patient identity/profile, exposes health and auth endpoints, and protects therapeutic-exercise resources.

## Requirements

### Requirement: Service health endpoint

The backend MUST expose a public health endpoint so orchestrators can verify it is running.

#### Scenario: Healthy backend responds

- GIVEN the `backend` container is running
- WHEN an unauthenticated client sends `GET /api/v1/health`
- THEN the response status is `200 OK`
- AND the body contains `{"status":"ok"}` or equivalent

### Requirement: JWT validation

The backend MUST validate every request to protected routes using the configured Supabase JWT secret and hard-coded HS256 algorithm.

#### Scenario: Valid JWT grants access

- GIVEN a request carries a valid, unexpired Supabase access token
- WHEN the client calls any protected `/api/v1` route
- THEN the backend decodes the token with `algorithms=["HS256"]`
- AND the request proceeds with the `sub` claim as the authenticated user id

#### Scenario: Missing JWT returns 401

- GIVEN a request to a protected route has no `Authorization` header
- WHEN the route handler executes
- THEN the response status is `401 Unauthorized`

#### Scenario: Invalid or expired JWT returns 401

- GIVEN a request carries a malformed, tampered, or expired token
- WHEN the route handler executes
- THEN the response status is `401 Unauthorized`
- AND the backend does not process the request

#### Scenario: Algorithm confusion is rejected

- GIVEN a token whose header claims `alg: "none"` or an unexpected algorithm
- WHEN the backend attempts validation
- THEN validation fails and the response status is `401 Unauthorized`

### Requirement: Identity and profile resolution

The `GET /api/v1/auth/me` endpoint MUST return the authenticated user's identity and patient profile.

#### Scenario: Authenticated patient reads own identity

- GIVEN a valid patient JWT
- WHEN the client sends `GET /api/v1/auth/me`
- THEN the response status is `200 OK`
- AND the body contains `sub`, `email`, `app_role`, and profile fields from `patient_profiles`

#### Scenario: Unauthenticated request to `/auth/me` returns 401

- GIVEN no JWT or an invalid JWT
- WHEN the client sends `GET /api/v1/auth/me`
- THEN the response status is `401 Unauthorized`

#### Scenario: Patient without profile returns identity only

- GIVEN a valid JWT for a user with no `patient_profiles` row
- WHEN the client sends `GET /api/v1/auth/me`
- THEN the response status is `200 OK`
- AND the body contains identity fields with a null or absent profile block

### Requirement: Resource protection

Protected endpoints MUST require a valid authenticated patient JWT; anonymous or missing tokens MUST be rejected.

#### Scenario: Anonymous JWT cannot access patient resources

- GIVEN a valid anonymous (`is_anonymous: true`) JWT
- WHEN the client calls a protected patient endpoint
- THEN the response status is `401 Unauthorized` or `403 Forbidden`

### Requirement: Versioned OpenAPI contract

The backend MUST expose a versioned OpenAPI contract at `/api/v1/openapi.json` and interactive docs at `/docs`.

#### Scenario: OpenAPI contract is reachable

- GIVEN the backend is running
- WHEN an unauthenticated client sends `GET /api/v1/openapi.json`
- THEN the response status is `200 OK`
- AND the returned JSON declares `openapi` version and `/api/v1` paths

#### Scenario: Interactive docs are reachable

- GIVEN the backend is running
- WHEN an unauthenticated client sends `GET /docs`
- THEN the response status is `200 OK`
