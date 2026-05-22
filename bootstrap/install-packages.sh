#!/usr/bin/env bash
# Personal Homebrew packages, pyenv, Quick Look plugins.
# Idempotent: re-running skips what's already installed.
#
# Pair with ../etc/macos-setup.sh for `defaults write` tweaks.

set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "macOS only" >&2; exit 1
fi
if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first: https://brew.sh" >&2; exit 1
fi

log() { printf '\033[1;34m[packages]\033[0m %s\n' "$*"; }

# Python via pyenv
PYTHON_VERSION="3.14.2"
log "pyenv + Python ${PYTHON_VERSION}"
brew install pyenv pyenv-virtualenv
pyenv install -s "${PYTHON_VERSION}"
pyenv global "${PYTHON_VERSION}"
pyenv exec pip install --upgrade pip virtualenv

# CLI tools
log "CLI tools"
brew install bitwarden-cli

# Quick Look plugins — https://github.com/sindresorhus/quick-look-plugins
log "Quick Look plugins"
brew install --cask \
  qlcolorcode qlstephen qlmarkdown quicklook-json \
  qlimagesize suspicious-package apparency quicklookase qlvideo

log "Done."
