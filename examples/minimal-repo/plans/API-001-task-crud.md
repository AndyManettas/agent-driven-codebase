---
task: API-001
title: Add task CRUD endpoints
status: draft
depends_on: []
---

# Goal
Add REST endpoints for creating, reading, updating, and deleting tasks.

# Why
This is the core functionality of the product. All other features depend on tasks existing.

# Scope
- Included: CRUD endpoints, input validation, database queries, tests.
- Excluded: Authentication (handled by API-002), webhooks (separate task).

# Files to modify
- src/routes/tasks/router.ts (new)
- src/services/tasks/taskService.ts (new)
- src/db/migrations/001-create-tasks.sql (new)
- tests/routes/tasks/crud.test.ts (new)

# Approach
1. Create the tasks table migration.
2. Add the task service with CRUD operations.
3. Add the route handlers with input validation.
4. Write tests for each endpoint.
5. Run full verification.

# Risks
- Pagination strategy: offset vs cursor. Use offset for simplicity in v1.
- Soft delete vs hard delete: use soft delete (add deleted_at column).

# Validation
- `npm test -- tasks` — all task tests pass.
- `npm run lint && npm run typecheck && npm test` — full verification.

# Rollback
Drop the tasks table migration. Remove the route registration.

# Done when
- All five CRUD operations work as specified in acceptance criteria.
- Full verification passes.
