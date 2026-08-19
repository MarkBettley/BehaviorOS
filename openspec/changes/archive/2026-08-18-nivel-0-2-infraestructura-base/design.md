# Design: Nivel 0.2 Base Infrastructure Closure

This design closes the gap between preserved historical implementation and the remaining executable evidence. The Supabase-aligned topology, pinned images, bootstrap assets, database users, health behavior already proven, and named volumes are **completed existing state**. No redesign or recreation of the approximately 1,250 historical implementation lines is included.

## Technical Approach

Use a narrow, evidence-first sequence: confirm the known Storage discrepancy, apply exactly one Compose healthcheck URL correction, validate Compose syntax, then verify the existing stack and persistence. The design maps to the spec's completed requirements and pending Objectives B/C; it creates no new service, schema, migration, credential, mount, or volume.

## State Boundary

| State | Treatment |
|---|---|
| Completed | Snapshot `e2e2fac40ba532142bbb31c04313e25394408ca0`, official SQL/Kong assets, bootstrap order, DB/Auth/Meta/imgproxy health, REST startup, Storage IPv4 response, and preserved volumes. Treat historical evidence as baseline; do not re-audit it. |
| Pending | B1-B3 and C1-C9 only. The only source edit is Storage healthcheck `localhost` → `127.0.0.1`. |

## Architecture Decisions

| Decision | Alternatives considered | Rationale |
|---|---|---|
| Preserve the existing Compose topology and pinned assets | Recreate or normalize the historical implementation | The proposal is state recovery; changing completed infrastructure expands risk and violates scope. |
| Fix only the Storage healthcheck URL | Change Storage binding, add IPv4 wget flags, change image, or alter other healthchecks | Evidence shows Storage serves IPv4 successfully and `localhost` resolves to IPv6 in this runtime. The smallest compatible correction is the specified one-line URL change. |
| Capture migration state before and after restart | Record only post-restart output | Equality requires a baseline. C4 records `supabase migration list --local` before shutdown; C6 compares the post-restart result. |
| Preserve volumes by using restart without `-v` | Reset, prune, recreate, or delete volumes | Persistence is the acceptance criterion and four named volumes are protected evidence. |

## Verification Flow

```text
B1 confirm Storage behavior
  → B2 one-line healthcheck edit
  → B3 docker compose config -q
  → C1 start stack
  → C2 service checks + C3 complete healthchecks
  → C4 capture system_identifier + migration baseline
  → C5 down/up without -v
  → C6 compare persistence + repeat health evidence
  → C7 sdd-verify
  → C8 close Nivel 0.2
  → C9 STOP before Nivel 1.1
```

## File Changes

| File | Action | Description |
|---|---|---|
| `openspec/changes/nivel-0-2-infraestructura-base/design.md` | Create | This technical design artifact. |
| `docker-compose.yml` | Modify later, Objective B only | Replace only the Storage healthcheck URL; no other Compose change. |
| Existing SQL, Kong, scripts, `.env.example`, and volume definitions | No change | Completed historical implementation and protected state. |

## Interfaces / Contracts

- Storage container healthcheck: `http://127.0.0.1:5000/status` must succeed.
- Service acceptance set: `db`, `auth`, `rest`, `storage`, `meta`, `imgproxy`, `kong`, `studio`; each must be healthy or running as applicable.
- Persistence evidence: PostgreSQL `system_identifier` and the exact applied migration listing must match across `docker compose down` (without `-v`) and `docker compose up -d`.
- Closure gate: `sdd-verify` must pass; authorization is required before any Nivel 1.1 work.

## Testing Strategy

No tests or runtime commands are executed in this design phase. The next phase must implement only B1-B3/C1-C9 and collect command output as evidence: Compose config validation, service/container checks, `./scripts/healthcheck.sh`, Storage status, pre/post migration listings, identifier comparison, and final `sdd-verify`. There is no configured unit, integration, or E2E test runner at Nivel 0.2.

## Migration / Rollout

No database migration or data transformation is required. Rollback is limited to reverting the single healthcheck URL and rerunning `docker compose config -q`; never remove or reset the named volumes. If any C-step fails, stop before closure and before Nivel 1.1.

## Open Questions

None. B1 is an evidence confirmation, not permission to broaden the change.
