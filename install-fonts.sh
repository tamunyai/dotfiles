#!/usr/bin/env bash
#
# installs fonts for better rendering.

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

# --- MAIN --------------------------------------------------------------------

# Latest version of the Nerd Fonts pack
version='3.2.1'

# Uncomment the fonts you want to install
declare -a fonts=(
	# "Agave"
	# "AnonymousPro"
	# "Arimo"
	# "AurulentSansMono"
	# "BigBlueTerminal"
	# "BitstreamVeraSansMono"
	# "CascadiaCode"
	# "CodeNewRoman"
	# "Cousine"
	# "DaddyTimeMono"
	# "DejaVuSansMono"
	# "DroidSansMono"
	# "FantasqueSansMono"
	# "FiraCode"
	# "FiraMono"
	# "Go-Mono"
	# "Gohu"
	# "Hack"
	# "Hasklig"
	# "HeavyData"
	# "Hermit"
	# "iA-Writer"
	# "IBMPlexMono"
	# "Inconsolata"
	# "InconsolataGo"
	# "InconsolataLGC"
	# "Iosevka"
	"JetBrainsMono"
	# "Lekton"
	# "LiberationMono"
	# "Lilex"
	# "Meslo"
	# "Monofur"
	# "Mononoki"
	# "Monoid"
	# "MPlus"
	# "NerdFontsSymbolsOnly"
	# "Noto"
	# "OpenDyslexic"
	# "Overpass"
	# "ProFont"
	# "ProggyClean"
	# "RobotoMono"
	# "ShareTechMono"
	# "Terminus"
	# "Tinos"
	# "Ubuntu"
	# "UbuntuMono"
	# "VictorMono"
)

# Detect operating system and set destination font directory
os_name="$(uname -s)"

case "$os_name" in
Linux*)
	if [ -n "$WSL_DISTRO_NAME" ]; then
		WINDOWS_HOME="$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
		DEST_FONTS_DIR="$WINDOWS_HOME/Downloads"

	else
		DEST_FONTS_DIR="$HOME/.local/share/fonts"
	fi
	;;
Darwin*)
	DEST_FONTS_DIR="$HOME/Library/Fonts"
	;;
*)
	fail "Unable to detect the operating system."
	;;
esac

mkdir -p "$DEST_FONTS_DIR"

# Array of packages to install
packages=(
	"wget"
	"unzip"
)

# Install packages in the array
for package in "${packages[@]}"; do
	install "$package"
done

# Download and install selected Nerd Font(s)
for font in "${fonts[@]}"; do
	url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${font}.zip"

	info "downloading ${font} font..."

	if wget -q --show-progress "$url" -P "$DEST_FONTS_DIR/"; then
		success "$font font downloaded successfully."
		unzip -n "$DEST_FONTS_DIR/${font}.zip" -d "$DEST_FONTS_DIR/${font}" -x "*LICENSE*" "*.txt*" "*.md*"
		rm -rf "$DEST_FONTS_DIR/${font}.zip"
		success "${font} font installed successfully."

	else
		fail "failed to download $font font. Please check your internet connection or try again later."
	fi
done

# Detect if running in WSL
if [[ -n "$WSL_DISTRO_NAME" ]]; then
	user "Please install fonts manually as you are running WSL."
	info "Fonts saved at: $DEST_FONTS_DIR/"
else
	# Remove unnecessary files and update font cache on Linux
	find "$DEST_FONTS_DIR" -name '*Windows Compatible*' -delete

	if command_exists fc-cache; then
		fc-cache -fv "$DEST_FONTS_DIR"
	fi

	user "Please change your terminal font to display correctly."
fi

echo ''
