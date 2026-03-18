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

# detect platform (Linux | macOS | Git Bash)
# usage: detect_platform
function detect_platform() {
  case "$(uname -s)" in
    Linux*) echo "Linux" ;;
    Darwin*) echo "macOS" ;;
    MINGW* | MSYS* | CYGWIN*) echo "Git Bash" ;;
    *) echo "Unknown" ;;
  esac
}

# install a package using the appropriate package manager
# usage: install <package>
function install() {
  local package=$1
  local platform=$2

  if command -v "$package" >/dev/null 2>&1; then
    success "$package already installed."
    return 0
  fi

  info "installing ${package}.."

  case "$platform" in
    Linux)
      if command -v "apt-get" >/dev/null 2>&1; then
        sudo apt-get install -y "$package"

      elif command -v "dnf" >/dev/null 2>&1; then
      	sudo dnf install -y "$package"

      # elif command -v "yum" >/dev/null 2>&1; then
      # 	sudo yum install -y "$package"

      # elif command -v "pacman" >/dev/null 2>&1; then
      # 	sudo pacman -S --noconfirm "$package"

      # elif command -v "zypper" >/dev/null 2>&1; then
      # 	sudo zypper install -y "$package"

      else
        fail "No supported Linux package manager found."
      fi
      ;;

    macOS)
      if command -v "brew" >/dev/null 2>&1; then
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

# ensure a file has Unix line endings before sourcing
# usage: fix_crlf_if_needed <file>
fix_crlf_if_needed() {
  local file="$1"

  if [ -f "$file" ] && grep -q $'\r' "$file"; then
    sed -i 's/\r$//' "$file"
  fi
}
