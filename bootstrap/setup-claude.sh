#!/usr/bin/env bash
# Bootstrap Claude Code on a fresh machine.
#
# Run after ../install.py has symlinked the claude/ entries into ~/.claude/.
# Plugins and marketplaces in claude/settings.json install on the next
# Claude Code launch; this script covers what settings.json cannot:
# user-scope MCP servers and the ~/.zshrc.secret template.

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"

log() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[bootstrap]\033[0m %s\n' "$*"; }

if [ ! -d "${CLAUDE_DIR}" ]; then
  warn "${CLAUDE_DIR} not found. Run ../install.py first."
  exit 1
fi

# User-scope MCP servers live in ~/.claude.json, which Claude Code rewrites
# constantly (state, tokens), so it can't be symlinked. Register them here.
add_mcp() {
  local name=$1; shift
  if ! command -v claude >/dev/null 2>&1; then
    warn "claude CLI not found; skipping MCP server '${name}'"
  elif claude mcp get "${name}" >/dev/null 2>&1; then
    log "MCP server '${name}' already registered (skip)"
  else
    log "Registering MCP server '${name}'"
    claude mcp add --scope user "${name}" -- "$@"
  fi
}
add_mcp context7 npx -y @upstash/context7-mcp

# Local secrets file template
SECRET_FILE="${HOME}/.zshrc.secret"
if [ ! -f "${SECRET_FILE}" ]; then
  log "Creating ${SECRET_FILE} (fill in your tokens)"
  cat > "${SECRET_FILE}" <<'EOF'
# Per-machine secret exports — sourced by zshrc, gitignored.
# Examples:
# export SUPABASE_ACCESS_TOKEN=...
# export OPENAI_API_KEY=...
EOF
  chmod 600 "${SECRET_FILE}"
else
  log "${SECRET_FILE} exists (skip)"
fi

log "Done. Marketplaces auto-install on next Claude Code launch."
