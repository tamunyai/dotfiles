# Dotfiles

This repository contains my dotfiles for a consistent development setup across various environments.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/tamunyai/dotfiles.git ~/.dotfiles
   ```

2. **Run the Bootstrap Script**

   ```bash
   cd ~/.dotfiles/scripts
   ./bootstrap.sh
   ```

   This script will:

   - Install necessary dependencies (like `zoxide`, `eza`, etc.).
   - Install `nodejs` and `npm` via `nvm` (Node Version Manager).
   - Link all dotfiles from `home/` to `$HOME`, skipping any files or directories listed in `.dotignore`.
   - Automatically back up existing files in `$HOME` that would be overwritten by symlinks with a `.bak` extension.

3. **Install Fonts for Better Rendering (Optional)**

   To install fonts (like JetBrains Mono) for better rendering in your terminal:

   ```bash
   cd ~/.dotfiles
   ./install-fonts.sh
   ```

   This script will:

   - Detect your operating system and set the correct font directory.
   - Download and install Nerd Fonts (e.g., JetBrains Mono).

4. Git/SSH Setup (Optional)

   ```bash
   cd ~/.dotfiles/scripts
   ./setup-git-ssh.sh
   ```

   This script will:

   - Configure Git credentials and SSH keys for your environment.

## Ignore List

You can define files or directories that should be excluded from symlinking by creating a `.dotignore` file in the root of the repository (`~/.dotfiles/.dotignore`).

- Paths should be relative to `home/`.
- Example `.dotignore`:

```sh
# ignore directories
.config/
scripts/

# ignore files
.zshrc
readme.md
```

- Blank lines and lines starting with `#` are ignored.
- The bootstrap script will automatically skip any paths listed here.

## Customization

To customize configurations, edit the files in the `home/` directory. Changes will be reflected after re-running the bootstrap script.

## License

This repository is licensed under the [MIT License](license)
