# Skill template

Create repo-local skills as `skills/<skill-name>/SKILL.md`.
Keep each skill narrow, judgment-heavy, and tied to an extra repeatable workflow beyond the mandatory core lifecycle skills.

Suggested shape:

```md
---
name: release-checklist
description: Run the repo's release-specific checks before a human-triggered release handoff.
---

# Release checklist

## Purpose
Run a repeatable pre-release checklist for a human-triggered release task.

## When to use
- A release task or release handoff needs a consistent final pass.

## Steps
1. Read the assigned task and any release notes the repo already uses.
2. Run the repo's release-specific checks.
3. Confirm any release docs or changelog updates.
4. Record the outcome in the task report.
```
