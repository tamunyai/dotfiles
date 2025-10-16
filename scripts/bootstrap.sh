#!/usr/bin/env bash
#
# sets up configurations for my preferred development environment.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- INSTALLATION & CONFIGURATION --------------------------------------------

DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# detect operating system
platform=$(detect_platform)
info "Detected platform: $platform"

if [ "$platform" != "Git Bash" ]; then
	# array of packages to install
	packages=("zsh" "fzf" "curl" "git" "gcc" "g++" "python3" "neovim")

	# install packages in the array
	for package in "${packages[@]}"; do
		install "$package" "$platform"
	done

	# change default shell to Zsh if necessary
	if [ "$SHELL" != "$(command -v zsh)" ]; then
		sudo chsh -s "$(command -v zsh)" "$USER" || fail "Failed to change default shell to zsh."
	fi

	# install `zoxide`, a smarter `cd` command
	if ! command_exists "zoxide"; then
		info "Installing zoxide (smarter cd command)..."

		zoxide_url="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh"
		curl -fsSL "$zoxide_url" | sh || fail "Zoxide installation failed."
		success "zoxide installed successfully."
	fi

	# install `eza`, an improved version of `ls`
	if ! command_exists "eza"; then
		info "Installing eza (modern ls alternative)..."

		if [ "$platform" = "Linux" ]; then
			tmp_dir=$(mktemp -d)
			eza_url="https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz"

			wget -qO- "$eza_url" | tar -xz -C "$tmp_dir" || fail "Failed to extract eza."
			sudo install -m 755 "$tmp_dir/eza" /usr/local/bin/eza || fail "Failed to install eza."
			rm -rf "$tmp_dir"

		elif ["$platform" = "macOS"] && command_exists "brew"; then
			brew install eza || fail "Failed to install eza."
		fi

		success "eza installed successfully."
	fi

	# install `starship` prompt
	if ! command_exists "starship"; then
		info "Installing Starship prompt..."

		starship_url="https://starship.rs/install.sh"
		curl -fsSL "$starship_url" | sh -s -- -y || fail "Starship installation failed."
		success "Starship installed successfully."
	fi
fi

# --- NVM / NODE --------------------------------------------------------------

NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"

# install NVM (node version manager)
if ! { [ -d "$NVM_DIR" ] && [ -s "$NVM_DIR/nvm.sh" ]; }; then
	nvm_version='0.40.3'
	nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh"

	info "Installing NVM (Node Version Manager)... v${nvm_version}"
	curl -fsSL "$nvm_url" | bash || fail "NVM installation failed."
	success "NVM installed successfully."
fi

# load NVM (for both new and existing installs)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# install Node.js and npm if NVM exists but Node/npm don't
if { [ -d "$NVM_DIR" ] && [ -s "$NVM_DIR/nvm.sh" ]; } && \
	 { ! command_exists "node" || ! command_exists "npm"; }; then
	info "Installing Node.js and npm via NVM..."
	nvm install --lts && nvm use --lts || fail "Failed to install or activate Node.js via NVM."
	success "Node.js and npm (LTS) installed and activated via NVM."
fi

# --- DOTFILES SYMLINKING -----------------------------------------------------

info "Linking all dotfiles from $DOTFILES_DIR to $HOME..."

SOURCE_DIR="$DOTFILES_DIR/home"
IGNORE_FILE="$DOTFILES_DIR/.dotignore"

# read ignore list from file (ignore blank/comment lines)
if [[ -f "$IGNORE_FILE" ]]; then
	mapfile -t IGNORE_LIST < <(grep -vE '^\s*(#|$)' "$IGNORE_FILE" | sed 's/\r$//')

else
	IGNORE_LIST=()
fi

# add platform-specific ignores
if [ "$platform" = "Git Bash" ]; then
	# ignore Zsh + Neovim configs on Git Bash
	IGNORE_LIST+=(".zshrc" ".config/nvim/")

else
	# ignore Bash + Vim configs on Linux/macOS
	IGNORE_LIST+=(".bashrc" ".vimrc")
fi

# recursively find all files in DOTFILES_DIR/home
find "$SOURCE_DIR" -type f | while read -r src_path; do
	# fix CRLF if needed
	fix_crlf_if_needed "$src_path"

	# compute the relative path from DOTFILES_DIR
	rel_path="${src_path#$SOURCE_DIR/}"

	# skip ignored files
	should_ignore "$rel_path" "${IGNORE_LIST[@]}" && continue

	# ensure the destination directory exists
	dest_path="$HOME/$rel_path"
	mkdir -p "$(dirname "$dest_path")"

	# backup existing non-symlink files
	if [[ -e "$dest_path" && ! -L "$dest_path" ]]; then
		info "'$dest_path' exists (not a symlink), backing up."
		mv "$dest_path" "$dest_path.bak"
	fi

	# create symlink
	ln -sf "$src_path" "$dest_path"
	success "Linked '$dest_path' -> '$src_path'"
done

# final success message
success "Setup complete!"
echo ''
