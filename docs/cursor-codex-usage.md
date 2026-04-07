# Cursor and Codex usage

## Cursor

When launching a Cursor cloud agent for a task, include the task ID in the prompt:

> Work on task PROJ-001. Read AGENTS.md first for the repo operating rules, then follow the assigned-task lifecycle.

Cursor manages its own context window and run lifecycle. The template files provide the durable truth it should read.

If you use Cursor's `.cursor/rules/` system, keep these rules thin and derived from AGENTS.md. Do not hand-maintain divergent policy in both places.

Example `.cursor/rules/project.mdc`:
```
Read AGENTS.md for the full operating contract.
Read the assigned task in TASKS.yaml before starting work.
Follow the lifecycle defined in AGENTS.md.
```

## Codex (OpenAI)

Codex agents read repo files the same way. Point the agent at `AGENTS.md` as the entry point and assign a task ID in the prompt:

```
Read AGENTS.md for the full operating contract.
Read the assigned task in TASKS.yaml before starting work.
Follow the lifecycle defined in AGENTS.md.
```

## General guidance

Regardless of platform:
- **One source of truth**: AGENTS.md is the operating contract. Platform-specific adapter files should point to it, not duplicate it.
- **Task assignment via prompt**: Include the task ID when triggering the agent.
- **Reports as handoff**: If the agent's session ends before the task is complete, the report in `.agents/reports/<TASK-ID>.md` carries context to the next session.
- **Existing tools**: Point AGENTS.md commands at whatever your repo already uses. The template does not require specific tooling.
