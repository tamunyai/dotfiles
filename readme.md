# Dotfiles

This repository contains my dotfiles for a consistent development setup across various environments.

## Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/tamunyai/dotfiles.git ~/.dotfiles
   ```

2. **Run the bootstrap script**

   ```bash
   cd ~/.dotfiles && ./bootstrap.sh
   ```

   This is the recommended entrypoint for a full machine setup. It orchestrates dependency installation, example configuration materialization, and dotfile deployment using GNU Stow (with a manual fallback for Git Bash).

3. **Entrypoints**

   The repository provides three main entrypoints at the root:
   - `./bootstrap.sh`: Full first-time setup (Install + Deploy).
   - `./install.sh`: Installs core dependencies and tools (`git`, `stow`, `mise`, etc.) without linking dotfiles.
   - `./doctor.sh`: Runs diagnostics to verify your setup, tool existence, and stow package health.

   Internal implementation details and helper scripts are located in the `scripts/` directory.

4. **Install Tools via Mise** (Linux/macOS)

   ```bash
   mise install
   ```

   Installs all runtimes and CLI tools pinned in `.config/mise/config.toml`.

5. **Install Fonts (Optional)**

   ```bash
   cd ~/.dotfiles/scripts && ./install-fonts.sh
   ```

   Downloads and installs Nerd Fonts (JetBrains Mono by default) into the correct directory for your OS.

6. **Set up SSH for GitHub (Optional)**

   ```bash
   cd ~/.dotfiles/scripts && ./setup-git-ssh.sh
   ```

   Generates an `ed25519` SSH key if one doesn't exist and prints the public key to add to GitHub.

## Package Overview

This repository manages configurations for the following tools:

- **Terminal**: `ghostty`
- **Shell**: `bash`, `zsh`
- **Editors**: `nvim`, `vim`
- **Utilities**: `git`, `starship`, `mise`, `curl`

## Package Documentation

This repository uses a decentralized documentation convention. Each package may include a `notes.md` file for post-install setup, machine-local override instructions, and platform-specific tweaks (e.g., GNOME terminal settings).

Please refer to the `notes.md` within individual package directories for detailed operational instructions.

## License

This repository is licensed under the [MIT License](license)
