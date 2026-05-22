#!/usr/bin/env bash
# Full macOS setup — runs defaults tweaks then installs packages.
# Run after ../install.py has symlinked the dotfiles.

set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)"

"${DIR}/etc/macos-setup.sh" all
"${DIR}/etc/macos-setup.sh" sungmin
"${DIR}/bootstrap/install-packages.sh"
"${DIR}/bootstrap/setup-claude.sh"

echo "[setup-macos] All done. Open a new shell to pick up env changes."
