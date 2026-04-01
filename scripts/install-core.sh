#!/usr/bin/env bash
#
# installs dependencies and core tools.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- INSTALLATION ------------------------------------------------------------

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
  mkdir -p "$LOCAL_BIN" || fail "Failed to create $LOCAL_BIN"

  # install `zoxide`
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

success "Core installation complete."
