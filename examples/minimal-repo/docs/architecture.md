# Architecture

## System context
A REST API for task management. Clients authenticate with API keys and interact via HTTP. The system stores data in PostgreSQL and sends webhook notifications on state changes.

## Major modules
- **Routes** (`src/routes/`): HTTP handlers, input validation, response formatting.
- **Services** (`src/services/`): Business logic, orchestration between modules.
- **DB** (`src/db/`): Migrations, queries, connection management.
- **Middleware** (`src/middleware/`): Auth, rate limiting, error handling.

## Data flow
Request → middleware (auth) → route handler → service → database → response

## Boundaries
- Routes may call services. Routes must not call the database directly.
- Services may call the database. Services must not import route-level types.
- Middleware must not call services or the database beyond auth lookups.

## External systems
- PostgreSQL: primary data store.
- Webhook targets: outbound HTTP calls on task state changes (future).

## Sharp edges
- No ORM — raw SQL with parameterized queries.
- Soft deletes: queries must filter by `deleted_at IS NULL` unless explicitly including deleted records.

## Where to add new code
- New endpoint → add route in `src/routes/<area>/`, service in `src/services/<area>/`.
- New middleware → add in `src/middleware/`.
- New migration → add in `src/db/migrations/` with sequential numbering.
