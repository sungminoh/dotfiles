#!/bin/bash
# SessionStart: Load project-specific memory context
# Outputs memory context to stderr for Claude to see

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // ""' 2>/dev/null)

if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
  exit 0
fi

# Determine project memory directory
# Claude Code stores per-project memory in ~/.claude/projects/-<path-hash>/memory/
# We use a simpler scheme: ~/.claude/project-memory/<project-name>/
PROJECT_NAME=$(basename "$CWD")
MEMORY_DIR="$HOME/.claude/project-memory/$PROJECT_NAME"

if [ ! -d "$MEMORY_DIR" ]; then
  exit 0
fi

# Load session memory if exists
if [ -f "$MEMORY_DIR/session-context.md" ]; then
  echo "[Memory] Previous session context loaded for $PROJECT_NAME:" >&2
  head -30 "$MEMORY_DIR/session-context.md" >&2
fi

# Load common pitfalls if exists
if [ -f "$MEMORY_DIR/pitfalls.md" ]; then
  PITFALL_COUNT=$(wc -l < "$MEMORY_DIR/pitfalls.md" | tr -d ' ')
  if [ "$PITFALL_COUNT" -gt 0 ]; then
    echo "[Memory] Known pitfalls ($PITFALL_COUNT lines):" >&2
    cat "$MEMORY_DIR/pitfalls.md" >&2
  fi
fi

exit 0
