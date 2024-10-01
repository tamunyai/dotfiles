#!/bin/bash

sudo -v

# --- FUNCTIONS ---------------------------------------------------------------

# display informational messages
# usage: info <message>
function info() {
	printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

# display user prompts or queries
# usage: user <question>
function user() {
	printf "\r  [ \033[0;33m??\033[0m ] %s\n" "$1"
}

# display success messages
# usage: success <message>
function success() {
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

# display failure messages and exit the script
# usage: fail <message>
function fail() {
	printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
	echo ''
	exit
}

# checks if a command is available in the system.
# usage: command_exists <command_name>
function command_exists() {
	if [ -x "$(command -v "$1")" ]; then
		return 0

	elif [ -x "$(command -v dpkg-query)" ]; then
		dpkg-query -W --showformat='${Status}\n' "$1" 2>/dev/null | grep -q "install ok installed"

	else
		return 1
	fi
}

# install a package using the appropriate package manager
# usage: install <package>
function install() {
	local package=$1

	if command_exists "$package"; then
		success "$package already installed."

	else
		info "installing ${package}.."

		if [ -x "$(command -v apt-get)" ]; then
			sudo apt-get install -y "$package"

		elif [ -x "$(command -v yum)" ]; then
			sudo yum install -y "$package"

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S --noconfirm "$package"

		elif [ -x "$(command -v zypper)" ]; then
			sudo zypper install -y "$package"

		elif [ -x "$(command -v brew)" ]; then
			brew install "$package"

		else
			user "unsupported package manager. please install $package manually."
		fi
	fi
}

# installs a list of package dependencies
# usage: install_dependencies <package_list>
function install_dependencies() {
	local package_list=("$@") # Get the list of packages passed as arguments

	for package in "${package_list[@]}"; do
		! command_exists "$package" && install "$package"
	done
}

# --- ZSH INSTALLATION & CONFIGURATION ----------------------------------------

# Install Zsh and set it as the default shell if necessary
install "zsh"

if [ "$SHELL" != "$(which zsh)" ]; then
	sudo chsh -s "$(which zsh)" "$USER" || fail "Failed to change default shell to zsh."
fi

# Install fzf and zoxide (a smarter cd command)
install "fzf"

if ! command_exists "zoxide"; then
	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh || fail "Zoxide installation failed."
fi

# Install `eza`, an improved version of `ls`
if ! command_exists "eza"; then
	info "Installing eza (modern ls alternative)..."
	wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz || fail "Failed to download eza."
	sudo chmod +x eza || fail "Failed to make eza executable."
	sudo chown root:root eza || fail "Failed to set ownership for eza."
	sudo mv eza /usr/local/bin/eza || fail "Failed to move eza to /usr/local/bin."
	success "eza installed."
else
	success "eza already installed."
fi

# --- STARSHIP INSTALLATION ---------------------------------------------------

# Ensure curl is installed and install Starship prompt
install "curl"

if ! command_exists "starship"; then
	curl -sS https://starship.rs/install.sh | sh -s --y || fail "Starship installation failed."
fi

# --- NVM, NODE, AND NPM INSTALLATION -----------------------------------------

# Install NVM (Node Version Manager) if not already installed
if ! command_exists "nvm"; then
	info "Installing NVM (Node Version Manager)..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash || fail "NVM installation failed."

	# Load NVM immediately in this session
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
	success "NVM already installed."
fi

# Install Node.js and npm via nvm
if ! command_exists "npm"; then
	info "Installing Node.js and npm via NVM..."
	nvm install node || fail "Failed to install Node.js"
	nvm use node || fail "Failed to switch to Node.js"

	# Install global npm packages
	npm install --global @types/react || fail "Failed to install npm packages."
	success "npm installed via NVM."
else
	success "npm already installed."
fi

# --- NVIM INSTALLATION -------------------------------------------------------

# Install required dependencies for Neovim
install_dependencies "git" "gcc" "g++" "python3-venv" "unzip" "xclip"

# Add Neovim PPA and install Neovim
sudo add-apt-repository --yes ppa:neovim-ppa/unstable
sudo apt-get update -y
install "neovim"

# --- STOW AND DOTFILES SETUP -------------------------------------------------

# Root directory for dotfiles
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the dotfiles parent directory
cd "$DOTFILES/.."

# Stow the package, assuming the package name is the last directory in DOTFILES
PACKAGE_NAME="$(basename "$DOTFILES")"

# Install GNU Stow and link dotfiles
install "stow"

# Check if PACKAGE_NAME is not a subdirectory of HOME
if [[ ! -d "$HOME/$PACKAGE_NAME" ]]; then
	stow "$PACKAGE_NAME" --target "$HOME" || fail "Stow failed to link dotfiles."
else
	stow "$PACKAGE_NAME" || fail "Stow failed to link dotfiles."
fi

# Final success message
success "Setup complete!"
