---
schema: gentle-ai.sdd-preproposal/v1
revision: 2
change: nivel-1-2-backend-minimo
---

# Pre-Proposal State: Nivel 1.2 — Backend mínimo

## Exploration

- Reference: `openspec/changes/nivel-1-2-backend-minimo/exploration.md`
- Outcome: exploration complete; identifies the minimum backend slice, integration boundaries with Nivel 1.1, and open product/technical decisions.

## Research Request

- Selected: yes
- Requested source classes: `documentation`, `open-web`

## Admission and Outcome

- Admission: **granted** — `documentation=[context7]`, `open-web=[webfetch, websearch]`.
- Outcome: **done**

## Evidence References

- OpenSpec research: `openspec/changes/nivel-1-2-backend-minimo/research.md` (revision 2, outcome `done`)
- Engram research: none (OpenSpec-only store; no Engram topic was written for SDD artifacts)

## Product Decisions

- Status: **confirmed**

1. First exercise: guided mindfulness breathing; minimal telemetry includes duration, completion, pauses, and retries.
2. Auth: signup/login/refresh/logout remain direct to GoTrue.
3. FastAPI validates JWT and exposes `/api/v1/auth/me`, identity/profile, and exercise backend behavior.
4. Artifact store: OpenSpec, authoritative from native status.

## proposal_ready

true
