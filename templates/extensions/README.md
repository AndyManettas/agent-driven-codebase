# Extensions

`templates/core/` is the canonical repo structure for this template.
Everything under `templates/extensions/` extends that core; nothing here is a second starting shape.

Lean v1 ships only two supported extensions:

- `skills/` for extra repo-specific workflows beyond the mandatory core lifecycle
- `local-agents/` for subtree-specific `AGENTS.md` files in monorepos or large repos

Adopt extensions only when the repo has a concrete need they solve.
Add them one at a time so the operating model stays small and easy to reason about.
If you use `templates/extensions/skills/`, copy only the extra skills you need into the core `skills/` directory that already exists in adopted repos.

Future extension ideas such as CI wrappers, ADRs, greenfield root files, integration config, or macro status files are intentionally not shipped in lean v1.
Add those directly in your own repo only when the need is concrete.
