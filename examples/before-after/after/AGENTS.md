# AGENTS.md

## Read order
1. This file
2. The assigned task in `TASKS.yaml`
3. The task plan in `plans/<TASK-ID>.md` (if present)
4. `docs/architecture.md`

## Precedence
1. Safety boundaries
2. Tests and contracts define current behavior
3. `SPEC.md` + `TASKS.yaml` define intended behavior
4. Task plan defines approach
5. This file defines workflow
6. Stale docs lose to code and tests

## Assigned-task lifecycle
1. Read this file.
2. Read the assigned task in `TASKS.yaml`.
3. Read the task plan if present.
4. Read `docs/architecture.md`.
5. Check default-branch `TASKS.yaml` for overlapping `in_progress` `files:` globs.
6. If overlap exists, stop, set the task to `blocked`, and report the conflict.
7. Create branch `task/<TASK-ID>-<slug>` and set the task to `in_progress`.
8. Implement, run targeted verification, and update `.agents/reports/<TASK-ID>.md`.
9. Before done: rebase, rerun verification, and recheck overlap.
10. Mark `done` only if verification passes.

## Retry budget
After 3 identical failures, mark `blocked` and stop.

## Escalation
Stop on "Ask first" boundaries or unresolved conflicts.

## Task decomposition
- Only decompose the assigned task.
- Use `parent:` on child tasks when needed.

## Coordination constraint
Repo-only git state is advisory conflict avoidance, not a hard distributed lock.

## Commands
- lint: `npm run lint`
- test: `npm test`
- verify: `npm run lint && npm test`

## Testing
- Behavior changes require tests.
- Run full verification before marking done.

## Code style
- Small functions, explicit inputs/outputs.
- Follow existing patterns.

## Git workflow
- Branch: `task/<TASK-ID>-<slug>`
- Commit: `<TASK-ID>: imperative summary`

## Boundaries

### Always do
- Follow existing patterns.
- Add tests for behavior changes.

### Ask first
- Database schema changes
- Public API changes
- Dependency changes

### Never do
- Commit secrets.
- Skip tests.
- Mark done without verification.

## Pointers
- Spec: `SPEC.md`
- Tasks: `TASKS.yaml`
- Architecture: `docs/architecture.md`
- Plans: `plans/`
- Report template: `.agents/reports/TEMPLATE.md`
