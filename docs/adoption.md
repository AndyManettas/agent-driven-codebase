# Adoption

## Quick start (5 minutes)

1. Copy `templates/core/` into your repo root:
   ```bash
   cp -r templates/core/* /path/to/your/repo/
   cp -r templates/core/.agents /path/to/your/repo/
   ```

2. Fill in `SPEC.md` with your product description, goals, and requirements.

3. Replace the example tasks in `TASKS.yaml` with your real tasks.

4. Fill in `docs/architecture.md` with your system's modules, data flow, and boundaries.

5. Edit the Commands section of `AGENTS.md` to point at your repo's existing test, lint, and build commands.

That's it. The core template is now in place.

## Adding your first real task

In `TASKS.yaml`, add a task entry:

```yaml
  - id: PROJ-001
    title: Short description of the task
    status: ready
    priority: P1
    size: M
    area: relevant-area
    deps: []
    plan: plans/PROJ-001-short-slug.md
    report: .agents/reports/PROJ-001.md
    files:
      - src/relevant-area/**
      - tests/relevant-area/**
    acceptance:
      - First acceptance criterion.
      - Second acceptance criterion.
    verify:
      - npm test -- relevant-area
      - npm run verify
```

Optionally, write a plan at `plans/PROJ-001-short-slug.md` using the template in `plans/TEMPLATE.md`.

## Triggering an agent

Prompt your cloud agent (Cursor, Codex, etc.) with the task ID:

> Work on task PROJ-001. Read AGENTS.md first for the operating rules.

The agent will follow the lifecycle defined in AGENTS.md: read the task, check for conflicts, create a branch, implement, verify, update the report, and mark the task done.

## Adding optional modules

Only add these when you need them:

| Module | When to add |
|--------|-------------|
| `scripts/` | Your repo lacks a stable lint/test/verify command surface |
| `examples/` | Agents need canonical code patterns to follow |
| `adr/` | You're making non-obvious architectural decisions worth recording |
| `local-agents-md/` | You have a monorepo with distinct subdomain boundaries |
| `STATUS.md` | You want a durable macro project health snapshot |
| `ci.yml` | Your repo lacks an existing CI workflow |
| `.editorconfig` / `.env.example` / `CODEOWNERS` | Greenfield repo or you explicitly want these |

Copy the relevant files from `templates/optional/` into your repo.

## Incremental adoption

You don't need everything at once. The minimum viable setup is:

1. `AGENTS.md` + `TASKS.yaml` — gives agents an operating contract and task list.
2. Add `SPEC.md` when you want agents to understand the full product context.
3. Add `docs/architecture.md` when agents need to understand system boundaries.
4. Add plans and reports when tasks are complex enough to need pre-approved approaches and durable handoff.
