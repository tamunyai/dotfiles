#!/usr/bin/env bash
#
# deploys dotfiles using stow or manual linking fallback.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- DEPLOYMENT --------------------------------------------------------------

DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
platform=$(detect_platform)

info "Handling example configuration files..."

# find all .example files across all root-level packages
find "$DOTFILES_DIR" -maxdepth 2 -type f -name "*.example" -not -path "*/.*" -not -path "$DOTFILES_DIR/scripts/*" | while read -r example_path; do
  target_path="${example_path%.example}"
  
  if [ ! -f "$target_path" ]; then
    info "Creating '$(basename "$target_path")' from example..."
    cp "$example_path" "$target_path"
    success "Created '$target_path'"
  fi
done

# identify root-level stow packages
packages=()
while IFS= read -r dir; do
  pkg=$(basename "$dir")

  case "$pkg" in
    scripts|.*) continue ;;
  esac

  packages+=("$pkg")
done < <(find "$DOTFILES_DIR" -maxdepth 1 -type d -not -path "$DOTFILES_DIR")

info "Deploying ${#packages[@]} packages: ${packages[*]}"

for package in "${packages[@]}"; do
  info "Processing package: $package"
  PACKAGE_SOURCE="$DOTFILES_DIR/$package"

  # ensure Unix line endings
  find "$PACKAGE_SOURCE" -type f -not -name "*.example" | while read -r src_path; do
    fix_crlf_if_needed "$src_path"
  done

  # backup existing non-symlink files
  find "$PACKAGE_SOURCE" -type f -not -name "*.example" | while read -r src_path; do
    rel_path="${src_path#$PACKAGE_SOURCE/}"
    dest_path="$HOME/$rel_path"

    if [[ -e "$dest_path" && ! -L "$dest_path" ]]; then
      info "'$dest_path' exists (not a symlink), backing up."
      mv "$dest_path" "$dest_path.bak.$(date +%s)" || fail "Failed to backup $dest_path"
    fi
  done

  # use stow on compatible platforms
  if [ "$platform" != "Git Bash" ] && command -v stow >/dev/null 2>&1; then
    info "Using stow to link package: $package"
    stow --target="$HOME" --dir="$DOTFILES_DIR" "$package" || fail "Stow failed for package $package."
    success "Stowed '$package'"

  else
    # fallback for Git Bash or systems without stow
    info "Falling back to manual linking for: $package"
    find "$PACKAGE_SOURCE" -type f -not -name "*.example" | while read -r src_path; do
      rel_path="${src_path#$PACKAGE_SOURCE/}"
      dest_path="$HOME/$rel_path"
      
      mkdir -p "$(dirname "$dest_path")"
      ln -sf "$src_path" "$dest_path"
      success "Linked '$dest_path' -> '$src_path'"
    done
  fi
done

success "Deployment complete."
