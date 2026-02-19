#!/bin/bash
# Stop: Save session summary for next session
# Non-blocking (exit 0 always)

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

# Save final session state
if [ -d "$CWD/.git" ]; then
  {
    echo "# Last Session Summary"
    echo "## Date: $(date '+%Y-%m-%d %H:%M')"
    echo "## Branch: $(cd "$CWD" && git branch --show-current 2>/dev/null)"
    echo ""
    echo "## Uncommitted changes:"
    cd "$CWD" && git status --short 2>/dev/null | head -20
    echo ""
    echo "## Recent commits (this session):"
    cd "$CWD" && git log --oneline -5 2>/dev/null
  } > "$MEMORY_DIR/session-context.md"
fi

exit 0
