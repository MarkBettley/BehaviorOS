# Tasks: Nivel 0.2 — Base Infrastructure

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~20–70 |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | Single PR |
| Delivery strategy | ask-on-risk |
| Chain strategy | pending |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Low

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Confirm the existing Storage healthcheck behavior and apply the one-line `localhost` → `127.0.0.1` fix only. | PR 1 | `docker compose config -q` | N/A — planning artifact only; runtime steps are executed in the apply/verify phase. | Revert the single healthcheck URL line in `docker-compose.yml`. |
| 2 | Verify the aligned stack, persistence evidence, and closure gate for Nivel 0.2. | PR 1 | `sdd-verify` | Start the existing stack, inspect all services, restart without `-v`, and compare identifiers/migrations. | Stop after evidence capture; no volume reset, no Nivel 1.1 work. |

## Phase 1: Scope Boundary and Healthcheck Fix

Completed historical context: the ~1,250-line infrastructure, snapshot evidence, and preserved volumes are baseline state and must not become executable work.

- [x] 1.1 Confirm the existing Storage healthcheck behavior as the only pending implementation boundary (B1).
- [x] 1.2 Change only the Storage healthcheck URL in `docker-compose.yml` from `localhost` to `127.0.0.1` (B2).
- [x] 1.3 Run `docker compose config -q` and record that the Compose file still validates (B3).

## Phase 2: Runtime Verification and Persistence Evidence

- [x] 2.1 Start the existing stack and verify `db`, `auth`, `rest`, `storage`, `meta`, `imgproxy`, `kong`, and `studio` are healthy or running (C1–C2).
- [x] 2.2 Complete the healthchecks, including the Storage status evidence required by the spec (C3).
- [x] 2.3 Record PostgreSQL `system_identifier` and the pre-restart migration baseline before any shutdown (C4).
- [x] 2.4 Restart the stack without `-v`, then compare the new `system_identifier` and migration list against the baseline (C5–C6).

## Phase 3: Verification Gate and Closure

| Gate | Required behavior |
|------|-------------------|
| C7 | Hold `sdd-verify` as the required post-apply workflow gate; do not mark this native task complete here. |
| C8 | Close Nivel 0.2 only after `sdd-verify` passes. |
| C9 | Stop before any Nivel 1.1 work. |
