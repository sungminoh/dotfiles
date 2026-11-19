# Testing

## Minimum coverage: 80%

All three test types are required:
1. **Unit tests**: individual functions, utilities, classes.
2. **Integration tests**: API endpoints, database operations.
3. **E2E tests**: critical user flows (Playwright).

## Test-driven development

Mandatory workflow:
1. Write the test first (RED).
2. Run it. It must fail.
3. Write the minimal implementation (GREEN).
4. Run it. It must pass.
5. Refactor (IMPROVE).
6. Verify coverage (80%+).

## When tests fail

1. Use the `superpowers:systematic-debugging` skill.
2. Check test isolation (no shared state).
3. Verify mocks and fixtures.
4. Fix the implementation, not the test, unless the test is wrong.
5. Check for async issues (missing `await`, event loop).
