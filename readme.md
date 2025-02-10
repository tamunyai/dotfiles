# Dotfiles

This repository contains my dotfiles for a consistent development setup across various environments.

## Requirements

Before installing, ensure you have the following:

- **Git**.
- [**GNU Stow**](https://www.gnu.org/software/stow/).

You can install these using your package manager:

- **Ubuntu/Debian**: `sudo apt-get install git stow`
- **Fedora**: `sudo dnf install git stow`
- **macOS**: `brew install git stow`

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/tamunyai/dotfiles.git ~/.dotfiles
   ```

2. **Run the Installation Script**

   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

   This script will:

   - Install necessary dependencies (like `zsh`, `fzf`, `zoxide`, `neovim`, `eza`, etc.).
   - Change your default shell to `zsh` if it's not already.
   - Install `nodejs` and `npm` via `nvm` (Node Version Manager).
   - Install `neovim` and set up other development tools.

3. **Install Fonts for Better Rendering (Optional)**

   To install fonts (like JetBrains Mono) for better rendering in your terminal:

   ```bash
   cd ~/.dotfiles
   ./install-fonts.sh
   ```

   This script will:

   - Detect your operating system and set the correct font directory.
   - Download and install Nerd Fonts (e.g., JetBrains Mono).

4. **Create Symlinks Manually (Optional)**

   If you'd prefer to manually symlink the files without running the script:

   ```bash
   stow .
   ```

   This command will automatically symlink the configuration files from the `.dotfiles` directory to their appropriate locations in your home directory.

## Customization

If you need to customize any of the configurations, you can edit the files in the `.dotfiles` directory directly. After making changes, use `stow` again to apply the updates.

## License

This repository is licensed under the [MIT License](license)
