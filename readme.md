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

4. **Install Fonts (Optional)**

   ```bash
   cd ~/.dotfiles/scripts && ./install-fonts.sh
   ```

   Downloads and installs Nerd Fonts (JetBrains Mono by default) into the correct directory for your OS.

5. **Set up SSH for GitHub (Optional)**

   ```bash
   cd ~/.dotfiles/scripts && ./setup-git-ssh.sh
   ```

   Generates an `ed25519` SSH key if one doesn't exist and prints the public key to add to GitHub.

## Customization

Do not edit tracked config files for machine-specific settings. Instead, create or edit:

```bash
~/.config/shell/localrc
```

This file is sourced last by both Bash and Zsh. Use it for secrets, machine-specific env vars, personal aliases, and local overrides. It is **not committed to this repository**.

## License

This repository is licensed under the [MIT License](license)
