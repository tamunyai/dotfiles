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

- Install necessary dependencies (like Zsh, fzf, Zoxide, Starship, Neovim, eza, etc.).
- Change your default shell to Zsh if it's not already.
- Install Node.js and npm via NVM (Node Version Manager).
- Install Neovim and set up other development tools.
- Symlink the configuration files from the `.dotfiles` directory to their appropriate locations using `stow`.

3. **Create Symlinks Manually (Optional)**

If you'd prefer to manually symlink the files without running the script:

```bash
stow .
```

This command will automatically symlink the configuration files from the `.dotfiles` directory to their appropriate locations in your home directory.

## Customization

If you need to customize any of the configurations, you can edit the files in the `.dotfiles` directory directly. After making changes, use `stow` again to apply the updates.

## License

This repository is licensed under the [MIT License](LICENSE).
