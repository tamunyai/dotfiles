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

# detect platform (Linux | macOS | Git Bash)
# usage: detect_platform
function detect_platform() {
	case "$(uname -s)" in
		Linux*)								echo "Linux" ;;
		Darwin*)							echo "macOS" ;;
		MINGW*|MSYS*|CYGWIN*) echo "Git Bash" ;;
		*)										echo "Unknown" ;;
	esac
}

# install a package using the appropriate package manager
# usage: install <package>
function install() {
	local package=$1
	local platform=$2

	if command_exists "$package"; then
		success "$package already installed."
		return 0
	fi

	info "installing ${package}.."

	case "$platform" in
		Linux)
			if command_exists apt-get; then
				sudo apt-get update -y
				sudo apt-get install -y "$package"

			# elif command_exists dnf; then
			# 	sudo dnf makecache -y
			# 	sudo dnf install -y "$package"

			# elif command_exists yum; then
			# 	sudo yum makecache -y
			# 	sudo yum install -y "$package"

			# elif command_exists pacman; then
			# 	sudo pacman -Sy --noconfirm
			# 	sudo pacman -S --noconfirm "$package"

			# elif command_exists zypper; then
			# 	sudo zypper refresh
			# 	sudo zypper install -y "$package"

			else
				fail "No supported Linux package manager found."
			fi
			;;

		macOS)
			if command_exists brew; then
				brew install "$package"

			else
				fail "Homebrew not found. Please install Homebrew first and re-run this script."
			fi
			;;

		"Git Bash")
			user "Skipping system install for '$package' (Git Bash). Please ensure it's available in PATH."
			;;

		*)
			fail "Unsupported platform: $platform"
			;;
	esac
}

# check if a file should be ignored
# usage: should_ignore "relative/path/to/file" "ignore1 ignore2 ignore3"
should_ignore() {
	local file="$1"

	shift
	local ignore_list=("$@")

	for ignore in "${ignore_list[@]}"; do
		# skip empty lines or comments
		[[ -z "$ignore" || "$ignore" =~ ^# ]] && continue

		# remove trailing slash for comparison
		ignore="${ignore%/}"

		# match exact or prefix (directory)
		if [[ "$file" == "$ignore" || "$file" == "$ignore/"* ]]; then
			return 0  # true: ignore
		fi

	done
	return 1  # false: do not ignore
}

# ensure a file has Unix line endings before sourcing
# usage: fix_crlf_if_needed <file>
fix_crlf_if_needed() {
  local file="$1"
  if [ -f "$file" ] && grep -q $'\r' "$file"; then
    sed -i 's/\r$//' "$file"
  fi
}
