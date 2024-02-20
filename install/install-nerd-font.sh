#!/usr/bin/env bash
#
# installs fonts for better rendering.

DOTFILES="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)"
. "$DOTFILES/install/utils.sh"

detect_os # DEST_FONTS_DIR based on OS

version='3.0.2' # Latest version of the Nerd Fonts pack
src="./fonts"
dst="$DEST_FONTS_DIR"

echo ''

declare -a fonts=(
	# Agave
	# AnonymousPro
	# Arimo
	# AurulentSansMono
	# BigBlueTerminal
	# BitstreamVeraSansMono
	# CascaidaCode
	# CodeNewRoman
	# Cousine
	# DaddyTimeMono
	# DejaVuSansMono
	# DroidSansMono
	# FantasqueSansMono
	# FiraCode
	# FiraMono
	# Go-Mono
	# Gohu
	# Hack
	# Hasklig
	# HeavyData
	# Hermit
	# iA-Writer
	# IBMPlexMono
	# Inconsolate
	# InconsolataGo
	# InconsolataLGC
	# Iosevka
	JetBrainsMono
	# Lekton
	# LiberationMono
	# Lilex
	# Meslo
	# Monofur
	# Mononoki
	# Monoid
	# MPlus
	# NerdFontsSymbolsOnly
	# Noto
	# OpenDyslexic
	# Overpass
	# ProFont
	# ProggyClean
	# RobotoMono
	# ShareTechMono
	# Terminus
	# Tinos
	# Ubuntu
	# UbuntuMono
	# VictorMono
)

mkdir -p "$src" "$dst"
install_dependencies "wget" "unzip"

# Download Nerd Font(s)
for font in "${fonts[@]}"; do
	download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${font}.zip"

	info "downloading ${font} font..."

	if wget -q --show-progress "$download_url" -P "$src/"; then
		success "$font font downloaded successfully."

	else
		fail "failed to download $font font. Please check your internet connection or try again later."
	fi
done

# Detect if running in WSL
if [ -n "$WSL_DISTRO_NAME" ]; then
	mv "$src/"* "$dst/"
	user "install fonts manually as you are running WSL."
	info "fonts saved at: $dst/"

else
	for font in "${fonts[@]}"; do
		unzip -n "$src/${font}.zip" -d "$dst" -x "*LICENSE*" "*.txt*" "*.md*"
		success "${font} font installed successfully."
	done

	find "$dst" -name '*Windows Compatible*' -delete
	command_exists "fc-cache" && fc-cache -fv "$dst"
fi

rm -rf "$src"

echo ''
echo ''
user "please change your terminal font to display correctly."
