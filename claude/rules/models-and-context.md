# Subagent Models and Context

## Subagent model choice

When a subagent's model can be set, pick by task:
- `opus`: architecture decisions, deep analysis, complex debugging.
- `sonnet`: routine implementation.
- `haiku`: lightweight, frequently invoked work such as searches and simple transforms.

## Context hygiene

- Delegate large reads and broad searches to subagents so only their conclusions return.
- Prefer CLI tools (`gh` and similar) over MCP servers when both work.

## Build failures

1. Use the `superpowers:systematic-debugging` skill.
2. Read the error messages in full.
3. Fix incrementally.
4. Verify after each fix.
