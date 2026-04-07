# packages/db/AGENTS.md

This subtree owns schema, migrations, and query code.

## Always
- Add forward migration notes and rollback notes.
- Update tests that cover schema or query behavior.
- Keep destructive changes behind explicit approval.

## Never
- Call the database directly from UI code.
- Ship irreversible migrations without a rollback path.
