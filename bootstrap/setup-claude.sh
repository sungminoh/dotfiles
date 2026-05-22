#!/usr/bin/env bash
# Bootstrap Claude Code on a fresh machine.
#
# Assumes ../install.py has already symlinked ~/.claude → claude/.
# This script installs external tools that aren't auto-installed by
# Claude Code's marketplace mechanism.
#
# Marketplaces declared in claude/settings.json → extraKnownMarketplaces
# are picked up automatically on next Claude Code launch. This script
# only handles tools installed by side-channel methods (e.g., raw git clone).

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"

log() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[bootstrap]\033[0m %s\n' "$*"; }

if [ ! -L "${CLAUDE_DIR}" ] && [ ! -d "${CLAUDE_DIR}" ]; then
  warn "${CLAUDE_DIR} not found. Run ../install.py first."
  exit 1
fi

mkdir -p "${SKILLS_DIR}"

# gstack — installed via raw git clone + ./setup (not a marketplace)
if [ ! -d "${SKILLS_DIR}/gstack/.git" ]; then
  log "Installing gstack..."
  git clone --single-branch --depth 1 \
    https://github.com/garrytan/gstack.git \
    "${SKILLS_DIR}/gstack"
  ( cd "${SKILLS_DIR}/gstack" && ./setup )
else
  log "gstack already installed (skip)"
fi

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

log "Done. Marketplaces (omc, etc.) auto-install on next Claude Code launch."
log "Verify with: claude /omc-help  or  claude /gstack"
