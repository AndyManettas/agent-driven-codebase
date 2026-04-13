# skills

Adopt this extension when the repo needs extra repeatable workflows beyond the mandatory core lifecycle already shipped in `skills/`.
It extends the core workflow; it must not replace it.
The core manifest already wires `skills_dir: skills`.

Use `TEMPLATE.md` as the starting point for new skills and keep each skill narrowly scoped to one durable workflow.

Good candidates for extension skills:
- release checklists
- code review follow-up workflows
- deployment checklists
- compliance or documentation sign-off flows

Adoption steps:
1. Copy the relevant skills into the existing `skills/` directory at the target repo root.
2. Keep the core lifecycle skills intact.
3. Tell agents to load only the additional skills that apply to the assigned task's extra workflow needs.
4. Do not use extra skills to redefine task start, progress updates, closeout, or decomposition.
