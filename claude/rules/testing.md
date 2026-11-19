# Testing

Follow the project's existing test setup and coverage targets first. The rules below are defaults for projects that don't define their own.

## Defaults

- Aim for ~80% coverage on new or changed code.
- Unit tests for logic; integration tests where code crosses an API or database boundary; E2E (Playwright) only for critical user flows in apps that have a UI.
- Scripts, prototypes, and config changes don't need a full test pyramid.

## Test-driven development

Prefer test-first for new features and bug fixes (`superpowers:test-driven-development`):
1. Write the test. Run it; it must fail.
2. Write the minimal implementation. Run it; it must pass.
3. Refactor.

## When tests fail

1. Use the `superpowers:systematic-debugging` skill.
2. Check test isolation (no shared state).
3. Verify mocks and fixtures.
4. Fix the implementation, not the test, unless the test is wrong.
5. Check for async issues (missing `await`, event loop).
