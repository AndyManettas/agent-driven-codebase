# Philosophy

## Core principles

### Durable knowledge over live chatter
Put stable product truth, task truth, and handoff state in repo files.
Do not rely on ephemeral chat history, scratchpads, or runtime heartbeats.

### One source of truth per concern
- `SPEC.md` owns product truth.
- `TASKS.yaml` owns task truth.
- `AGENTS.md` owns the operating contract.
- The repo's existing commands own verification.

### Stable command surfaces
Point agents at commands the repo already trusts.
Do not create a new command layer unless the repo lacks one.

### Progressive disclosure
Start with `AGENTS.md`, then load only the assigned task, task plan, and architecture context needed for the run.

### No shared mutable scratchpads in git
Plans, reports, and architecture docs are durable artifacts.
Ad hoc scratch state, leases, and heartbeats are not part of v1.

## Boundaries

- No external coordinator.
- No leases or heartbeats.
- No autonomous task picking.
- No default overwriting of existing root files or command surfaces.

## Coordination model

Task overlap checks in `TASKS.yaml` are advisory conflict avoidance only.
Repo-only git state is not a hard distributed lock.
