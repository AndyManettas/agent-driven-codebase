---
name: project-purpose
description: Meta repo providing a drop-in template for making codebases agent-native for Cursor/Codex cloud agents
type: project
---

This repo (agent-driven-codebase) is a meta repo that ships a lean, copyable, additive template for making existing codebases legible and steerable for long-running cloud agents (Cursor, Codex).

**Why:** Agents need durable repo-native context — operating contracts, product truth, task registries, plans, architecture docs, and handoff reports. Without this structure, agents guess, drift, and lose context across sessions.

**How to apply:** The template is additive-first (new files only, no collisions with existing repos). Core is 7 files. Optional modules added only when justified. The human assigns tasks; agents are not self-orchestrating in v1.
