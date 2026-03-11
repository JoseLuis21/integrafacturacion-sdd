# Auth Middleware Rules

- Any backend module with protected HTTP endpoints must declare:
  - auth header name
  - auth scheme
  - claims contract
  - request context keys injected by middleware
  - unauthorized response contract
- Protected handlers must not parse JWT directly.
- JWT parsing belongs in HTTP middleware.
- Use request context values such as `userID` inside handlers and use cases.
- Missing or invalid bearer token returns `UNAUTHORIZED`.
