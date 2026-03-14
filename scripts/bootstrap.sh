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
  # array of packages to install
  packages=("zsh" "curl" "git" "gcc" "g++")

  # install packages in the array
  for package in "${packages[@]}"; do
    install "$package" "$platform"
  done

  # change default shell to Zsh if necessary
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    sudo chsh -s "$(command -v zsh)" "$USER" || fail "Failed to change default shell to zsh."
  fi

  # install `mise` for universal language management
  if ! command_exists "mise"; then
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
  if ! command_exists "zoxide"; then
    zoxide_url="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh"

    info "Installing zoxide (smarter cd command)..."
    curl -fsSL "$zoxide_url" | sh -s -- --bin-dir "$LOCAL_BIN" || fail "Zoxide installation failed."
    success "zoxide installed successfully."
  fi

  # install `starship` prompt
  if ! command_exists "starship"; then
    starship_url="https://starship.rs/install.sh"

    info "Installing Starship prompt..."
    curl -fsSL "$starship_url" | sh -s -- -y --bin-dir "$LOCAL_BIN" || fail "Starship installation failed."
    success "Starship installed successfully."
  fi
fi

# --- DOTFILES SYMLINKING -----------------------------------------------------

info "Linking all dotfiles from $DOTFILES_DIR to $HOME..."

SOURCE_DIR="$DOTFILES_DIR/home"

# recursively find all files in DOTFILES_DIR/home
find "$SOURCE_DIR" -type f | while read -r src_path; do
  # fix CRLF if needed
  fix_crlf_if_needed "$src_path"

  # compute the relative path from DOTFILES_DIR
  rel_path="${src_path#$SOURCE_DIR/}"

  # ensure the destination directory exists
  dest_path="$HOME/$rel_path"
  mkdir -p "$(dirname "$dest_path")"

  # backup existing non-symlink files
  if [[ -e "$dest_path" && ! -L "$dest_path" ]]; then
    info "'$dest_path' exists (not a symlink), backing up."
    mv "$dest_path" "$dest_path.bak.$(date +%s)" || fail "Failed to backup $dest_path"
  fi

  # create symlink
  ln -sf "$src_path" "$dest_path"
  success "Linked '$dest_path' -> '$src_path'"
done

# final success message
success "Setup complete!"
echo ''
