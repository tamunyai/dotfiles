#!/usr/bin/env bash
#
# sets up Git with SSH.

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

echo ''

info "checking for SSH key..."

# Check if SSH key exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
	user "enter your GitHub email address: "
	read -nr 1 github_email </dev/tty

	if [ -z "$github_email" ]; then
		fail "email address is required."
	fi

	ssh-keygen -t ed25519 -C "$github_email" -N "" || error "Failed to generate SSH key"
	info "SSH key not found. A new SSH key has been created."

	if copy_to_clipboard "$HOME/.ssh/id_ed25519.pub"; then
		success "SSH key has been copied to the clipboard"

	else
		user "you can manually copy the key from the following file: ~/.ssh/id_ed25519.pub"
	fi

	success "now, go to https://github.com/settings/keys and add the key."

else
	success "SSH key already exists. No action required."
fi

echo ''
