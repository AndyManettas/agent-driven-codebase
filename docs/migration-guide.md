# Migration guide

## Goal

Adopt the template into an existing repo without colliding with existing root files, CI, scripts, or contribution guides.

## Safe migration pattern

1. Copy only `templates/core/` into the repo root.
2. Keep the repo's existing `README.md`, CI workflows, scripts, and contribution files unchanged by default.
3. In `AGENTS.md`, point to the repo's existing command surface instead of introducing wrapper scripts.
4. Add optional modules only when the repo truly lacks that surface.

## Collision avoidance

- Do not overwrite an existing root `README.md`.
- Do not replace the repo's CI if it already has one.
- Do not add `scripts/` wrappers if the repo already has stable commands.
- Do not add greenfield root files to an established repo unless the team explicitly wants them.

## Recommended sequence

1. Add the seven core files.
2. Replace placeholder content.
3. Validate that `AGENTS.md` references real commands.
4. Trigger a small human-assigned task first.
5. Add optional modules later, one module at a time.

## Common migration mistakes

- Copying optional modules by default.
- Duplicating operating rules into platform-specific files.
- Leaving placeholder tasks in `TASKS.yaml`.
- Treating repo git state as a hard lock rather than advisory coordination.
