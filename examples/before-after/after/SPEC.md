# SPEC

## Product
A simple web API for managing resources. Built for internal use.

## Goals
- Clean REST API with standard CRUD operations
- Input validation and error handling

## Non-goals
- Not building a frontend
- Not supporting real-time features in v1

## Functional requirements
- [REQ-001] API exposes CRUD endpoints for the primary resource.
- [REQ-002] Invalid input returns 400 with validation errors.

## Non-functional requirements
- **Performance**: p95 latency under 100ms.
- **Security**: No secrets in logs.

## Constraints
- Node.js, JavaScript
- Deployed as a single process

## Definition of done
- Acceptance criteria pass.
- `npm run lint && npm test` passes.
