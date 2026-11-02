#!/bin/bash
# Block git commands that DISCARD uncommitted working-tree changes.
#
# Why: the rambledump sessions repeatedly lost uncommitted work when a
# subagent ran `git checkout -- <file>` to "clean up" linter/SourceKit
# noise — that reverts the file to HEAD, destroying ANY uncommitted edits,
# not just the noise. This guard makes that class of command fail fast so
# work is never silently discarded. Commit or branch first instead; remove
# noise with targeted edits, not `git checkout`.
#
# Escape hatch: prefix the command with ALLOW_DESTRUCTIVE_GIT=1 (or export
# it) when a discard is genuinely intended.
#
# Registered as a PreToolUse hook on Bash. Exit 2 = block the tool call.

input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // ""')

if [ "${ALLOW_DESTRUCTIVE_GIT:-0}" = "1" ] || echo "$cmd" | grep -q 'ALLOW_DESTRUCTIVE_GIT=1'; then
  echo "$input"
  exit 0
fi

# Destructive, working-tree-discarding forms (NOT branch switching):
#   git checkout -- ...        / git checkout .        (discard tracked file edits)
#   git restore <path>         (discard working tree; --staged-only is safe but we block the broad form)
#   git reset --hard           (discard everything)
#   git clean -f / -df / -xf   (delete untracked files)
#   git stash (push/save/bare) (stows working changes off the tree)
DESTRUCTIVE='git[[:space:]]+(checkout[[:space:]]+(--|\.([[:space:]]|$))|restore[[:space:]]+[^-]|reset[[:space:]]+(--hard|--keep)|clean[[:space:]]+-[a-zA-Z]*f|stash([[:space:]]+(push|save))?[[:space:]]*($|-))'

if echo "$cmd" | grep -qE "$DESTRUCTIVE"; then
  echo "[Hook] BLOCKED: this git command discards uncommitted work — '$cmd'" >&2
  echo "[Hook] Commit or branch first; remove unwanted edits with a targeted edit, not git checkout." >&2
  echo "[Hook] Override (only if you truly mean to discard): prefix ALLOW_DESTRUCTIVE_GIT=1" >&2
  exit 2
fi

echo "$input"
exit 0
