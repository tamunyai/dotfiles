#!/bin/bash

DOTFILES="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)"
source "$DOTFILES/install/utils.sh"

src="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

install "zsh"
link_file "$src/rc" "$HOME/.zshrc"

# Check if the current shell is Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

# Create .env.sh file if it doesn't exist
create_env_file() {
    if [ -f "$HOME/.env.sh" ]; then
        success "$HOME/.env.sh file already exists, skipping"

    else
        echo "export DOTFILES='$DOTFILES'" >"$HOME/.env.sh"
        echo "export ZSH='$DOTFILES/zsh'" >>"$HOME/.env.sh"

        success 'created ~/.env.sh'
    fi
}

create_env_file

# Restart the shell to apply changes
