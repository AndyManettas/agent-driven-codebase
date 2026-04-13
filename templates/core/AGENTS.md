# AGENTS.md

## Purpose
Read this file first.
It is the bootstrap contract for the repo: it defines safety boundaries, command surfaces, precedence, and which core skills to load for each task phase.

## Read order
1. This file (`AGENTS.md`)
2. `.agents/manifest.yaml`
3. The assigned task in `TASKS.yaml`
4. The core lifecycle skill for the current phase from `skills/`
5. Only then read additional files requested by the active skill or the assigned task

## Precedence
1. Safety boundaries and "ask first" rules
2. Existing code, tests, and contracts define current behavior
3. `SPEC.md` and the assigned task in `TASKS.yaml` define intended behavior
4. Active core lifecycle skills define the baseline workflow
5. Additional repo-local skills may refine extra repo-specific workflows without expanding task scope or replacing the core lifecycle
6. This file defines bootstrap rules, verification rules, and boundaries
7. Stale docs lose to code and tests

## Required core skills
- Task start or resume: `skills/task-start/SKILL.md`
- Meaningful milestone, pause, or handoff: `skills/task-progress/SKILL.md`
- Final status change or review-ready handoff: `skills/task-closeout/SKILL.md`
- Task split into child tasks: `skills/task-decompose/SKILL.md`

## Coordination constraint
Repo-only git state is advisory conflict avoidance, not a hard distributed lock.

## Repo-local skills
- `skills_dir` contains the mandatory core lifecycle skills plus any extra repo-specific skills the repo adds later.
- Core lifecycle skills are always in force.
- Additional repo-local skills may add task-scoped workflow such as release checklists or review follow-up.
- Extra skills must not replace the core lifecycle, expand task scope, or create a second operating contract.

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

## Safety boundaries

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
- Manifest: `.agents/manifest.yaml`
- Product spec: `SPEC.md`
- Task registry: `TASKS.yaml`
- Architecture: `docs/architecture.md`
- Plans directory: `plans/`
- Report template: `.agents/reports/TEMPLATE.md`
- Skills directory: `skills/`
