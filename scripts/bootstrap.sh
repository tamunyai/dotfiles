#!/usr/bin/env bash
#
# sets up configurations for my preferred development environment.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- INSTALLATION & CONFIGURATION --------------------------------------------

DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# detect operating system
platform=$(detect_platform)
info "Detected platform: $platform"

if [ "$platform" != "Git Bash" ]; then
  # update package manager once
  info "Updating package manager..."
  if command -v "apt-get" >/dev/null 2>&1; then
    sudo apt-get update -y

  elif command -v "dnf" >/dev/null 2>&1; then
    sudo dnf makecache -y

  # elif command -v "yum" >/dev/null 2>&1; then
  # 	sudo yum makecache -y

  # elif command -v "pacman" >/dev/null 2>&1; then
  # 	sudo pacman -Sy --noconfirm

  # elif command -v "zypper" >/dev/null 2>&1; then
  # 	sudo zypper refresh
  fi

  # array of packages to install
  packages=("zsh" "curl" "git" "gcc" "g++" "stow")

  # install packages in the array
  for package in "${packages[@]}"; do
    install "$package" "$platform"
  done

  # change default shell to Zsh if necessary
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    sudo chsh -s "$(command -v zsh)" "$USER" || fail "Failed to change default shell to zsh."
  fi

  # install `mise` for universal language management
  if ! command -v "mise" >/dev/null 2>&1; then
    mise_url="https://mise.run"

    info "Installing mise (universal language manager)..."
    curl -fsSL "$mise_url" | sh || fail "Mise installation failed."
    success "mise installed successfully."
  fi

else
  # Git Bash path
  LOCAL_BIN="$HOME/.local/bin"

  # ensure the local bin directory exists
  mkdir -p "$LOCAL_BIN" || fail "Failed to create $LOCAL_BIN"

  # install `zoxide`, a smarter `cd` command
  if ! command -v "zoxide" >/dev/null 2>&1; then
    zoxide_url="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh"

    info "Installing zoxide (smarter cd command)..."
    curl -fsSL "$zoxide_url" | sh -s -- --bin-dir "$LOCAL_BIN" || fail "Zoxide installation failed."
    success "zoxide installed successfully."
  fi

  # install `starship` prompt
  if ! command -v "starship" >/dev/null 2>&1; then
    starship_url="https://starship.rs/install.sh"

    info "Installing Starship prompt..."
    curl -fsSL "$starship_url" | sh -s -- -y --bin-dir "$LOCAL_BIN" || fail "Starship installation failed."
    success "Starship installed successfully."
  fi
fi

# --- DOTFILES SYMLINKING -----------------------------------------------------

info "Handling example configuration files..."

# find all .example files across all root-level packages and create the real ones if they don't exist
# we exclude hidden directories and known infrastructure folders
find "$DOTFILES_DIR" -maxdepth 2 -type f -name "*.example" -not -path "*/.*" -not -path "$DOTFILES_DIR/scripts/*" | while read -r example_path; do
  target_path="${example_path%.example}"

  if [ ! -f "$target_path" ]; then
    info "Creating '$(basename "$target_path")' from example..."

    cp "$example_path" "$target_path"
    success "Created '$target_path'"
  fi
done

# identify root-level stow packages (directories that are not ignored)
packages=()
while IFS= read -r dir; do
  pkg=$(basename "$dir")

  # skip hidden directories and infrastructure folders
  case "$pkg" in
    scripts|.*) continue ;;
  esac
  
  packages+=("$pkg")

done < <(find "$DOTFILES_DIR" -maxdepth 1 -type d -not -path "$DOTFILES_DIR")

info "Linking dotfiles from ${#packages[@]} packages: ${packages[*]}"

for package in "${packages[@]}"; do
  info "Processing package: $package"
  PACKAGE_SOURCE="$DOTFILES_DIR/$package"

  # ensure all files in the package have Unix line endings (idempotent)
  find "$PACKAGE_SOURCE" -type f | while read -r src_path; do
    fix_crlf_if_needed "$src_path"
  done

  # backup existing non-symlink files to ensure stow doesn't conflict
  # this preserves the rollback-friendly behavior for new systems
  find "$PACKAGE_SOURCE" -type f | while read -r src_path; do
    rel_path="${src_path#$PACKAGE_SOURCE/}"
    dest_path="$HOME/$rel_path"

    if [[ -e "$dest_path" && ! -L "$dest_path" ]]; then
      info "'$dest_path' exists (not a symlink), backing up."
      mv "$dest_path" "$dest_path.bak.$(date +%s)" || fail "Failed to backup $dest_path"
    fi
  done

  # use stow on compatible platforms (Linux/macOS)
  if [ "$platform" != "Git Bash" ] && command -v stow >/dev/null 2>&1; then
    info "Using stow to link package: $package"

    # stow links all files from package/ into the target directory ($HOME)
    # -t: target directory, -d: source directory containing package
    stow --target="$HOME" --dir="$DOTFILES_DIR" "$package" || fail "Stow failed for package $package."
    success "Stowed '$package'"

  else
    # fallback for Git Bash where stow might not be available or symlinks are problematic.
    info "Git Bash detected or stow not found, falling back to manual linking for: $package"

    find "$PACKAGE_SOURCE" -type f | while read -r src_path; do
      rel_path="${src_path#$PACKAGE_SOURCE/}"
      dest_path="$HOME/$rel_path"

      mkdir -p "$(dirname "$dest_path")"
      ln -sf "$src_path" "$dest_path"
      success "Linked '$dest_path' -> '$src_path'"
    done
  fi
done

# final success message
success "Setup complete! Please restart your terminal to apply changes."
echo ''
