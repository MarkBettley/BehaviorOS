# Therapeutic Exercise Specification

## Purpose

Define the first therapeutic exercise — guided mindfulness breathing — covering catalog access, session lifecycle, minimal telemetry, and patient ownership isolation.

## Requirements

### Requirement: Exercise catalog seed

The system MUST seed exactly one exercise, "guided mindfulness breathing", in the catalog.

#### Scenario: Catalog lists the seeded exercise

- GIVEN the backend and database are running
- WHEN an authenticated patient sends `GET /api/v1/exercises`
- THEN the response status is `200 OK`
- AND the list contains exactly one exercise with `type: mindfulness`

#### Scenario: Retrieve single exercise by id

- GIVEN exercise `EX_1` exists
- WHEN an authenticated patient sends `GET /api/v1/exercises/EX_1`
- THEN the response status is `200 OK`
- AND the response contains exercise metadata and instructions

### Requirement: Start exercise session

The system MUST create a new exercise session when a patient starts an exercise.

#### Scenario: Patient starts mindfulness breathing

- GIVEN exercise `EX_1` exists
- WHEN an authenticated patient sends `POST /api/v1/exercises/EX_1/start`
- THEN the response status is `201 Created`
- AND the response contains `session_id`, `exercise_id`, `started_at`, and `status: active`

#### Scenario: Starting a non-existent exercise returns 404

- GIVEN an exercise id does not exist
- WHEN an authenticated patient sends `POST /api/v1/exercises/{id}/start`
- THEN the response status is `404 Not Found`

### Requirement: Complete exercise session

The system MUST finalize an active session, record duration and completion status, and reject duplicate or unauthorized completions.

#### Scenario: Patient completes an active session

- GIVEN an active session for the authenticated patient
- WHEN the patient sends `POST /api/v1/exercises/EX_1/complete` with the session id and telemetry
- THEN the response status is `200 OK`
- AND the session status becomes `completed`, with `completed_at` and `duration_seconds` set

#### Scenario: Complete without active session returns 400

- GIVEN no active session for the exercise
- WHEN the patient sends `POST /api/v1/exercises/EX_1/complete`
- THEN the response status is `400 Bad Request`

#### Scenario: Idempotent completion

- GIVEN a session is already completed
- WHEN the patient resends the same completion request
- THEN the response status is `200 OK`
- AND no session or telemetry row changes

#### Scenario: Patient cannot complete another patient's session

- GIVEN an active session owned by patient A
- WHEN patient B sends `POST /api/v1/exercises/EX_1/complete` with that session id
- THEN the response status is `404 Not Found`

### Requirement: Telemetry persistence

The system MUST persist exactly four telemetry variables per session: duration, completion, pauses, and retries.

#### Scenario: Completion records telemetry

- GIVEN an active session for the authenticated patient
- WHEN the patient sends `POST /api/v1/exercises/EX_1/complete` with `pauses: 2` and `retries: 1`
- THEN the backend persists telemetry rows for `duration`, `completion`, `pauses`, and `retries`
- AND a direct database query as the patient role returns only rows for that session

### Requirement: Patient ownership isolation

The system MUST ensure a patient can only start, complete, and read their own sessions and telemetry.

#### Scenario: Start creates a session owned by the caller

- GIVEN patient A is authenticated
- WHEN patient A sends `POST /api/v1/exercises/EX_1/start`
- THEN the created session's `patient_id` equals patient A's id
- AND patient B cannot complete or read that session

#### Scenario: RLS blocks cross-patient reads

- GIVEN patient A and patient B each have sessions
- WHEN a direct database query as patient B selects from the sessions table
- THEN only patient B's own sessions are returned

#### Scenario: Telemetry ownership enforced by RLS

- GIVEN telemetry rows owned by patient A's session
- WHEN a direct database query as patient B selects from the telemetry table
- THEN no rows from patient A's sessions are returned
