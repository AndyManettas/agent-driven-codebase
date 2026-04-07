# File-by-file rationale

## Core files

### AGENTS.md
**What it does**: Single first-read operating contract for agents. Defines read order, lifecycle, command surface, style rules, git workflow, and boundaries.

**Why it exists**: Without an explicit operating contract, agents invent their own workflow — inconsistent branching, skipping tests, editing files outside scope. AGENTS.md makes the rules explicit and machine-readable.

**When to customize**: Always. Point the Commands section at your repo's existing tools. Adjust code style and boundaries to match your project's conventions.

**Common mistakes**: Making it too long (keep it under 200 lines). Duplicating information that belongs in SPEC.md or architecture.md.

### SPEC.md
**What it does**: Defines the product — what it does, who it's for, what it must and must not do.

**Why it exists**: Agents need to understand the product intent behind a task, not just the task itself. Without a spec, agents optimize for the letter of the acceptance criteria rather than the spirit of the product.

**When to customize**: Always. This is your product truth.

**Common mistakes**: Writing implementation details instead of requirements. Letting it go stale — update it when product direction changes.

### TASKS.yaml
**What it does**: Machine-readable task registry. Each task has an ID, status, priority, file scope, acceptance criteria, and verification commands.

**Why it exists**: Agents need a structured way to understand what work exists, what's in progress, what's blocked, and what's done. Human-readable issue trackers are hard for agents to parse reliably. The `files:` field also enables overlap detection for concurrent agents.

**When to customize**: Always. Replace example tasks with your real work.

**Common mistakes**: Marking tasks `done` before verification passes. Not declaring `files:` globs (breaks overlap detection). Circular dependencies in `deps:`.

### plans/TEMPLATE.md
**What it does**: Per-task implementation plan with sections for goal, scope, approach, risks, and validation.

**Why it exists**: For non-trivial tasks, a pre-approved plan prevents the agent from guessing at the implementation approach. Plans reduce drift on long runs and make agent work more predictable.

**When to customize**: Copy and fill in for each task that needs a plan. Not every task needs one — simple, well-scoped tasks with clear acceptance criteria can skip the plan.

**Common mistakes**: Writing plans that are too detailed (the agent still needs room to make implementation decisions). Not updating the plan when the approach changes.

### docs/architecture.md
**What it does**: System map showing modules, data flow, boundaries, external systems, and where to add new code.

**Why it exists**: Agents need to understand the system's shape to know where new code belongs, what each layer can depend on, and where the sharp edges are.

**When to customize**: Always. Fill in your real modules and boundaries.

**Common mistakes**: Letting it go stale. Writing too much — a system map should be a page, not a book.

### .agents/manifest.yaml
**What it does**: Discovery index pointing to entrypoints, task registry, plans directory, and reports directory.

**Why it exists**: Agents need to know where things are without guessing or searching. The manifest provides a single lookup point.

**When to customize**: Only when you add new directories (e.g., skills, examples). The default values work for the standard layout.

**Common mistakes**: Adding policy or live state to the manifest — it should only contain paths and pointers.

### .agents/reports/TEMPLATE.md
**What it does**: Append-only handoff report per task. Each entry records what was done, what remains, and what to do next.

**Why it exists**: Context does not survive between agent sessions unless it's written down. Reports are the handoff mechanism that lets the next session start where the last one left off.

**When to customize**: Copy for each task. The template structure should stay consistent so agents can parse it reliably.

**Common mistakes**: Writing every minute-by-minute thought (keep entries at session-level granularity). Overwriting previous entries instead of appending.

## Optional files

### scripts/
Wrapper scripts for lint, test, typecheck, smoke, bootstrap, and verify. Only needed if your repo does not already expose a stable command surface (e.g., `npm run test`, `make lint`).

### examples/
Canonical code patterns that agents use as references when implementing new features. Most valuable when your project has strong conventions that aren't obvious from the code alone.

### docs/adr/
Architecture Decision Records for non-obvious permanent design decisions. Use when a decision has trade-offs worth documenting for future agents and humans.

### Local AGENTS.md files
Subdirectory-level operating rules for monorepos. Keep these small and delta-only — they add to the root AGENTS.md, not replace it.

### STATUS.md
Macro project health snapshot. Only useful for repos where a durable high-level view adds value beyond what TASKS.yaml already provides.

### .editorconfig, .env.example, CODEOWNERS
Standard repo config files. Only needed for greenfield repos or when the adopter explicitly wants them.

### .github/workflows/ci.yml
CI workflow that calls the verification scripts. Only needed if the repo doesn't already have CI.
