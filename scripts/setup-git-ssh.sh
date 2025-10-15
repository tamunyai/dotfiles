#!/usr/bin/env bash
#
# sets up Git with SSH.

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- MAIN --------------------------------------------------------------------

echo ''

info "checking for SSH key..."

# Check if SSH key exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
	user "enter your GitHub email address: "
	github_email=$1

	# TODO: prompt user to verify email before proceeding

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
