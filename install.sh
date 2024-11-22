#!/usr/bin/env bash

sudo -v

# --- FUNCTIONS ---------------------------------------------------------------

# display informational messages
# usage: info <message>
function info() {
	printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

# display user prompts or queries
# usage: user <message>
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
	exit 1
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

		if command_exists apt-get; then
			sudo apt-get install -y "$package"

		elif command_exists yum; then
			sudo yum install -y "$package"

		elif command_exists dnf; then
			sudo dnf install -y "$package"

		elif command_exists pacman; then
			sudo pacman -S --noconfirm "$package"

		elif command_exists zypper; then
			sudo zypper install -y "$package"

		elif command_exists brew; then
			brew install "$package"

		else
			fail "Unsupported package manager. Please install $package manually."
		fi
	fi
}

# --- INSTALLATION & CONFIGURATION --------------------------------------------

sudo apt update -y

# Array of packages to install
packages=(
	"zsh"
	"fzf"
	"curl"
	"git"
	"gcc"
	"g++"
	"python3-venv"
	"unzip"
	"xclip"
	"ripgrep"
	"neovim" # sudo add-apt-repository --yes ppa:neovim-ppa/unstable
	"stow"
	# "openjdk-17-jdk"
	# "openjdk-17-jre"
)

# Install packages in the array
for package in "${packages[@]}"; do
	install "$package"
done

# Change default shell to Zsh if necessary
if [ "$SHELL" != "$(which zsh)" ]; then
	sudo chsh -s "$(which zsh)" "$USER" || fail "Failed to change default shell to zsh."
fi

# Install zoxide
if ! command_exists "zoxide"; then
	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh || fail "Zoxide installation failed."
fi

# Install `eza`, an improved version of `ls`
if ! command_exists "eza"; then
	info "Installing eza (modern ls alternative)..."
	wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar -xz || fail "Failed to download eza."
	sudo chmod +x eza || fail "Failed to make eza executable."
	sudo chown root:root eza || fail "Failed to set ownership for eza."
	sudo mv eza /usr/local/bin/eza || fail "Failed to move eza to /usr/local/bin."
	success "eza installed."
else
	success "eza already installed."
fi

# Install NVM, Node.js, and npm
if ! command_exists "nvm"; then
	info "Installing NVM (Node Version Manager)..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash || fail "NVM installation failed."
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if ! command_exists "npm"; then
	info "Installing Node.js and npm via NVM..."
	nvm install --lts || fail "Failed to install Node.js"
	nvm use --lts || fail "Failed to switch to Node.js"
	success "npm installed via NVM."
else
	success "npm already installed."
fi

# Final success message
success "Setup complete!"
