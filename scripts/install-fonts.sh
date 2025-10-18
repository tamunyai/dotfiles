#!/usr/bin/env bash
#
# installs fonts for better rendering.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- INSTALLATION & CONFIGURATION --------------------------------------------

# uncomment the fonts you want to install
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

# detect operating system
platform=$(detect_platform)
info "Detected platform: $platform"

# set destination font directory
if [ "$platform" = "Linux" ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		WINDOWS_HOME="$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
		DEST_FONTS_DIR="$WINDOWS_HOME/Downloads"

	else
		DEST_FONTS_DIR="$HOME/.local/share/fonts"
	fi

elif [ "$platform" = "macOS" ]; then
	DEST_FONTS_DIR="$HOME/Library/Fonts"

elif [ "$platform" = "Git Bash" ]; then
	DEST_FONTS_DIR="$HOME/Downloads"

else
	fail "Unsupported platform: $platform"
fi

# array of packages to install
packages=("unzip")

# install packages in the array
for package in "${packages[@]}"; do
	install "$package" "$platform"
done

# download and install selected Nerd Font(s)
for font in "${fonts[@]}"; do
	version='3.4.0'
	url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${font}.zip"

	info "downloading ${font} font..."

	if curl -fL --progress-bar -o "$DEST_FONTS_DIR/${font}.zip" --create-dirs "$url"; then
		success "$font font downloaded successfully."
		unzip -n "$DEST_FONTS_DIR/${font}.zip" -d "$DEST_FONTS_DIR/${font}" -x "*LICENSE*" "*.txt*" "*.md*"
		rm -rf "$DEST_FONTS_DIR/${font}.zip"
		success "${font} font installed successfully."

	else
		fail "failed to download $font font. Please check your internet connection or try again later."
	fi
done

case "$platform" in
	Linux)
		if [[ -n "$WSL_DISTRO_NAME" ]]; then
			# if running in WSL
			user "WSL detected: fonts need to be installed in Windows."
			info "Fonts have been saved to: $DEST_FONTS_DIR/"

		else
			# remove unnecessary files and update font cache on Linux
			find "$DEST_FONTS_DIR" -name '*Windows Compatible*' -delete

			if command_exists fc-cache; then
				info "Updating font cache..."
				fc-cache -fv "$DEST_FONTS_DIR"
			fi

			user "Fonts installed. You can now select them in your terminal emulator."
		fi
		;;

	macOS)
		user "Fonts installed in $DEST_FONTS_DIR."
		user "Open Font Book.app to validate and enable them for terminal/IDE use."
		;;

	"Git Bash")
		user "Fonts saved to $DEST_FONTS_DIR."
		user "Set the font manually in your terminal."
		;;

	*)
		user "Fonts saved to $DEST_FONTS_DIR."
		user "Please follow your system's instructions to install them."
		;;
esac

echo ''
