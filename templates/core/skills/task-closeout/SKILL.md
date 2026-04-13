---
name: task-closeout
description: Reconcile code, verification, task state, and durable repo context before marking a task done or handing it off for review.
---

# Task closeout

## When to use
- The implementation is ready for final verification.
- The agent is preparing a handoff or review-ready state.
- The task might be marked `done`, `blocked`, or `in_review`.

## Read first
- `AGENTS.md`
- `.agents/manifest.yaml`
- The assigned task in `TASKS.yaml`
- The task plan
- The latest task report
- `docs/architecture.md` and `SPEC.md` if the task changed durable system or product truth

## Actions
1. Re-read the task acceptance criteria and verify commands before final status changes.
2. Rebase on the default branch, rerun final verification, and recheck overlap before marking the task complete.
3. Record the observed verification commands and results in the task report.
4. Ensure the latest report entry explains what shipped, what remains, and what the next session or reviewer should do first.
5. Update `docs/architecture.md`, `SPEC.md`, and `STATUS.md` if the final change introduced durable truth changes that are not already recorded.
6. Mark `done` only when verification passes. Otherwise use `blocked` or `in_review`, whichever matches reality.

## Update surfaces
- `TASKS.yaml`
- `.agents/reports/<TASK-ID>.md`
- `docs/architecture.md` when system truth changed
- `SPEC.md` when product truth changed
- `STATUS.md` when macro status changed

## Output
The task can be resumed, reviewed, or merged without relying on hidden chat context, and the task status matches the actual verification state.
