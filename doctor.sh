#!/usr/bin/env bash
#
# check dotfiles setup and diagnostics.

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${SCRIPT_DIR}/scripts/doctor-core.sh"
