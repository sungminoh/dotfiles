#!/bin/bash
# PreCompact: Save working context before context window compression
# This prevents loss of important context during compaction

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // ""' 2>/dev/null)

if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
  exit 0
fi

# Skip non-project directories
if [ "$CWD" = "$HOME" ] || [[ "$CWD" == *"/.claude"* ]]; then
  exit 0
fi

PROJECT_NAME=$(basename "$CWD")
MEMORY_DIR="$HOME/.claude/project-memory/$PROJECT_NAME"
mkdir -p "$MEMORY_DIR"

# Save current git context as session state
if [ -d "$CWD/.git" ]; then
  {
    echo "# Session Context (auto-saved at compact)"
    echo "## Date: $(date '+%Y-%m-%d %H:%M')"
    echo "## Branch: $(cd "$CWD" && git branch --show-current 2>/dev/null)"
    echo ""
    echo "## Recent changes:"
    cd "$CWD" && git diff --stat HEAD 2>/dev/null | head -20
    echo ""
    echo "## Modified files:"
    cd "$CWD" && git status --short 2>/dev/null | head -20
  } > "$MEMORY_DIR/session-context.md"

  echo "[Memory] Session context saved before compact" >&2
fi

exit 0
