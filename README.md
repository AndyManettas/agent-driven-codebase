Use the repo for durable knowledge, not live chatter. Modern coding agents can already read a codebase, edit files, run commands, and use extension points like persistent instruction files, skills, subagents, hooks, and MCP. Anthropic also explicitly notes that context fills up fast, so concise entrypoints and progressive disclosure matter.

## Canonical repo layout

```text
/
├─ README.md
├─ AGENTS.md
├─ SPEC.md
├─ TASKS.yaml
├─ CODEOWNERS
├─ .editorconfig
├─ .gitignore
├─ .env.example
├─ package.json / pyproject.toml / Makefile / justfile
├─ scripts/
│  ├─ bootstrap.sh
│  ├─ verify.sh
│  ├─ smoke.sh
│  ├─ lint.sh
│  ├─ test.sh
│  └─ typecheck.sh
├─ docs/
│  ├─ architecture.md
│  ├─ codemap.md
│  ├─ glossary.md
│  └─ adr/
│     ├─ README.md
│     └─ ADR-000-template.md
├─ plans/
│  ├─ TEMPLATE.md
│  └─ completed/
├─ examples/
│  └─ README.md
├─ .agents/
│  ├─ manifest.yaml
│  ├─ protocol.md
│  ├─ templates/
│  │  ├─ report.md
│  │  ├─ plan.md
│  │  ├─ skill.md
│  │  └─ command.md
│  ├─ reports/
│  ├─ skills/
│  ├─ commands/
│  ├─ subagents/
│  └─ runtime/
│     ├─ README.md
│     ├─ .gitignore
│     ├─ leases/
│     ├─ runs/
│     └─ scratchpads/
├─ .mcp.json                  # or tool-specific MCP adapter
├─ .github/workflows/
├─ knowledge/                 # optional
└─ docs/ai/                   # optional
```


## The files I would actually require

### 1. `README.md`

Human-first overview. Keep it short.

```md
# Project Name

One paragraph: what this product does and who it is for.

## Quick start
- `./scripts/bootstrap.sh`
- `./scripts/verify.sh`

## Key docs
- `AGENTS.md` — repo operating rules for agents
- `SPEC.md` — product requirements
- `TASKS.yaml` — machine-readable work graph
- `docs/architecture.md` — system map
```

### 2. `AGENTS.md`

This is the repo operating contract. Keep it under ~200 lines.

```md
# AGENTS.md

## Read order
1. `SPEC.md`
2. `TASKS.yaml`
3. relevant file in `plans/`
4. nearest subdirectory `AGENTS.md` if present
5. relevant skill in `.agents/skills/`
6. `docs/architecture.md`
7. `examples/`

## Commands
- bootstrap: `./scripts/bootstrap.sh`
- lint: `./scripts/lint.sh`
- typecheck: `./scripts/typecheck.sh`
- test: `./scripts/test.sh`
- smoke: `./scripts/smoke.sh`
- verify: `./scripts/verify.sh`

## Testing
- Any behavior change requires tests.
- Run targeted tests during iteration.
- Run `./scripts/verify.sh` before handoff or done.
- Do not mark a task `done` in `TASKS.yaml` until verification passes.

## Project structure
- `src/` or `app/`: product code
- `tests/`: integration and e2e
- `docs/`: architecture, ADRs, glossary
- `plans/`: task-specific implementation plans
- `.agents/skills/`: repeatable workflows
- `.agents/reports/`: durable task handoff reports
- `examples/`: canonical code patterns

## Code style
- Prefer small functions with explicit inputs/outputs.
- Prefer existing local patterns over generic framework patterns.
- Avoid hidden global state.
- Add types/schemas at boundaries.
- Example:
  - good: `createInvoice(input: CreateInvoiceInput): Promise<Invoice>`
  - bad: `handleThing(data: any): Promise<any>`

## Git workflow
- Branch: `task/<TASK-ID>-<slug>`
- Commit: `<TASK-ID>: imperative summary`
- Keep commits scoped to the task.
- On pause/finish, update the task report in `.agents/reports/`.

## Boundaries

### Always do
- Follow local patterns from nearby code and `examples/`.
- Add or update tests.
- Preserve backward compatibility unless the task says otherwise.
- Record non-obvious decisions in the task report or an ADR.

### Ask first
- DB schema changes
- public API changes
- auth/permission changes
- dependency changes
- deleting large modules
- infra cost changes

### Never do
- commit secrets
- skip tests to make CI pass
- mark work done without verification
- rewrite unrelated code “while here”

## Pointers
- Spec: `SPEC.md`
- Tasks: `TASKS.yaml`
- Architecture: `docs/architecture.md`
- Plan template: `plans/TEMPLATE.md`
- Report template: `.agents/templates/report.md`
```

Also add tiny **delta-only** local `AGENTS.md` files in specialized directories, for example `packages/db/AGENTS.md` or `apps/web/AGENTS.md`.

```md
# packages/db/AGENTS.md

This directory owns schema, migrations, and query code.

Always:
- add forward migration + rollback notes
- update DB tests
- load `.agents/skills/db-migrations/SKILL.md`

Never:
- call DB directly from UI code
```

### 3. `SPEC.md`

This is product truth, not implementation chatter.

```md
# SPEC

## Product
One paragraph describing the product and primary user.

## Goals
- Goal 1
- Goal 2

## Non-goals
- Not trying to do X
- Not trying to do Y

## Functional requirements
- [REQ-001] Users can ...
- [REQ-002] System must ...
- [REQ-003] Admins can ...

## Non-functional requirements
- reliability
- performance
- accessibility
- observability
- security/privacy

## Constraints
- tech stack
- compliance constraints
- deployment environment
- backward compatibility promises

## Definition of done
A task is done only when:
- acceptance criteria pass
- automated verification passes
- docs/examples are updated if needed
- any migration/rollback notes exist

## Open questions
- ...
```

### 4. `TASKS.yaml`

This replaces `feature_list.*`, half of your progress file, and most PRP status duplication.

```yaml
version: 1
status_values:
  - backlog
  - ready
  - in_progress
  - blocked
  - in_review
  - done

tasks:
  - id: AUTH-001
    title: Add password login
    status: ready
    priority: P1
    size: M
    area: auth
    deps: []
    plan: plans/AUTH-001-password-login.md
    report: .agents/reports/AUTH-001.md
    files:
      - src/auth/**
      - tests/auth/**
    acceptance:
      - Valid credentials create a session.
      - Invalid credentials return 401 without leaking account existence.
      - Login is rate limited.
    verify:
      - ./scripts/test.sh auth
      - ./scripts/verify.sh

  - id: AUTH-002
    title: Password reset request endpoint
    status: backlog
    priority: P2
    size: M
    area: auth
    deps: [AUTH-001]
    plan: plans/AUTH-002-password-reset.md
    report: .agents/reports/AUTH-002.md
    files:
      - src/auth/**
      - tests/auth/**
    acceptance:
      - Endpoint is idempotent.
      - Response does not reveal account existence.
      - Email job is enqueued.
    verify:
      - ./scripts/test.sh auth
      - ./scripts/verify.sh
```

Important rule: **only update status to `done` after verification passes**.

### 5. `plans/TEMPLATE.md`

Use one file per task.

```md
---
task: TASK-ID
title: Short title
status: draft
depends_on: []
---

# Goal
What this task changes.

# Why
Why this work matters.

# Scope
What is included and excluded.

# Files to modify
- path/to/file
- path/to/test

# Approach
Step-by-step implementation outline.

# Risks
- backward compatibility
- migrations
- performance
- security

# Validation
- exact commands to run
- expected outputs or behaviors

# Rollback
How to safely revert if needed.

# Done when
Concrete acceptance conditions.
```

### 6. `.agents/reports/<TASK-ID>.md`

This replaces the shared progress log. One report per task.

```md
# AUTH-001 report

## 2026-04-07 10:20 UTC — handoff
### Completed
- Added login service and handler
- Added rate-limit middleware
- Added unit tests for happy path and invalid credentials

### Remaining
- integration test for session cookie
- docs/auth.md update

### Files changed
- src/auth/login.ts
- src/http/routes/login.ts
- tests/auth/login.test.ts

### Commands run
- ./scripts/test.sh auth
- ./scripts/lint.sh

### Results
- targeted tests passed
- full verify not yet run

### Blockers
- none

### Next best step
- add integration test
- run ./scripts/verify.sh
- if green, mark TASKS.yaml as done
```

Use append-only dated sections. Do **not** write every minute-by-minute thought here.

### 7. `.agents/manifest.yaml`

This is the discovery index so agents do not have to guess what exists.

```yaml
version: 1

entrypoints:
  - AGENTS.md
  - SPEC.md
  - TASKS.yaml
  - docs/architecture.md

task_registry: TASKS.yaml
plans_dir: plans
reports_dir: .agents/reports
examples_dir: examples

skills:
  - name: db-migrations
    path: .agents/skills/db-migrations/SKILL.md
    triggers: [schema, migration, backfill]
  - name: frontend-patterns
    path: .agents/skills/frontend-patterns/SKILL.md
    triggers: [component, styling, accessibility]
  - name: incident-debugging
    path: .agents/skills/incident-debugging/SKILL.md
    triggers: [error, regression, flaky]

commands:
  - name: execute-task
    path: .agents/commands/execute-task.md
  - name: investigate-issue
    path: .agents/commands/investigate-issue.md

subagents:
  - name: security-reviewer
    path: .agents/subagents/security-reviewer.md
  - name: test-writer
    path: .agents/subagents/test-writer.md
```

### 8. `.agents/protocol.md`

This is the missing piece in most repos.

```md
# Agent protocol

## Purpose
Defines precedence, lifecycle, and what belongs in git vs runtime state.

## Precedence
1. Safety boundaries
2. Tests, schemas, and contracts define current behavior
3. `SPEC.md` + `TASKS.yaml` define intended behavior
4. relevant plan file defines task-local approach
5. `AGENTS.md` and local `AGENTS.md` define workflow/style
6. examples show preferred implementation patterns
7. stale docs lose to code/tests

## Lifecycle
1. Read entrypoints from `.agents/manifest.yaml`
2. Select one task from `TASKS.yaml`
3. Claim live ownership in external coordinator or runtime lease
4. Load only relevant skills
5. Implement with targeted tests first
6. Run `./scripts/verify.sh`
7. Update task report
8. Move task status to `done` only if verification passed
9. Release lease

## Git policy
Commit durable knowledge only:
- docs
- plans
- reports
- examples
- code/tests/config

Do not commit:
- scratchpads
- heartbeats
- raw transcripts
- temporary outputs
```

### 9. `docs/architecture.md`

Agents need a system map.

```md
# Architecture

## System context
What the system does and what it depends on.

## Major modules
- API layer
- domain services
- persistence
- background jobs
- frontend

## Data flow
Request -> validation -> service -> repository -> event/job -> response

## Boundaries
What each layer may and may not depend on.

## External systems
- auth provider
- payment processor
- queue
- analytics

## Sharp edges
- eventual consistency here
- legacy code here
- performance hotspot here

## Where to add new code
- new endpoint -> ...
- new job -> ...
- new component -> ...
```

I would also keep `docs/adr/` for non-obvious permanent decisions:

```md
# ADR-000-template

## Context
## Decision
## Consequences
## Alternatives considered
```

### 10. `examples/`

This is more valuable than long prose.

```md
# examples/README.md

Use these as canonical patterns:
- `examples/api-handler.*` — route/controller pattern
- `examples/service.*` — domain service pattern
- `examples/repository.*` — data access pattern
- `examples/feature.test.*` — test structure
- `examples/component.*` — UI component pattern
```

Make examples **real and compiling**, not pseudo-code.

### 11. `.agents/skills/<name>/SKILL.md`

One skill per repeatable workflow.

```md
---
name: db-migrations
description: Safe schema changes, data backfills, and rollback notes
triggers:
  - schema
  - migration
  - backfill
---

# Use when
Editing schema, writing migrations, or changing persistence contracts.

# Inputs
- task id
- schema diff
- affected services/tests

# Procedure
1. Add forward migration.
2. Write rollback notes.
3. Update repository code.
4. Add/adjust tests.
5. Run migration test path and full verify.

# Verification
- ./scripts/test.sh db
- ./scripts/verify.sh

# Gotchas
- avoid destructive migrations in one step
- backfills must be idempotent

# Examples
- examples/repository.*
```

### 12. `.agents/commands/*.md`

These are reusable workflows, not human docs.

```md
---
name: execute-task
inputs:
  - task_id
---

1. Read `AGENTS.md`, `TASKS.yaml`, relevant plan, and local `AGENTS.md`.
2. Claim the task in the external coordinator or runtime lease folder.
3. Load only relevant skills.
4. Implement the task.
5. Run targeted tests, then `./scripts/verify.sh`.
6. Update `.agents/reports/<TASK-ID>.md`.
7. Set task status to `done` only if verification passes.
8. Release the lease.
```

### 13. `.agents/subagents/*.md`

Only add these if your orchestrator actually supports subagents. They are useful at scale.

```md
---
name: security-reviewer
description: Reviews auth, permissions, secrets, crypto, and input-validation changes
allowed_tools:
  - read
  - search
  - test
write_access: false
triggers:
  - auth
  - permissions
  - secret
  - crypto
---

Return:
- risks
- affected files
- must-fix items
- nice-to-have hardening
```

## Executable truth: scripts and CI

This is where “impeccable standards” actually come from.

### 14. `scripts/bootstrap.sh`

Idempotent environment bring-up.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Replace with your real stack-specific steps.
./scripts/install-deps.sh
./scripts/setup-env.sh
./scripts/generate.sh
./scripts/db-prepare.sh
./scripts/smoke.sh
```

### 15. `scripts/verify.sh`

Single command to prove a task is shippable.

```bash
#!/usr/bin/env bash
set -euo pipefail

./scripts/lint.sh
./scripts/typecheck.sh
./scripts/test.sh
./scripts/smoke.sh
```

Also have simple wrappers:

```bash
# scripts/lint.sh
#!/usr/bin/env bash
set -euo pipefail
echo "replace with real lint command"

# scripts/test.sh
#!/usr/bin/env bash
set -euo pipefail
echo "replace with real test command"
```

The exact stack does not matter. What matters is that agents always have a **stable command surface**.

### 16. `.github/workflows/ci.yml`

CI is the real enforcer; hooks are only convenience.

```yaml
name: ci

on:
  pull_request:
  push:
    branches: [main]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/bootstrap.sh
      - run: ./scripts/verify.sh
```

## Runtime state: do not mix this with durable repo truth

### 17. `.agents/runtime/README.md`

This replaces shared scratchpads and live progress logs.

```md
# Runtime state

This directory is for ephemeral agent state.

Commit only:
- `README.md`
- `.gitignore`

Keep runtime files out of git:
- `leases/<task-id>.json`
- `runs/<run-id>.jsonl`
- `scratchpads/<run-id>.md`

Use an external coordinator for real multi-VM task claiming and heartbeats.
This folder is only a fallback for single-workspace or local workflows.
```

### 18. `.agents/runtime/.gitignore`

```gitignore
*
!README.md
!.gitignore
```

Example lease shape:

```json
{
  "task": "AUTH-001",
  "owner": "agent-7",
  "run_id": "agent-7-20260407T102000Z",
  "acquired_at": "2026-04-07T10:20:00Z",
  "heartbeat_at": "2026-04-07T10:45:00Z",
  "expires_at": "2026-04-07T11:20:00Z"
}
```

## Tool adapters, not source of truth

### 19. `.mcp.json`

Only if you have external tools. Secrets must come from env.

```json
{
  "servers": {
    "tracker": {
      "command": "./tools/tracker-mcp",
      "env": {
        "TRACKER_URL": "${TRACKER_URL}",
        "TRACKER_TOKEN": "${TRACKER_TOKEN}"
      }
    },
    "observability": {
      "command": "./tools/observability-mcp",
      "env": {
        "OBS_URL": "${OBS_URL}",
        "OBS_TOKEN": "${OBS_TOKEN}"
      }
    }
  }
}
```

Also keep any tool-native adapters thin. Example idea:

* `AGENTS.md` = canonical repo guidance
* `CLAUDE.md` = mirrored adapter for Claude-native memory
* `.cursor/rules/project.mdc` = mirrored adapter for Cursor-native rules

Do not hand-maintain three divergent policy files.

## Standard repo configs that matter more than people think

### `CODEOWNERS`

```text
* @platform-team
/src/auth/ @security-team
/src/payments/ @payments-team
/scripts/ @platform-team
```

### `.editorconfig`

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
indent_style = space
indent_size = 2
trim_trailing_whitespace = true
```

### `.env.example`

```dotenv
# Never put real secrets here.
APP_ENV=development
PORT=3000
DATABASE_URL=
REDIS_URL=
```

### language-native command surface

Whatever your stack uses, expose stable scripts:

```json
{
  "scripts": {
    "bootstrap": "bash scripts/bootstrap.sh",
    "verify": "bash scripts/verify.sh",
    "lint": "bash scripts/lint.sh",
    "typecheck": "bash scripts/typecheck.sh",
    "test": "bash scripts/test.sh",
    "smoke": "bash scripts/smoke.sh"
  }
}
```

## Optional, only when justified

### `knowledge/`

Use this only if the product/domain is complex enough to need a wiki-like graph.

```text
knowledge/
├─ index.md
├─ mocs/
│  ├─ billing.md
│  └─ compliance.md
└─ nodes/
   ├─ billing-ledger.md
   └─ refund-invariants.md
```

Example node:

```md
---
title: Billing ledger
summary: Source of truth for invoice and payment state transitions
tags: [billing, invariants]
---

See also: [[refund-invariants]]
```

### `docs/ai/`

Curated docs for unstable or new libraries that agents may not know well.

### hooks

Useful, but keep them thin and deterministic. Hook scripts should call repo scripts, not duplicate logic. Never make hooks the only enforcement mechanism.

### PRP template

Keep it as a template flavor, not a parallel universe:

```text
.agents/templates/prp.md
```

## The smallest serious version

If I were bootstrapping from zero for a repo that will be worked on by many agents, I would start with exactly this:

* `README.md`
* `AGENTS.md`
* `SPEC.md`
* `TASKS.yaml`
* `plans/`
* `docs/architecture.md`
* `examples/`
* `scripts/bootstrap.sh`
* `scripts/verify.sh`
* `.agents/manifest.yaml`
* `.agents/protocol.md`
* `.agents/reports/`
* `.agents/skills/`
* `.agents/runtime/README.md`
* CI workflow
* standard configs (`CODEOWNERS`, `.editorconfig`, `.env.example`, `.gitignore`)

That is the smallest setup that still supports:

* cold-start comprehension
* long autonomous runs
* clean task handoff
* reusable workflows
* enforceable quality gates
* multi-agent scaling without constant confusion

The most important design choice is this: **one source of truth for requirements, one source of truth for task state, one source of truth for verification, and no shared mutable scratchpad in git.** The next best step is to instantiate this for your actual stack so the scripts, examples, and task schema are concrete rather than placeholders.
