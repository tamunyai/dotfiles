#!/usr/bin/env bash
#
# full machine setup entrypoint.

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. install core dependencies
"${SCRIPT_DIR}/scripts/install-core.sh"

# 2. deploy dotfiles
"${SCRIPT_DIR}/scripts/deploy-dotfiles.sh"

echo ""
echo "Setup complete! Please restart your terminal."
