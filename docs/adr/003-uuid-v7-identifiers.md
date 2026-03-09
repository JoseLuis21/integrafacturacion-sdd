# ADR-003 — UUID v7 Identifiers

## Context

Traditional database identifiers often use:

- auto-increment integers
- bigserial

However these approaches introduce issues:

- predictable IDs
- potential IDOR security problems
- difficulty merging distributed data

For SaaS systems exposed through APIs, predictable IDs can be a security risk.

UUID v4 solves predictability but causes poor index locality in databases.

UUID v7 provides:

- time-ordered UUIDs
- strong randomness
- better insertion performance

## Decision

Use **UUID v7 identifiers generated in the application layer**.

Identifiers will:

- not be sequential
- not be guessable
- maintain time ordering for database performance

## Consequences

### Pros

- reduces IDOR risks
- safe for public APIs
- better insertion performance than UUID v4
- supports distributed generation

### Cons

- slightly larger storage than integers
- requires UUID support in tooling