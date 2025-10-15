#!/usr/bin/env bash
#
# common utility functions for setup scripts.

set -euo pipefail
IFS=$'\n\t'

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
	local cmd="$1"

	# prefer 'dpkg-query' if available
	if command -v "dpkg-query" >/dev/null 2>&1; then
		if dpkg-query -W --showformat='${Status}\n' "$cmd" 2>/dev/null | grep -q "install ok installed"; then
			return 0
		fi
	fi

	# fallback to ensure it's an actual executable
	local path
	path="$(type -P "$cmd" 2>/dev/null)"

	if [ -n "$path" ] && [ -x "$path" ]; then
		return 0
	fi

	return 1
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

# copies text to the clipboard using the appropriate method for the current OS.
# usage: copy_to_clipboard <text>
copy_to_clipboard() {
	os_name="$(uname -s)"

	case "$os_name" in
	Linux*)
		if command_exists xclip; then
			xclip -selection clipboard <"$1"
		fi
		;;

	Darwin*)
		if command_exists pbcopy; then
			pbcopy <"$1"
		fi
		;;

	*)
		user "clipboard copy is not supported on this operating system."
		return 1
		;;
	esac
}
