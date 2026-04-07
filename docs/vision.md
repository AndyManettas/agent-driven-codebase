# Vision

## The problem

Modern coding agents can read a codebase, edit files, run commands, and use extension points like persistent instruction files, skills, subagents, hooks, and MCP. But most repos give them nothing to work with beyond raw code and a README written for humans. The result: agents guess at requirements, lose context between sessions, repeat work, drift from the spec, and have no durable handoff trail.

## The principle

Use the repo for durable knowledge, not live chatter.

An agent-native codebase makes four things explicit:
1. **What the product is** — a single spec (`SPEC.md`) that is the source of truth for requirements.
2. **What work exists** — a single task registry (`TASKS.yaml`) that is the source of truth for task state.
3. **How to work** — an operating contract (`AGENTS.md`) that tells agents the read order, lifecycle, quality gates, style rules, and boundaries.
4. **How to verify** — a stable command surface that agents can call without guessing.

Everything else is derived from or supports these four surfaces.

## Design decisions

**One source of truth per concern.** Requirements live in SPEC.md. Task state lives in TASKS.yaml. Verification lives in scripts. There is no second place to check.

**Durable knowledge over live state.** Plans, reports, and architecture docs are committed to git. Scratchpads, heartbeats, and runtime state are not.

**Additive, not invasive.** The template creates new files that do not collide with an existing repo's README, .gitignore, CI, or scripts. Existing command surfaces are reused.

**Progressive disclosure.** Agents read a short entrypoint first (AGENTS.md), then load only what they need for the assigned task. Context fills up fast — concise entrypoints matter.

**The template is not the harness.** Context-window management, agent lifecycle, liveness, and orchestration are the harness's job (Cursor, Codex, etc.). The template provides the durable truth that the harness reads.

**Advisory coordination, not distributed locks.** When multiple agents work concurrently, file-overlap detection in TASKS.yaml provides advisory conflict avoidance. This is not a hard lock — repo-only git state cannot provide atomic distributed coordination.
