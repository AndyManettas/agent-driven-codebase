# AGENTS.md

## Read order
1. This file (`AGENTS.md`)
2. The assigned task in `TASKS.yaml`
3. The task plan in `plans/<TASK-ID>.md` (if present)
4. `docs/architecture.md`

## Precedence
1. Safety boundaries
2. Tests, schemas, and contracts define current behavior
3. `SPEC.md` and the assigned task in `TASKS.yaml` define intended behavior
4. The task plan defines task-local approach
5. This file defines workflow and style
6. Stale docs lose to code and tests

## Assigned-task lifecycle
1. Read this file.
2. Read the assigned task in `TASKS.yaml`.
3. Read the task plan if present.
4. Read `docs/architecture.md`.
5. Check default-branch `TASKS.yaml` for any `in_progress` task whose `files:` globs overlap the assigned task.
6. If overlap exists, stop, set the task to `blocked`, and report the conflict.
7. Create branch `task/<TASK-ID>-<slug>` and set the task to `in_progress` in `TASKS.yaml`.
8. Implement, run targeted verification, and update `.agents/reports/<TASK-ID>.md`.
9. Before marking `done`, rebase on the default branch, rerun verification, and recheck overlap.
10. Update task status in `TASKS.yaml` to `done` only if verification passes.

## Retry budget
After 3 identical verification failures, mark the task `blocked`, write the reason in the report, and stop.

## Escalation
Stop on any "Ask first" boundary or unresolved file-overlap conflict.

## Task decomposition
- Only decompose the assigned task.
- Use `parent:` on child tasks when decomposition is needed.

## Coordination constraint
Repo-only git state is advisory conflict avoidance, not a hard distributed lock.

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
- Plans: `plans/`
- Report template: `.agents/reports/TEMPLATE.md`
