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
3. Check for file overlap with any `in_progress` task. Stop if overlap exists.
4. Read the task plan if present.
5. Read `docs/architecture.md`.
6. Create branch `task/<TASK-ID>-<slug>`, set task to `in_progress`.
7. Implement and verify.
8. Before done: rebase, rerun verification.
9. If conflicts touch files outside task scope, stop and flag.
10. Update `.agents/reports/<TASK-ID>.md`.
11. Mark `done` only if verification passes.

## Retry budget
After 3 identical failures, mark `blocked`.

## Escalation
Stop on "Ask first" boundaries or unresolved conflicts.

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
