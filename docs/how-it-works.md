# How it works

## Core principles

### Durable knowledge over live chatter

Put stable product truth, task truth, and handoff state in repo files.
Do not rely on ephemeral chat history, scratchpads, or runtime heartbeats.

### One source of truth per concern

- `SPEC.md` owns product truth.
- `TASKS.yaml` owns task truth.
- `AGENTS.md` owns bootstrap rules, safety boundaries, and command surfaces.
- Core lifecycle skills own task-phase workflow.
- The repo's existing commands own verification.

### One canonical structure

Adopt the core first.
Do not present multiple peer repo shapes or alternate starting layouts.

### Progressive disclosure

Start with `AGENTS.md`, then `.agents/manifest.yaml`, then the assigned task, then the lifecycle skill for the current phase, then only the extra files that skill or task actually requires.

### Semantic repo state is authored, not generated

Use agents to update plans, reports, architecture notes, and similar durable state because those surfaces require judgment.
Use checks only to catch drift or missing required artifacts.

### No shared mutable scratchpads in git

Plans, reports, and architecture notes are durable artifacts.
Ad hoc leases, heartbeats, and chat-like scratch state are not part of v1.

## Boundaries

- No external coordinator.
- No leases or heartbeats.
- No autonomous task picking.
- No default overwriting of existing root files or command surfaces.
- No wrapper command layer unless the repo lacks a stable one already.

## Safe adoption into an existing repo

Use this sequence:

1. Copy `templates/core/` into the repo root.
2. Leave the repo's existing `README.md`, CI, scripts, and contribution files alone by default.
3. Replace the placeholder content in `SPEC.md`, `TASKS.yaml`, and `docs/architecture.md`.
4. Point `AGENTS.md` at the repo's existing bootstrap, lint, typecheck, test, and verify commands.
5. Run one small human-assigned task through the flow before adding any repo-specific extras.

Avoid these migration mistakes:

- Copying extensions by default
- Treating extensions as a second repo shape
- Duplicating operating rules into platform-specific files
- Leaving placeholder tasks in `TASKS.yaml`
- Treating repo git state as a hard distributed lock

## The assignment flow

```text
Human                          Repo                           Agent
  │                             │                               │
  ├── adds task to TASKS.yaml ──►                               │
  ├── writes plan (optional) ───►                               │
  ├── triggers agent run ───────────────────────────────────────►│
  │                             │                               │
  │                             ◄── reads AGENTS.md ────────────┤
  │                             ◄── reads manifest ─────────────┤
  │                             ◄── reads assigned task ────────┤
  │                             ◄── loads task-start skill ─────┤
  │                             ◄── checks for file overlap ────┤
  │                             │                               │
  │                             ◄── creates task branch ────────┤
  │                             ◄── sets status: in_progress ───┤
  │                             │                               │
  │                             │    ┌─ implement ──────────────┤
  │                             │    │  write tests             │
  │                             │    │  run verification        │
  │                             │    │  rebase on default       │
  │                             │    └─ rerun verification      │
  │                             │                               │
  │                             ◄── loads progress skill ───────┤
  │                             ◄── updates report ─────────────┤
  │                             ◄── rebases / rechecks overlap ─┤
  │                             ◄── loads closeout skill ───────┤
  │                             ◄── sets status: done ──────────┤
  │                             │                               │
```

## What each core file does

### `AGENTS.md`

Bootstrap contract.
It defines read order, precedence, command guidance, testing rules, git workflow, and safety boundaries.
Failure mode: turning it into one large workflow file instead of a thin entrypoint.

### `SPEC.md`

Product truth.
It records goals, requirements, constraints, and definition of done.
Failure mode: turning it into an implementation notebook.

### `TASKS.yaml`

Task truth.
It declares status, scope, acceptance criteria, verification commands, and file ownership hints.
Failure mode: stale tasks, missing `files:` globs, or marking `done` before verification passes.

### `plans/<TASK-ID>.md`

Optional task-local implementation plan.
Without a task-specific plan, the agent starts from `plans/TEMPLATE.md`.
Failure mode: keeping the template path when the task needs a real plan.

### `docs/architecture.md`

System map.
It records module boundaries, data flow, external dependencies, and where new code belongs.
Failure mode: architecture notes drifting from the code.

### `.agents/manifest.yaml`

Discovery index.
It tells the agent where to find the entrypoints, task registry, plans directory, reports directory, and skills directory without guessing.
Failure mode: putting policy or mutable state into the manifest.

### `skills/`

Mandatory lifecycle skills.
They define task start, progress updates, closeout, and decomposition.
Failure mode: making lifecycle optional or moving repo-specific behavior into the core lifecycle.

### `.agents/reports/<TASK-ID>.md`

Append-only handoff surface.
Each entry captures what changed, what remains, what was verified, and what the next session should do first.
Failure mode: rewriting history instead of appending new session entries.

## How continuity works

Reports are how work survives across sessions.
When a new session picks up a task, it reads the latest report entry to avoid redoing work, avoid repeating failed approaches, and understand the best next step.

This is enough continuity for v1 without inventing coordinators or persistent chat memory.

## How semantic files stay current

The core lifecycle skills define when to claim work, create task-local plans and reports, update semantic docs at meaningful milestones, decompose oversized tasks, and close work out honestly.

Additional repo-local skills are for extra workflows only.
They must not replace the core lifecycle or expand task scope.

## Optional extensions shipped in lean v1

Only two extensions are shipped:

- `templates/extensions/skills/` for extra repo-specific workflows such as release checklists or review follow-up
- `templates/extensions/local-agents/` for subtree-specific `AGENTS.md` files in monorepos or very large repos

The lean v1 repo intentionally does not ship placeholder CI, scripts, ADRs, greenfield root files, status files, or external integration config.

## Platform usage

Cursor and Codex should both be pointed at `AGENTS.md` as the entrypoint.
Keep any platform-specific adapter files thin and derived from it.

Example prompt:

```text
Work on task PROJ-001.
Read AGENTS.md first for the full operating contract.
Read the assigned task in TASKS.yaml.
Load the lifecycle skill for the current phase from skills/.
```

## Coordination model

Task overlap checks in `TASKS.yaml` are advisory conflict avoidance only.
Before starting, an agent checks whether any `in_progress` task has overlapping `files:` globs.
If overlap exists, the agent stops, records the conflict, and does not proceed.

This avoids the most common collision, but it is not a hard distributed lock.
