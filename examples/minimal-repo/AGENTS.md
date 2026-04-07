# AGENTS.md

## Read order
1. This file (`AGENTS.md`)
2. The assigned task in `TASKS.yaml`
3. The task plan in `plans/<TASK-ID>.md` (if present)
4. `docs/architecture.md`

## Precedence
1. Safety boundaries
2. Tests, schemas, and contracts define current behavior
3. `SPEC.md` + `TASKS.yaml` define intended behavior
4. The task plan defines task-local approach
5. This file defines workflow and style
6. Stale docs lose to code and tests

## Assigned-task lifecycle
1. Read this file.
2. Read the assigned task in `TASKS.yaml`.
3. Check default-branch `TASKS.yaml` for any `in_progress` task whose `files:` globs overlap the assigned task. If overlap exists, stop and report the conflict.
4. Read the task plan if present.
5. Read `docs/architecture.md`.
6. Create branch `task/<TASK-ID>-<slug>` and set the task to `in_progress` in `TASKS.yaml`.
7. Implement with targeted tests first, then run full verification.
8. Before marking `done`: rebase on the default branch, rerun verification.
9. If rebase conflicts touch files outside the task's declared `files:`, stop and flag.
10. Update `.agents/reports/<TASK-ID>.md`.
11. Update task status in `TASKS.yaml` to `done` only if verification passes.

## Retry budget
After 3 identical verification failures, mark the task `blocked` with the reason in the report.

## Escalation
Stop on any "Ask first" boundary or unresolved file-overlap conflict.

## Commands
- lint: `npm run lint`
- typecheck: `npm run typecheck`
- test: `npm test`
- test (targeted): `npm test -- --grep`
- verify: `npm run lint && npm run typecheck && npm test`

## Testing
- Any behavior change requires tests.
- Run targeted tests during iteration.
- Run full verification before marking done.

## Code style
- Prefer small functions with explicit inputs and outputs.
- Prefer existing local patterns over framework defaults.
- Avoid hidden global state.
- Add types at boundaries.

## Git workflow
- Branch: `task/<TASK-ID>-<slug>`
- Commit: `<TASK-ID>: imperative summary`

## Boundaries

### Always do
- Follow existing patterns in the codebase.
- Add or update tests.
- Preserve backward compatibility.

### Ask first
- Database schema changes
- Public API changes
- Dependency additions or removals

### Never do
- Commit secrets.
- Skip tests to make CI pass.
- Mark done without verification.

## Pointers
- Spec: `SPEC.md`
- Tasks: `TASKS.yaml`
- Architecture: `docs/architecture.md`
