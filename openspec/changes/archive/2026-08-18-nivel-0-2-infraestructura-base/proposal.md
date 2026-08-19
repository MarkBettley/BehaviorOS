# Proposal: Nivel 0.2 — Base Infrastructure

## Intent

Materialize the OpenSpec proposal for the already-implemented Nivel 0.2 base infrastructure. This change is documentation/state recovery, not new design. The existing ~1,250-line implementation is preserved; the proposal only distinguishes what is already complete from the two small pending objectives.

## Scope

### In Scope
- Document the completed Nivel 0.2 infrastructure state.
- Define Objective B: change the Storage healthcheck URL from `http://localhost:5000/status` to `http://127.0.0.1:5000/status`, then run `docker compose config -q`.
- Define Objective C: start the aligned stack, verify all services, record PostgreSQL `system_identifier` and migration state, prove persistence across restart without `-v`, and run `sdd-verify`.

### Out of Scope
- Reimplementing the existing ~1,250 historical lines.
- Editing Docker Compose, SQL, scripts, Kong config, JWT, roles, or .env beyond the one-line healthcheck URL.
- Running Docker, healthchecks, builds, `sdd-apply`, `sdd-verify`, archive, Git commit, or Nivel 1.1 work from this phase.

## Capabilities

### New Capabilities
- `base-infrastructure`: Local Supabase-aligned base stack (Postgres, Auth, REST, Storage, Meta, imgproxy, Kong, Studio) with official bootstrap, healthchecks, and persistence.

### Modified Capabilities
- None.

## Approach

This proposal is a historical artifact. The technical approach was already executed and is recorded in Engram observations #282, #287, #293, #315, #318, #338, and #343. The only remaining code change is the single-line Storage healthcheck URL fix proven in #315. Objectives B and C will be executed only under native workflow authority after this documentation phase completes.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `openspec/changes/nivel-0-2-infraestructura-base/` | New | OpenSpec change artifacts (proposal, future specs/design/tasks/verify). |
| `docker-compose.yml` storage healthcheck | Pending | One-line URL change `localhost` → `127.0.0.1`; no other service edits. |
| Existing volumes | Preserved | `behavioralos-db-data`, `behavioralos-db-data-clean`, `behavioralos-db-data-aligned`, `db-config` must not be deleted. |
| All other infrastructure files | Existing | `.env.example`, `scripts/*`, `volumes/db/*`, `volumes/api/kong.yml` already aligned; no edits. |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Proposal scopes new implementation for already-completed work. | Low | Explicitly label completed state vs pending Objectives B/C; cite historical Engram evidence. |
| Downstream specs/design over-engineer the materialization. | Low | Capabilities section limits scope to one base-infrastructure spec; prohibit reimplementation. |
| Objective B healthcheck fix is expanded beyond the one-line URL. | Low | State exact diff in approach and success criteria. |

## Rollback Plan

- Documentation rollback: remove the OpenSpec change folder and invalidate the Engram `sdd/nivel-0-2-infraestructura-base/proposal` artifact.
- Implementation rollback (if Objective B is applied): revert the single Storage healthcheck URL line to `http://localhost:5000/status` and re-run `docker compose config -q`.
- No volume or data rollback is required because existing state is preserved, not recreated.

## Dependencies

- Maintainer authorization for Objective A already granted (#343).
- Historical implementation and volumes preserved (#338).
- Native workflow recovery before Objectives B and C can execute (#338).

## Success Criteria

- [ ] `proposal.md` exists at `openspec/changes/nivel-0-2-infraestructura-base/proposal.md`.
- [ ] Engram artifact persisted under `sdd/nivel-0-2-infraestructura-base/proposal` in project `behavioros`.
- [ ] Completed state and pending Objectives B/C are clearly separated.
- [ ] No requirements are introduced that reimplement the existing ~1,250-line implementation.
