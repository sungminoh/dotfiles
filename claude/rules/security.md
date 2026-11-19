# Security

## Before committing

- No hardcoded secrets (API keys, passwords, tokens).
- When the change touches the relevant surface, check: input validation, injection (SQL/command/XSS), authn/authz, error messages leaking sensitive data.
- For web services, also consider CSRF and rate limiting where they apply.
- When adding dependencies, check them for known vulnerabilities.

## Secrets

Load secrets from environment variables or a secret manager. Never commit them, and keep `.env` files out of version control.

## If you find a security issue

1. Stop and tell the user.
2. Run `/security-review`.
3. Fix critical issues before continuing.
4. Rotate any exposed secrets.
5. Search the codebase for the same pattern.
