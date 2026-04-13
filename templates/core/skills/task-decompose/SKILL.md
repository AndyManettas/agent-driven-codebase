---
name: task-decompose
description: Split a task into child tasks without losing scope control, file ownership clarity, or durable handoff context.
---

# Task decompose

## When to use
- The assigned task is too large for one coherent implementation pass.
- Distinct sub-problems can be worked independently inside the parent scope.
- Newly discovered work should be tracked explicitly instead of absorbed silently.

## Read first
- `AGENTS.md`
- `.agents/manifest.yaml`
- The parent task entry in `TASKS.yaml`
- The parent task plan and latest report
- `docs/architecture.md` for module boundaries

## Actions
1. Keep decomposition inside the parent's acceptance envelope and declared file scope.
2. Add child tasks in `TASKS.yaml` with `parent: <TASK-ID>`, concrete acceptance criteria, file globs, and verify commands.
3. Narrow each child task to a cleanly owned slice of the work.
4. Update the parent plan or report so the reason for decomposition is explicit.
5. If the parent cannot continue until a child finishes, reflect that dependency in task state instead of relying on memory.

## Update surfaces
- `TASKS.yaml`
- `plans/<TASK-ID>.md` when the parent approach changed
- `.agents/reports/<TASK-ID>.md`
- `.agents/reports/<CHILD-TASK-ID>.md` when the child is immediately claimed

## Output
The work is split into explicit, trackable child tasks with durable reasoning about why the decomposition happened and what should happen next.
