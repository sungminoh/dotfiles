# Security

## Before every commit

- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user input validated
- [ ] SQL injection prevented (parameterized queries or an ORM)
- [ ] XSS prevented (escaping, sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication and authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages do not leak sensitive data
- [ ] Dependencies scanned for known vulnerabilities

## Secrets

Load secrets from environment variables or a secret manager. Never commit them, and keep `.env` files out of version control.

## If you find a security issue

1. Stop immediately.
2. Run `/security-review`.
3. Fix critical issues before continuing.
4. Rotate any exposed secrets.
5. Search the whole codebase for the same pattern.
