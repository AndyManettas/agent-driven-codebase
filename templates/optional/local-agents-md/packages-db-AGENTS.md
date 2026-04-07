# packages/db/AGENTS.md

This directory owns schema, migrations, and query code.

## Always
- Add forward migration and rollback notes.
- Update database tests.
- Keep migration files idempotent where possible.

## Never
- Call the database directly from UI code.
- Write destructive migrations without a rollback path.
