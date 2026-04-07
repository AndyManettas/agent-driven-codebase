# Getting started

## Exact v1 adoption flow

1. Copy `templates/core/` into the target repo root.
2. Replace the placeholder content in `SPEC.md`.
3. Replace the placeholder content in `TASKS.yaml`.
4. Write `docs/architecture.md`.
5. Point `AGENTS.md` at the repo's existing commands.
6. Add optional modules only where needed.

## Copy command

```bash
cp -R templates/core/. /path/to/target-repo/
```

## First pass customization

- Replace the placeholder product summary, goals, requirements, and constraints in `SPEC.md`.
- Replace the placeholder tasks in `TASKS.yaml` with real task entries.
- Keep `plans/TEMPLATE.md` and `.agents/reports/TEMPLATE.md` as reusable starting points.
- Update the Commands section of `AGENTS.md` so agents call the repo's real lint, test, typecheck, and verify commands.

## First agent prompt

> Work on task PROJ-001. Read AGENTS.md first for the operating rules.

## Optional modules

Only add modules from `templates/optional/` when the base core is not enough for the repo you are adopting into.
