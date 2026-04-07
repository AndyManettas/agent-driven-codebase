# Before and after

This example shows how an existing repo changes when the core template is adopted.

## Before

A typical repo with code, tests, and a README — but no agent-native structure:

```
before/
├── README.md
├── package.json
├── src/
│   └── index.ts
└── tests/
    └── index.test.ts
```

The agent has no operating contract, no task registry, no architecture context, and no handoff mechanism.

## After

The same repo with the core template added. No existing files were changed — only new files were added:

```
after/
├── README.md          ← unchanged
├── package.json       ← unchanged
├── src/
│   └── index.ts       ← unchanged
├── tests/
│   └── index.test.ts  ← unchanged
├── AGENTS.md          ← NEW
├── SPEC.md            ← NEW
├── TASKS.yaml         ← NEW
├── plans/
│   └── TEMPLATE.md    ← NEW
├── docs/
│   └── architecture.md ← NEW
└── .agents/
    ├── manifest.yaml   ← NEW
    └── reports/
        └── TEMPLATE.md ← NEW
```

The agent now has a clear operating contract, product truth, task registry, and handoff surface — without any changes to the existing code or configuration.
