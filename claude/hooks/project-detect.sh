#!/bin/bash
# SessionStart hook: detect project type and suggest CLAUDE.md creation
# Outputs suggestions to stderr (shown to Claude as context)

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // ""' 2>/dev/null)

if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
  exit 0
fi

# Skip home directory and .claude directory itself
if [ "$CWD" = "$HOME" ] || [[ "$CWD" == *"/.claude"* ]]; then
  exit 0
fi

# Skip if not a git repo or project root
if [ ! -d "$CWD/.git" ] && [ ! -f "$CWD/package.json" ] && [ ! -f "$CWD/pyproject.toml" ] && [ ! -f "$CWD/Cargo.toml" ] && [ ! -f "$CWD/go.mod" ]; then
  exit 0
fi

# Detect project type
PROJECT_TYPE=""
if [ -f "$CWD/pyproject.toml" ] || [ -f "$CWD/setup.py" ]; then
  PROJECT_TYPE="python"
elif [ -f "$CWD/package.json" ]; then
  PROJECT_TYPE="node"
elif [ -f "$CWD/Cargo.toml" ]; then
  PROJECT_TYPE="rust"
elif [ -f "$CWD/go.mod" ]; then
  PROJECT_TYPE="go"
fi

# Check for CLAUDE.md
if [ ! -f "$CWD/CLAUDE.md" ] && [ ! -f "$CWD/.claude/CLAUDE.md" ]; then
  echo "[Hook] No CLAUDE.md found in project root." >&2
  echo "[Hook] Consider creating one with: /claude-md-management:revise-claude-md" >&2
  if [ -n "$PROJECT_TYPE" ]; then
    echo "[Hook] Detected project type: $PROJECT_TYPE" >&2
  fi
fi

# Check for knowledge base
if [ -d "$CWD/docs/knowledge" ]; then
  echo "[Hook] Knowledge base found at docs/knowledge/" >&2
  ls "$CWD/docs/knowledge/"*.md 2>/dev/null | while read f; do
    echo "[Hook]   - $(basename "$f")" >&2
  done
fi

exit 0
