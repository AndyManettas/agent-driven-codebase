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

## When to use
- A release task or release handoff needs a consistent final pass.

## Read first
- `AGENTS.md`
- `.agents/manifest.yaml`
- The assigned task in `TASKS.yaml`
- Any release notes or rollout instructions the repo already uses

## Actions
1. Run the repo's release-specific checks.
2. Confirm any release docs or changelog updates required by the repo.
3. Record the outcome in the task report.

## Update surfaces
- `.agents/reports/<TASK-ID>.md`
- Release notes or changelog files, if the assigned task requires them

## Output
The repo-specific workflow completed or is clearly blocked with the reason recorded durably.
```
