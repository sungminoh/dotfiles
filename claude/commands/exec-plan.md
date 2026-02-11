You are executing a structured implementation plan. Follow every step precisely.

## Setup

1. Get the current timestamp and git SHA:
   - timestamp: `date +%Y%m%d_%H%M%S`
   - gitsha: first 7 chars of `git rev-parse HEAD` (if not a git repo, use "nogit")
2. Create directory: `./docs/plans/{timestamp}_{gitsha}_{task_name}/`
3. Write `PLAN.md` in that directory based on the user's request below.
4. Write `STATUS.md` in that directory with initial state.

## PLAN.md format

```markdown
# Plan: {brief title}

Created: {timestamp}
Base commit: {gitsha}

## Steps

- [ ] Step 1: {concrete description - which file, what change}
- [ ] Step 2: ...
...
- [ ] Final: Verify - build/test pass
```

Break the user's request into concrete, actionable steps. Each step must specify which files to create or modify.

## STATUS.md format

```markdown
# Status

## Current: Step 1
## Progress: 0/{total}

| Step | Status | Notes |
|------|--------|-------|
| 1. ... | ⏳ pending | |
| 2. ... | ⏳ pending | |
...
```

## Execution rules

- After writing both files, immediately start implementing Step 1.
- Before each step: update STATUS.md (mark current step as 🔄 in progress).
- After each step: update STATUS.md (mark as ✅ done, update Current/Progress).
- Do NOT stop until all steps show ✅ in STATUS.md.
- Do NOT summarize remaining work. Actually do it.
- Do NOT ask "should I continue?". Just continue.
- If a step fails, mark it as ❌ in STATUS.md with error notes, attempt to fix, and retry.
- After all steps: run verification (build/test), mark final status.

## User's request

$ARGUMENTS
