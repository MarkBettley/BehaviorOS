# Delta for Base Infrastructure — Nivel 0.2

This spec materializes the already-implemented Nivel 0.2 base infrastructure state. **COMPLETED** items are historical evidence, not executable work. **PENDING** items are Objectives B and C.

## ADDED Requirements

### Requirement: Completed alignment state (COMPLETED)

The base infrastructure MUST retain alignment to Supabase snapshot `e2e2fac40ba532142bbb31c04313e25394408ca0`, the verified official assets (`webhooks.sql`, `jwt.sql`, `kong.yml`, `roles.sql`), and the designated DB users (`supabase_auth_admin`, `authenticator`, `supabase_storage_admin`, `supabase_admin`).

#### Scenario: Alignment evidence is intact

- GIVEN the aligned files and rendered Compose config are present
- WHEN the snapshot, asset hashes, and DB users are checked
- THEN they match the values recorded in historical evidence

### Requirement: Database bootstrap order (COMPLETED)

The `db` service MUST initialize `98-webhooks.sql`, `99-jwt.sql`, `99-roles.sql`, then bundled migrations, and become healthy.

#### Scenario: Bootstrap log matches expected sequence

- GIVEN a fresh start of `db`
- WHEN container logs are inspected
- THEN scripts run in order, `supabase_functions_admin` exists before role alterations, and `pg_isready` reports healthy

### Requirement: Core service health states (COMPLETED)

The `db`, `auth`, `meta`, and `imgproxy` services MUST be `healthy`; `rest` MUST be running.

#### Scenario: Core services report healthy

- GIVEN the stack is started
- WHEN `docker compose ps` is inspected
- THEN `db`, `auth`, `meta`, and `imgproxy` are healthy
- AND `rest` is running

### Requirement: Storage runtime response (COMPLETED)

The Storage API MUST respond HTTP 200 at `http://127.0.0.1:5000/status` from inside its container.

#### Scenario: Storage responds on IPv4 loopback

- GIVEN the storage container is running
- WHEN `wget --spider http://127.0.0.1:5000/status` is run inside it
- THEN the command exits 0

### Requirement: Volume preservation (COMPLETED)

The system MUST NOT delete the volumes `behavioralos_behavioralos-db-data`, `behavioralos_behavioralos-db-data-clean`, `behavioralos_behavioralos-db-data-aligned`, and `behavioralos_db-config`.

#### Scenario: Historical volumes remain after down

- GIVEN the stack is stopped with `docker compose down` without `-v`
- WHEN `docker volume ls` is queried
- THEN the four named volumes are still present

### Requirement: Storage healthcheck uses IPv4 loopback (PENDING — Objective B)

The Storage healthcheck test MUST reference `http://127.0.0.1:5000/status` instead of `http://localhost:5000/status`.

#### Scenario: Compose config validates after the URL change

- GIVEN the Storage healthcheck URL is updated to `127.0.0.1`
- WHEN `docker compose config -q` is run
- THEN it exits 0 with no validation errors

### Requirement: Full stack runtime verification (PENDING — Objective C)

After the healthcheck fix, the stack MUST start and every service (`db`, `auth`, `rest`, `storage`, `meta`, `imgproxy`, `kong`, `studio`) MUST reach healthy or running state.

#### Scenario: All services pass healthchecks

- GIVEN `docker compose config -q` succeeds
- WHEN `docker compose up -d` is executed
- THEN every service reaches `healthy` or `running`
- AND Storage responds 200 at `http://127.0.0.1:5000/status`

### Requirement: PostgreSQL persistence across restart (PENDING — Objective C)

The system MUST preserve the PostgreSQL `system_identifier` and applied migration state across a restart without `-v`.

#### Scenario: Persistence survives restart

- GIVEN the stack is running after Objective C verification
- WHEN `docker compose down` without `-v` and `docker compose up -d` are run
- THEN the recorded `system_identifier` equals the previous value
- AND `supabase migration list --local` reports the same applied migrations

### Requirement: SDD verification gate (PENDING — Objective C)

Nivel 0.2 MUST be marked complete only after `sdd-verify` passes, and work MUST NOT advance to Nivel 1.1 without explicit authorization.

#### Scenario: Verification gate passes

- GIVEN all runtime and persistence checks are green
- WHEN `sdd-verify` runs for this change
- THEN the verify report shows success
- AND Nivel 1.1 remains blocked until authorized

## MODIFIED Requirements

None.

## REMOVED Requirements

None.

## RENAMED Requirements

None.
