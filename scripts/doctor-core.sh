#!/usr/bin/env bash
#
# diagnostic tool for validating the dotfiles setup.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- DIAGNOSTICS -------------------------------------------------------------

DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
platform=$(detect_platform)
info "Running diagnostics for platform: $platform"

# check for required tools
tools=("git" "curl" "stow")
if [ "$platform" == "Git Bash" ]; then
  tools=("git" "curl")
fi

for tool in "${tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    user "Required tool '$tool' is MISSING."
    
  else
    success "Tool '$tool' found."
  fi
done

# check stow package discovery
packages=()
while IFS= read -r dir; do
  pkg=$(basename "$dir")

  case "$pkg" in
    scripts|.*) continue ;;
  esac

  packages+=("$pkg")
done < <(find "$DOTFILES_DIR" -maxdepth 1 -type d -not -path "$DOTFILES_DIR")

if [ ${#packages[@]} -eq 0 ]; then
  fail "No stow packages discovered in $DOTFILES_DIR."

else
  success "Discovered ${#packages[@]} packages: ${packages[*]}"
fi

# check for scripts/ being treated as a package (should not happen)
if [[ " ${packages[*]} " =~ " scripts " ]]; then
  fail "CRITICAL: 'scripts' directory was incorrectly identified as a stow package."

else
  success "Utility folders ('scripts/') correctly excluded from packages."
fi

# optional: dry-run stow check
if [ "$platform" != "Git Bash" ] && command -v stow >/dev/null 2>&1; then
  info "Performing dry-run stow check for each package..."

  for package in "${packages[@]}"; do
    if stow --target="$HOME" --dir="$DOTFILES_DIR" -n "$package" >/dev/null 2>&1; then
      success "Package '$package' is ready to stow (clean dry-run)."
  
    else
      user "Package '$package' has potential stow conflicts (dry-run failed)."
    fi
  done
fi

success "Diagnostics complete."
