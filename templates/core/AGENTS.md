# AGENTS.md

## Read order
1. This file (`AGENTS.md`)
2. The assigned task in `TASKS.yaml`
3. The task plan in `plans/<TASK-ID>.md` (if present)
4. `docs/architecture.md`

## Precedence
1. Safety boundaries and "ask first" rules
2. Existing code, tests, and contracts define current behavior
3. `SPEC.md` and the assigned task in `TASKS.yaml` define intended behavior
4. The task plan defines the task-local approach
5. This file defines workflow, verification rules, and boundaries
6. Stale docs lose to code and tests

## Assigned-task lifecycle
1. Read this file.
2. Read the assigned task in `TASKS.yaml`.
3. Read the task plan if present.
4. Read `docs/architecture.md`.
5. Check default-branch `TASKS.yaml` for any `in_progress` task whose `files:` globs overlap the assigned task.
6. If overlap exists, stop, set the task to `blocked`, and report the conflict in `.agents/reports/<TASK-ID>.md`.
7. Create branch `task/<TASK-ID>-<slug>` and set the task to `in_progress`.
8. Implement, run targeted verification, and update `.agents/reports/<TASK-ID>.md`.
9. Rebase on the default branch, rerun verification, and recheck overlap before `done`.
10. Mark `done` only if verification passes.

## Retry budget
After 3 identical verification failures on the same error, set the task to `blocked`, record the failure in the report, and stop.

## Escalation
Stop and flag (do not proceed) when:
- You hit any item in the "Ask first" list below.
- File overlap or rebase conflict cannot be resolved cleanly.
- A dependency is missing or broken in a way you cannot fix within task scope.

## Task decomposition
- Only decompose the assigned task.
- Create child tasks in `TASKS.yaml` with `parent: <TASK-ID>` when decomposition is needed.
- Keep child tasks inside the parent's declared scope and acceptance envelope.

## Coordination constraint
Repo-only git state is advisory conflict avoidance, not a hard distributed lock.

## Command surface guidance
Point these at your project's existing tools rather than inventing new ones:
- bootstrap: `<your bootstrap command>`
- lint: `<your lint command>`
- typecheck: `<your typecheck command>`
- test: `<your test command>`
- test (targeted): `<your targeted test command>`
- verify (full): `<your full verification command>`

## Testing rules
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
- Plans directory: `plans/`
- Report template: `.agents/reports/TEMPLATE.md`
