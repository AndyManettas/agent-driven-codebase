# Architecture

## System context
A single-process Node.js web API.

## Major modules
- **Routes** (`src/`): HTTP handlers and input validation.

## Data flow
Request → handler → response

## Where to add new code
- New endpoint → add handler in `src/`.
- New test → add in `tests/`.
