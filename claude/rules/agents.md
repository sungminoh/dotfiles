# Agents and Skills

The preferred agents and skills for the workflows in CLAUDE.md. Other installed agents and skills may be used when they fit better.

## Built-in subagents

| `subagent_type` | Use for |
|---|---|
| `Explore` | Fast read-only codebase search (thoroughness: quick, medium, very thorough) |
| `Plan` | Read-only research and implementation planning |
| `general-purpose` | Multi-step tasks that need both exploration and edits |

`Explore` and `Plan` start without CLAUDE.md or these rules. Put every constraint they must follow in the prompt.

## Plugin agents

| `subagent_type` | Use for |
|---|---|
| `feature-dev:code-architect` | Architecture decisions and implementation blueprints |
| `feature-dev:code-explorer` | Tracing how an existing feature works end to end |
| `feature-dev:code-reviewer` | Independent code review in a separate context |

## Skills and commands

| Name | Kind | Use for |
|---|---|---|
| `/code-review` | built-in skill | Correctness review of the current diff |
| `/simplify` | built-in skill | Reuse, simplification, and efficiency cleanup of changed code |
| `/security-review` | built-in command | Security review of the branch against the default branch |
| `superpowers:test-driven-development` | plugin skill | New features and bug fixes, test-first |
| `superpowers:systematic-debugging` | plugin skill | Bugs, test failures, build failures |
| Playwright MCP | plugin MCP server | E2E checks of critical user flows |

When to use which is defined by the workflows in CLAUDE.md.

## Parallel execution

Launch independent agents in a single message so they run concurrently.

```markdown
# Good: parallel
Launch 3 agents in one message:
1. Security analysis of the auth module
2. Performance review of the cache layer
3. Type checking of utils

# Bad: sequential when there is no dependency
Run agent 1, wait, then agent 2, wait, then agent 3
```

## Multi-perspective analysis

For genuinely complex or high-stakes problems, consider splitting review roles across a few subagents (e.g. correctness, security, consistency). Don't spawn agents for work a handful of tool calls can do.
