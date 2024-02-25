#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)"
source "$DOTFILES/install/utils.sh"

src="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

# install starship
curl -sS https://starship.rs/install.sh | sh
link_file "$src/starship.toml" "$HOME/.config/"
