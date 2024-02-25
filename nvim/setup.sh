#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)"
source "$DOTFILES/install/utils.sh"

src="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

install_dependencies "git" "gcc" "g++" "python3-venv" "npm" "unzip"

# sudo add-apt-repository --yes ppa:neovim-ppa/unstable
install "neovim"
link_file "$src" "$HOME/.config/"
