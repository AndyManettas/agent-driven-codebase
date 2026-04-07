# How it works

## The assignment flow

```
Human                          Repo                           Agent
  │                             │                               │
  ├── adds task to TASKS.yaml ──►                               │
  ├── writes plan (optional) ───►                               │
  ├── triggers agent run ───────────────────────────────────────►│
  │                             │                               │
  │                             ◄── reads AGENTS.md ────────────┤
  │                             ◄── reads assigned task ────────┤
  │                             ◄── reads plan ─────────────────┤
  │                             ◄── reads architecture.md ──────┤
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
  │                             ◄── updates report ─────────────┤
  │                             ◄── rebases / rechecks overlap ─┤
  │                             ◄── sets status: done ──────────┤
  │                             │                               │
```

## What each file does during a run

**AGENTS.md** is the first thing the agent reads. It tells the agent the read order, lifecycle steps, command surface, style rules, and boundaries. This is the operating contract.

**TASKS.yaml** tells the agent what work exists. The agent reads its assigned task entry to understand the acceptance criteria, which files are in scope, what dependencies exist, and what verification commands to run. The `files:` field is also used for overlap detection when multiple agents work concurrently.

**plans/\<TASK-ID\>.md** (optional) gives the agent a pre-approved implementation approach. Without a task-specific plan, the agent starts from `plans/TEMPLATE.md`. Plans reduce drift and make long tasks more predictable.

**docs/architecture.md** gives the agent a system map so it understands module boundaries, data flow, external dependencies, and where to add new code.

**.agents/manifest.yaml** is a discovery index. It tells the agent where to find the entrypoints, task registry, plans directory, and reports directory without guessing.

**.agents/reports/\<TASK-ID\>.md** is the handoff surface. At the end of a session (or during a long session), the agent appends a dated entry describing what was completed, what remains, what commands were run, what results were observed, and what the next session should do first.

## How reports enable continuity

Reports are append-only. Each entry is a snapshot of a session's state. When a new agent session picks up a task, it reads the latest report entry to understand:
- What has already been done (avoid redoing work).
- What was tried and failed (avoid repeating mistakes).
- What the previous session recommended as the next step.

This is how context survives across sessions without the agent needing memory of prior runs.

## How multiple agents avoid conflicts

When multiple agents work on different tasks concurrently:
1. Each task declares its `files:` globs in TASKS.yaml.
2. Before starting, an agent checks whether any `in_progress` task has overlapping file globs.
3. If overlap exists, the agent stops, marks the task blocked, and reports the conflict instead of proceeding.
4. Before marking done, the agent rebases on the default branch and rechecks for conflicts.

This is advisory — it prevents the most common collision (two agents editing the same files) but does not guarantee atomicity.
