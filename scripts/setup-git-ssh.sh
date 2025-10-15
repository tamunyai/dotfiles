#!/usr/bin/env bash
#
# sets up Git with SSH.

set -euo pipefail
IFS=$'\n\t'

# --- LOAD FUNCTIONS ----------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/utils.sh"

# --- MAIN --------------------------------------------------------------------

info "checking for SSH key..."

# check if SSH key exists
# usage: ./setup-git-sh.sh <github_email>
if [ ! -f ~/.ssh/id_ed25519 ]; then
	github_email=$1

	if [ -z "$github_email" ]; then
		user "Enter your GitHub email address: "
		read -r github_email
	fi

	if [ -z "$github_email" ]; then
		fail "Email address is required."
	fi

	info "Generating a new SSH key for $github_email..."

	ssh-keygen -t ed25519 -C "$github_email" -N "" || fail "Failed to generate SSH key"
	success "A new SSH key has been created."

	user "Please manually copy the public key below:"
	echo ''
	cat ~/.ssh/id_ed25519.pub
	echo ''

	info "Now, go to https://github.com/settings/keys and add the key."

else
	info "SSH key already exists. No action required."
fi

# test connection
if [ -f ~/.ssh/id_ed25519 ] && user "Do you want to test SSH connection to GitHub now? (y/n): "; then
	read -r answer

	if [[ "$answer" =~ ^[Yy]$ ]]; then
		ssh -T git@github.com
	fi
fi

echo ''
