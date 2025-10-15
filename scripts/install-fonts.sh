#!/usr/bin/env bash
#
# installs fonts for better rendering.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

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
