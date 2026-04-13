---
name: task-start
description: Claim an assigned task, load the required repo context, and create any task-local artifacts needed before substantial implementation begins.
---

# Task start

## When to use
- The agent is starting an assigned task.
- A paused task is being resumed in a new session.

## Read first
- `AGENTS.md`
- `.agents/manifest.yaml`
- The assigned task in `TASKS.yaml`
- The task plan named by the task's `plan` field, if it is task-local
- The latest entry in the task report named by the task's `report` field, if it is task-local
- `docs/architecture.md`
- `SPEC.md` when the task needs product context beyond the task entry or may change product truth

## Actions
1. Confirm the task scope, dependencies, file globs, acceptance criteria, and verify commands.
2. Check default-branch `TASKS.yaml` for any `in_progress` task whose `files:` globs overlap the assigned task.
3. If overlap exists, stop, set the task to `blocked`, and record the conflict in the task report.
4. Create branch `task/<TASK-ID>-<slug>` and set the task to `in_progress` only after the task is actually claimed.
5. Create a task-local report if the task still points at `.agents/reports/TEMPLATE.md`.
6. Create a task-local plan if the task is non-trivial and still points at `plans/TEMPLATE.md`.
7. Append a report entry with starting assumptions, current blockers, and the next best step before substantial implementation begins.

## Update surfaces
- `TASKS.yaml` for status and task-local artifact paths
- `.agents/reports/<TASK-ID>.md` for the session handoff
- `plans/<TASK-ID>.md` when the task needs a real plan
- `STATUS.md` only if the repo uses it and the task changes the current milestone picture

## Output
The task is either claimed with task-local repo state in place or blocked with the reason recorded durably.
