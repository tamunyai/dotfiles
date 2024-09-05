# Neovim

Instructions for setting up Neovim using the configuration files from this repository.

## Requirements

Before setting up Neovim, ensure you have the following installed:

- **Git**.
- **Python 3**.
- **Node.js**.

You can install these using your package manager:

- **Ubuntu/Debian**: `sudo apt-get install git python3-venv npm`
- **Fedora**: `sudo dnf install git python3-venv npm`
- **macOS**: `brew install git python3 node`

## Installation

1. **Stow the Dotfiles**

```bash
git clone https://github.com/AmonMunyai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

2. **Install Neovim**

```bash
sudo add-apt-repository --yes ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```
## Customization

To customize your Neovim setup, edit the files in the `~/.dotfiles/.config/nvim` directory. After making changes, you may need to restart Neovim to apply updates.
