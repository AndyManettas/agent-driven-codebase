# SPEC

## Product
A task management API that lets teams create, assign, and track work items. Built for small engineering teams that want a lightweight alternative to full project management tools.

## Goals
- Simple REST API for task CRUD operations
- User authentication and authorization
- Real-time status updates via webhooks

## Non-goals
- Not building a UI in v1
- Not supporting complex workflow engines or custom fields
- Not replacing Jira for large orgs

## Functional requirements
- [REQ-001] Users can create, read, update, and delete tasks via REST API.
- [REQ-002] Users can assign tasks to team members.
- [REQ-003] Tasks have statuses: open, in_progress, done.
- [REQ-004] System sends webhook notifications on task status changes.
- [REQ-005] API requires authentication via API key.

## Non-functional requirements
- **Reliability**: 99.9% uptime for the API.
- **Performance**: p95 latency under 200ms for all endpoints.
- **Security**: API keys hashed at rest. No PII in logs.

## Constraints
- Tech stack: Node.js, TypeScript, PostgreSQL
- Deployment: Docker on a single VM initially
- Backward compatibility: API versioning from day one

## Definition of done
A task is done only when:
- Acceptance criteria pass.
- `npm run lint && npm run typecheck && npm test` passes.
- Docs updated if the API surface changed.

## Open questions
- Webhook retry policy (exponential backoff? max retries?)
- Rate limiting strategy for the public API
