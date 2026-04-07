# File rationale

## Core files

### `AGENTS.md`
What it does: defines read order, precedence, task lifecycle, command guidance, testing rules, git workflow, and boundaries.
When to customize: always.
Failure mode: duplicating product truth or architecture detail that belongs elsewhere.

### `SPEC.md`
What it does: records the product's goals, requirements, constraints, and definition of done.
When to customize: always.
Failure mode: turning it into an implementation notebook instead of product truth.

### `TASKS.yaml`
What it does: acts as the canonical task registry with status, scope, acceptance, and verify commands.
When to customize: always.
Failure mode: missing `files:` globs or marking `done` before verification passes.

### `plans/TEMPLATE.md`
What it does: gives a repeatable format for task-local implementation plans.
When to customize: copy it to create a task-specific plan when a task is non-trivial.
Failure mode: letting the template path linger after the task needs a real plan.

### `docs/architecture.md`
What it does: records the system map, module boundaries, and where changes belong.
When to customize: always.
Failure mode: stale architecture notes that disagree with code and tests.

### `.agents/manifest.yaml`
What it does: provides a discovery index for entrypoints, task registry, plans, reports, and optional skills.
When to customize: when you add optional directories such as `skills/`.
Failure mode: putting policy or mutable state into the manifest.

### `.agents/reports/TEMPLATE.md`
What it does: provides the append-only handoff format for long-running or resumed work.
When to customize: copy it to create task-specific reports when needed.
Failure mode: overwriting earlier entries instead of appending.

## Optional modules

### `scripts/`
Use when the repo does not already expose a stable command surface.

### `examples/`
Use when adopters need canonical code-pattern examples rather than only prose guidance.

### `adr/`
Use when the repo benefits from durable architectural decision records.

### `local-agents/`
Use in monorepos that need local `AGENTS.md` files in subtrees.

### `skills/`
Use when the repo wants repeatable, repo-local workflows expressed as skills.

### `ci/`
Use when the repo lacks a CI workflow that already calls its verify entrypoint.

### `mcp/`
Use when the repo needs a starter `.mcp.json` for external adapters.

### `status/`
Use when the repo wants a durable macro snapshot beyond task-level reporting.

### `greenfield-root-files/`
Use only for brand-new repos that need starter root files such as `.gitignore`, `.editorconfig`, `.env.example`, and `CODEOWNERS`.
