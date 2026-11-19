# Git Workflow

## Commit messages

```
<type>(<optional scope>): <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci.

Attribution is disabled in `settings.json` (`"attribution": {"commit": "", "pr": ""}`). Do not add `Co-Authored-By` trailers or "Generated with Claude Code" lines.

## Pull requests

1. Analyze the full commit history of the branch, not just the latest commit.
2. Run `git diff <base-branch>...HEAD` to see every change.
3. Write a PR summary that covers all of it.
4. Include a test plan as a checklist.
5. Push new branches with `-u`.

## Before committing

1. Run the project's linter, formatter, type checker, and full test suite with coverage. Do not commit on failure.
2. Fix every critical and high-severity review finding.
3. Write detailed commit messages in the format above.
