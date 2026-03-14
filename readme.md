# Dotfiles

This repository contains my dotfiles for a consistent development setup across various environments.

## Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/tamunyai/dotfiles.git ~/.dotfiles
   ```

2. **Run the bootstrap script**

   ```bash
   cd ~/.dotfiles/scripts && ./bootstrap.sh
   ```

   Installs base dependencies and [`mise`](https://mise.jdx.dev) (for tool management), then symlinks everything in `home/` to `$HOME`, backing up any conflicts as `.bak.<timestamp>`.

3. **Install Tools via Mise** (Linux/macOS)

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

Do not edit tracked config files for machine-specific settings. Instead:

```bash
cp ~/.localrc.example ~/.localrc
```

`.localrc` is sourced last by both Bash and Zsh. Use it for secrets, machine-specific env vars, personal aliases, and local overrides. It is **not committed to this repository**.

## License

This repository is licensed under the [MIT License](license)
