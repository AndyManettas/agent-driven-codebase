# Agent-Driven Codebase

A lean, additive template that makes any existing codebase legible and steerable for long-running cloud agents (Cursor, Codex, Claude Code).

## The problem

Agents can read code, edit files, and run commands — but most repos give them no operating contract, no structured task list, no architecture context, and no handoff mechanism. The result: agents guess at requirements, drift from the spec, lose context between sessions, and repeat work.

## What this template provides

Drop `templates/core/` into your repo and agents get:

| File | Purpose |
|------|---------|
| `AGENTS.md` | Operating contract: read order, lifecycle, commands, style, boundaries |
| `SPEC.md` | Product truth: goals, requirements, constraints |
| `TASKS.yaml` | Task registry: structured work items with status, priority, acceptance criteria |
| `plans/TEMPLATE.md` | Per-task implementation plans |
| `docs/architecture.md` | System map: modules, data flow, boundaries |
| `.agents/manifest.yaml` | Discovery index: where to find everything |
| `.agents/reports/TEMPLATE.md` | Handoff reports: what was done, what remains, what to do next |

## What this template is not

This is not an orchestration platform. It does not implement leases, heartbeats, runtime coordination, or autonomous task selection. Your agent harness (Cursor, Codex, etc.) handles context management, lifecycle, and liveness. This template provides the **durable truth** your agents read.

## Quick start

```bash
# Copy core template into your repo
cp -r templates/core/* /path/to/your/repo/
cp -r templates/core/.agents /path/to/your/repo/

# Fill in the files
# 1. Edit SPEC.md with your product description
# 2. Replace example tasks in TASKS.yaml with your real tasks
# 3. Fill in docs/architecture.md with your system map
# 4. Point AGENTS.md commands at your existing tools
```

Then prompt your agent:

> Work on task PROJ-001. Read AGENTS.md first for the operating rules.

## Optional modules

`templates/optional/` contains add-ons for repos that need them: wrapper scripts, ADR templates, local AGENTS.md examples for monorepos, CI workflows, STATUS.md, and greenfield root files. See [docs/adoption.md](docs/adoption.md) for guidance on when to add each.

## Docs

- [Vision](docs/vision.md) — why agent-native repos matter
- [How it works](docs/how-it-works.md) — the assignment flow and how the files work together
- [Adoption](docs/adoption.md) — step-by-step guide to applying the template
- [File-by-file rationale](docs/file-by-file-rationale.md) — what each file does and why
- [Platform usage](docs/cursor-codex-usage.md) — Cursor, Codex, and Claude Code tips

## Examples

- [examples/minimal-repo/](examples/minimal-repo/) — smallest working example with a real spec, tasks, plan, and report
- [examples/before-after/](examples/before-after/) — shows adoption into a previously unstructured repo

## Schemas

JSON Schema files for validating `TASKS.yaml` and `.agents/manifest.yaml` are in [schemas/](schemas/).
