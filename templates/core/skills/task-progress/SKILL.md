---
name: task-progress
description: Update durable repo state at meaningful milestones during long-running work without turning reports, plans, or docs into noisy churn.
---

# Task progress

## When to use
- A meaningful implementation milestone was completed.
- The agent is handing off or pausing mid-task.
- The approach, scope, or system understanding changed materially.

## Read first
- `AGENTS.md`
- `.agents/manifest.yaml`
- The assigned task in `TASKS.yaml`
- The current task plan and latest task report entry
- `docs/architecture.md`
- `SPEC.md` only if the change may alter product truth

## Actions
1. Compare the current code and test changes against the task acceptance criteria.
2. Update the task report with completed work, remaining work, files changed, commands run, results, blockers, and the next best step.
3. Update the task plan only if the approach, sequencing, or risk picture changed materially.
4. Update `docs/architecture.md` only if module boundaries, data flow, external dependencies, or extension points changed.
5. Update `SPEC.md` only if product intent, requirements, constraints, or definition of done changed.
6. Update `STATUS.md` only if the repo adopted it and the milestone picture changed materially.
7. If newly discovered work falls outside task scope, create child tasks instead of silently expanding the parent task.
8. Do not churn durable repo files when nothing material changed.

## Update surfaces
- `.agents/reports/<TASK-ID>.md`
- `plans/<TASK-ID>.md` when the approach changed
- `docs/architecture.md` when system truth changed
- `SPEC.md` when product truth changed
- `STATUS.md` when macro status changed
- `TASKS.yaml` when blocking state or decomposition changed

## Output
Durable repo state reflects the current reality of the task without depending on chat history or rewriting files that did not materially change.
