# Agent-Driven Codebase

A lean, additive template that teams copy into an existing codebase so human-triggered cloud agents have durable repo-native context during long runs.

## What this repo is

This repo ships a narrow v1 template for Cursor or Codex style agents.
The template is additive-first: it gives the repo durable truth about the product, the assigned task, how to work, and how to leave handoff state.

## What problem it solves

Agents can read code, edit files, and run commands, but most repos give them no operating contract, no task registry, no architecture map, and no durable handoff format.
That forces long-running agents to guess, drift, or repeat work across sessions.

## Template vs harness

The template is not the harness.
Cursor, Codex, or another runtime handles context windows, liveness, and run lifecycle.
This repo only provides the durable repo-native surfaces those harnesses should read.

## Minimum serious subset

Copy [`templates/core/`](templates/core/) into the target repo root.
That core is intentionally exactly seven files:

- `AGENTS.md`
- `SPEC.md`
- `TASKS.yaml`
- `plans/TEMPLATE.md`
- `docs/architecture.md`
- `.agents/manifest.yaml`
- `.agents/reports/TEMPLATE.md`

## Optional modules

[`templates/optional/`](templates/optional/) contains self-contained add-ons for repos that need stronger conventions later:

- `scripts/`
- `examples/`
- `adr/`
- `local-agents/`
- `skills/`
- `ci/`
- `mcp/`
- `status/`
- `greenfield-root-files/`

These are not part of the minimum serious setup.

## Adopt the core

1. Copy `templates/core/` into the target repo root.
2. Replace the placeholder product truth in `SPEC.md`.
3. Replace the placeholder tasks in `TASKS.yaml`.
4. Write `docs/architecture.md`.
5. Point `AGENTS.md` at the repo's existing commands.
6. Add optional modules only where needed.

## Docs

- [Philosophy](docs/philosophy.md) — core principles and boundaries
- [Getting started](docs/getting-started.md) — exact v1 adoption flow
- [Migration guide](docs/migration-guide.md) — how to add the template to an existing repo without collisions
- [File rationale](docs/file-rationale.md) — what each file does, when to customize it, and failure modes
- [Cursor and Codex usage](docs/cursor-codex-usage.md) — thin platform-specific prompting guidance
- [How it works](docs/how-it-works.md) — the task flow and handoff model

## Examples

- [Minimal repo](examples/minimal-repo/) — smallest working example with a real spec, tasks, plan, and report
- [Before / after](examples/before-after/) — adoption into a previously unstructured repo

## Schemas and tests

Schemas live in [schemas/](schemas/).
Tests cover the 7-file core, schema expectations, docs links, report headings, and adoption smoke behavior in [tests/](tests/).
