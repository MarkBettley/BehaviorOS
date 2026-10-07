# Archive Report — nivel-1-2-backend-minimo

**Status**: ARCHIVED — SDD cycle complete
**Archived**: 2026-10-07
**Artifact store**: OpenSpec
**Archive path**: `openspec/changes/archive/2026-10-07-nivel-1-2-backend-minimo/`

## Final State at Close

| Metric | Value |
|---|---:|
| Tasks | 15/15 complete |
| Requirements | 10/10 |
| Scenarios | 23/23 |
| Verify verdict | PASS (valid=true, blockers=0, critical=0) |
| Verify report digest (archived file) | `sha256:c13d7d30372f9f0f622c3d64da38c718fbcd681cb6375344520c21cc8ccc8198` |
| Final verification evidence revision | `sha256:f2282c4dc221aba357ebca2d5f9d090e8848e4c4e67ae4ed29d50f6531a44f91` |
| Verification attempt token | `sha256:3ed84b8faafdf746b56faf1f503f37363f92832cdc82aed5bc010bf55face6ab` (settled passed) |
| Accepted remediation evidence | `sha256:7139b0c9ed27c2e8d67ea07426b1eb6d41c667abf979c1e6f8e7363f744c2661` |
| Remediated failed evidence (superseded) | `sha256:4ca0d82a4af431364af61f55541d28ae87d34078479dfc6ae8da0c50ba042dde` |
| Config-required healthcheck | exit 0, includes imgproxy HTTP 200 |
| Level 1.2 harness | exit 0, `PASS=50 FAIL=0` |
| Build/type check | `python3 -m compileall -q backend/app` exit 0 |

## Final-State Authority Notes

- Operational imgproxy remediation is formally recognized by native SDD with `changed_lines: 0`; remediation is no longer required.
- Fresh post-remediation verification PASSED: healthcheck exit 0 including imgproxy HTTP 200, harness `PASS=50 FAIL=0`, compliance 10/10 requirements and 23/23 scenarios.
- Canonical persisted verify report (`verify-report.md`) is valid with zero blockers and zero critical findings; its header YAML records `verdict: pass`, `evidence_revision: sha256:f2282c4d…`.
- No CRITICAL issues, no WARNING issues. One SUGGESTION: keep imgproxy operational while archive readiness depends on `openspec/config.yaml` `rules.verify` requiring `./scripts/healthcheck.sh`.
- `apply-progress.md` contains intermediate snapshots (including pre-remediation state) and is historical only; it does not describe final state.
- Final-state facts above were supplied by the orchestrator launch prompt and are corroborated by the canonical persisted `verify-report.md`.

## Specs Synced to Main (Source of Truth)

| Domain | Action | Path |
|---|---|---|
| backend-api | Created (full spec) | `openspec/specs/backend-api/spec.md` |
| therapeutic-exercise | Created (full spec) | `openspec/specs/therapeutic-exercise/spec.md` |

Neither domain existed in `openspec/specs/` before this archive, so each delta spec IS a full spec and was copied directly (no requirement merge, no removals, no destructive delta — `rules.archive` "warn before merging destructive deltas" not triggered).

- Copy mechanism: native shell `cp` into a freshly created `openspec/specs/{domain}/`, per the Mechanical Copy Contract; no model Read/Write path touched artifact bytes.
- Mandatory readback `diff -r` source vs destination: **empty (exit 0)** for both domains — byte identity preserved.
- Resulting main specs: `openspec/specs/backend-api/spec.md` (99 lines, 5 requirements / 12 scenarios), `openspec/specs/therapeutic-exercise/spec.md` (106 lines, 5 requirements / 11 scenarios) — 10 requirements / 23 scenarios total, matching verify compliance counts.
- Existing main specs (audit-logging, base-infrastructure, consent-management, patient-profile, patient-registration-auth, security-test-harness) were not modified.

## Archive Integrity

- Move mechanism: native shell `mv` (change folder was untracked in git, so `git mv` was not applicable) after a recursive pre-move snapshot under `${TMPDIR:-/tmp}`.
- Source verified absent post-move.
- Mandatory readback `diff -r pre-move-snapshot destination`: **empty (exit 0)** — byte-identity preserved.
- Archived contents (11 files): `.gentle-ai-instance`, `proposal.md`, `exploration.md`, `research.md`, `preproposal.md`, `design.md`, `tasks.md` (15/15 checked, 0 unchecked), `apply-progress.md`, `verify-report.md`, `specs/backend-api/spec.md`, `specs/therapeutic-exercise/spec.md`.
- Verification evidence preserved: canonical `verify-report.md` is present in the archived folder unchanged, digest `sha256:c13d7d30372f9f0f622c3d64da38c718fbcd681cb6375344520c21cc8ccc8198`; `apply-progress.md` retained alongside it.
- Active changes directory no longer contains this change (`openspec/changes/` now holds only `archive/`).
- No application implementation, Nivel 1.1 artifact, container, volume, or database was modified by this archive.

## Gate Compliance

- Task Completion Gate: PASS (persisted `tasks.md` shows 15/15 checked, 0 `- [ ]`).
- Archive Readiness: PASS (native status `dependencies.archive: ready`, `nextRecommended: archive`, blockedReasons empty).
- CRITICAL verification findings: none — archivable under the Strict archive policy without override.
- No maintainer decision required; archive executed under explicit archive authorization already granted by the orchestrator.
