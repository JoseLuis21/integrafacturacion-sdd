# Environment Configuration

Backend configuration is loaded from environment variables.

The application reads variables from:

- `.env.local` in development
- real environment variables in production

Suggested loader:

- `github.com/joho/godotenv`
