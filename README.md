# Agent-Driven Codebase

A lean, additive template that teams copy into an existing codebase so human-triggered cloud agents have durable repo-native context during long runs.

## What ships

This repo now ships four things only:

- [`templates/core/`](templates/core/) — the canonical 11-file v1 contract
- [`docs/how-it-works.md`](docs/how-it-works.md) — the only deep explainer
- [`examples/minimal-repo/`](examples/minimal-repo/) — one worked overlay example
- [`templates/extensions/`](templates/extensions/) — two small extensions for concrete gaps

The template is not the harness.
Cursor, Codex, or another runtime handles context windows, liveness, and run lifecycle.
This repo only provides the durable repo-native surfaces those harnesses should read.

## The core contract

Copy [`templates/core/`](templates/core/) into the target repo root.
That is the whole canonical v1 structure:

```text
AGENTS.md
SPEC.md
TASKS.yaml
plans/TEMPLATE.md
docs/architecture.md
.agents/manifest.yaml
.agents/reports/TEMPLATE.md
skills/task-start/SKILL.md
skills/task-progress/SKILL.md
skills/task-closeout/SKILL.md
skills/task-decompose/SKILL.md
```

`AGENTS.md` stays thin.
The lifecycle lives in the four mandatory core skills and is loaded only when relevant to the current task phase.

## Adopt into an existing repo

1. Copy `templates/core/` into the target repo root.
2. Replace the placeholder product truth in `SPEC.md`.
3. Replace the placeholder tasks in `TASKS.yaml`.
4. Write `docs/architecture.md`.
5. Point `AGENTS.md` at the repo's existing commands.
6. Keep the mandatory core skills intact.
7. Add an extension only if the repo has a concrete gap it solves.

Collision-avoidance rules:

- Do not overwrite an existing root `README.md`.
- Do not replace existing CI, scripts, or contribution files by default.
- Do not introduce wrapper scripts if the repo already has stable commands.
- Do not add extra repo surfaces just because the template can support them.

## Prompt an agent

Use a thin task assignment prompt:

```text
Work on task PROJ-001.
Read AGENTS.md first for the repo operating rules.
Then load the lifecycle skill for the current phase.
```

If you use platform-specific adapter files such as Cursor rules, keep them thin and point them back to `AGENTS.md` instead of duplicating policy.

## Before and after

Before adoption, a typical repo has code and tests but no durable operating contract for long-running agent work:

```text
README.md
src/
tests/
```

After copying the core, the same repo gains durable truth and handoff state without replacing its existing code or commands:

```text
README.md
src/
tests/
AGENTS.md
SPEC.md
TASKS.yaml
plans/TEMPLATE.md
docs/architecture.md
.agents/manifest.yaml
.agents/reports/TEMPLATE.md
skills/
```

## Worked example

[`examples/minimal-repo/`](examples/minimal-repo/) is an overlay example, not a second full repo template.
It shows only the files adopters actually customize after copying `templates/core/`:

- `SPEC.md`
- `TASKS.yaml`
- `docs/architecture.md`
- `plans/API-001-task-crud.md`
- `.agents/reports/API-001.md`

It intentionally omits the bootstrap files, core skills, and reusable templates that already live in `templates/core/`.

## Extensions

[`templates/extensions/`](templates/extensions/) ships only two supported extensions:

- `skills/` for extra repo-specific workflows beyond the core lifecycle
- `local-agents/` for subtree-specific `AGENTS.md` files in monorepos or large repos

Future extensions such as CI, scripts, status files, greenfield root files, or integration config are intentionally not shipped in lean v1.
Add them in your own repo only when the need is concrete.

## Deep explainer

Read [How it works](docs/how-it-works.md) for the operating model, migration guidance, file responsibilities, coordination model, and platform usage notes.

## Schemas and tests

Schemas live in [schemas/](schemas/).
Tests cover the core template, the worked overlay example, schema expectations, docs links, and adoption smoke behavior in [tests/](tests/).
