#!/usr/bin/env bash
#
# sets up configurations for my preferred development environment.

sudo -v

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

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

	info "Installing Node.js and npm via NVM..."
	nvm install --lts || fail "Failed to install Node.js"
	nvm use --lts || fail "Failed to switch to Node.js"
	success "npm installed via NVM."
fi

# Final success message
success "Setup complete!"
echo ''
