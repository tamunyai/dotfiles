#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)"
source "$DOTFILES/install/utils.sh"

src="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

install "git"
link_file "$src/config" "$HOME/.gitconfig"
link_file "$src/ignore-global" "$HOME/.gitignore-global"
link_file "$src/message" "$HOME/.gitmessage"
