# AGENTS.md

## Read order
1. This file (`AGENTS.md`)
2. The assigned task in `TASKS.yaml`
3. The task plan in `plans/<TASK-ID>.md` (if present)
4. `docs/architecture.md`
5. Nearest subdirectory `AGENTS.md` (if present)
6. `examples/` (if present)

## Precedence
1. Safety boundaries
2. Tests, schemas, and contracts define current behavior
3. `SPEC.md` + `TASKS.yaml` define intended behavior
4. The task plan defines task-local approach
5. This file defines workflow and style
6. Examples show preferred implementation patterns
7. Stale docs lose to code and tests

## Assigned-task lifecycle
1. Read this file.
2. Read the assigned task in `TASKS.yaml`.
3. Check default-branch `TASKS.yaml` for any `in_progress` task whose `files:` globs overlap the assigned task. If overlap exists, stop and report the conflict.
4. Read the task plan if present.
5. Read `docs/architecture.md`.
6. Create branch `task/<TASK-ID>-<slug>` and set the task to `in_progress` in `TASKS.yaml`.
7. Implement with targeted tests first, then run full verification.
8. Before marking `done`: rebase on the default branch, rerun verification.
9. If rebase conflicts touch files outside the task's declared `files:`, stop and flag the conflict rather than resolving it.
10. Update `.agents/reports/<TASK-ID>.md` with completed work, remaining items, and next steps.
11. Update task status in `TASKS.yaml` to `done` only if verification passes.

## Retry budget
After 3 identical verification failures on the same error, mark the task `blocked` with the reason in the report. Move on.

## Escalation
Stop and flag (do not proceed) when:
- You hit any item in the "Ask first" list below.
- File-overlap conflict cannot be resolved.
- A dependency is missing or broken in a way you cannot fix within task scope.

## Commands
Point these at your project's existing tools:
- bootstrap: `<your bootstrap command>`
- lint: `<your lint command>`
- typecheck: `<your typecheck command>`
- test: `<your test command>`
- test (targeted): `<your test command> <path>`
- verify (full): `<your full verification command>`

## Testing
- Any behavior change requires tests.
- Run targeted tests during iteration.
- Run full verification before marking a task `done`.
- Do not mark a task `done` until verification passes.

## Code style
- Prefer small functions with explicit inputs and outputs.
- Prefer existing local patterns over generic framework patterns.
- Avoid hidden global state.
- Add types and schemas at boundaries.

## Git workflow
- Branch: `task/<TASK-ID>-<slug>`
- Commit: `<TASK-ID>: imperative summary`
- Keep commits scoped to the task.
- On pause or finish, update the task report in `.agents/reports/`.

## Boundaries

### Always do
- Follow local patterns from nearby code and `examples/`.
- Add or update tests for any behavior change.
- Preserve backward compatibility unless the task says otherwise.
- Record non-obvious decisions in the task report.

### Ask first
- Database schema changes
- Public API changes
- Auth or permission changes
- Dependency additions or removals
- Deleting large modules
- Infrastructure or cost changes

### Never do
- Commit secrets or credentials.
- Skip tests to make verification pass.
- Mark work done without passing verification.
- Rewrite unrelated code "while here."

## Pointers
- Product spec: `SPEC.md`
- Task registry: `TASKS.yaml`
- Architecture: `docs/architecture.md`
- Plan template: `plans/TEMPLATE.md`
- Report template: `.agents/reports/TEMPLATE.md`
