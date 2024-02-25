#!/usr/bin/env bash
#
# utility functions.

# display informational messages
# usage: info <message>
info() {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

# display user prompts or queries
# usage: user <question>
user() {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

# display success messages
# usage: success <message>
success() {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# display failure messages and exit the script
# usage: fail <message>
fail() {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    echo ''
    exit
}

# link a file, with options for handling existing files
# usage: link_file <source_path> <destination_path>
link_file() {
    local src=$1 dst=$2

    local overwrite
    local backup
    local skip
    local action

    if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then

        if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then

            # ignoring exit 1 from readlink in case where file already exists
            # shellcheck disable=SC2155
            local currentSrc="$(readlink $dst)"

            if [ "$currentSrc" == "$src" ]; then

                skip=true

            else

                user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                read -n 1 action </dev/tty

                case "$action" in
                    o)
                        overwrite=true
                        ;;
                    O)
                        overwrite_all=true
                        ;;
                    b)
                        backup=true
                        ;;
                    B)
                        backup_all=true
                        ;;
                    s)
                        skip=true
                        ;;
                    S)
                        skip_all=true
                        ;;
                    *) ;;
                esac

            fi

        fi

        overwrite=${overwrite:-$overwrite_all}
        backup=${backup:-$backup_all}
        skip=${skip:-$skip_all}

        if [ "$overwrite" == "true" ]; then
            rm -rf "$dst"
            success "removed $dst"
        fi

        if [ "$backup" == "true" ]; then
            mv "$dst" "${dst}.backup"
            success "moved $dst to ${dst}.backup"
        fi

        if [ "$skip" == "true" ]; then
            success "skipped $src"
        fi
    fi

    if [ "$skip" != "true" ]; then # "false" or empty
        ln -s "$1" "$2"
        success "linked $1 to $2"
    fi
}

# checks if a command is available in the system.
# usage: command_exists <command_name>
command_exists() {
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
install() {
    local package=$1

    if command_exists "$package"; then
        success "$package already installed."

    else
        info "installing ${package}.."

        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get install -y "$package"

        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y "$package"

        elif [ -x "$(command -v pacman)" ]; then
            sudo pacman -S --noconfirm "$package"

        elif [ -x "$(command -v zypper)" ]; then
            sudo zypper install -y "$package"

        elif [ -x "$(command -v brew)" ]; then
            brew install "$package"

        else
            user "unsupported package manager. please install $package manually."
        fi
    fi
}

# installs a list of package dependencies
# usage: install_dependencies <package_list>
install_dependencies() {
    local package_list=("$@") # Get the list of packages passed as arguments

    for package in "${package_list[@]}"; do
        ! command_exists "$package" && install "$package"
    done
}

# detects the operating system and sets relevant environment variables
# usage: detect_os
detect_os() {
    local os
    os="$(uname)"

    if [ "$os" == "Linux" ]; then
        if [ -n "$WSL_DISTRO_NAME" ]; then
            WINDOWS_HOME="$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"

            export DEST_FONTS_DIR="$WINDOWS_HOME/Downloads"

        else
            export DEST_FONTS_DIR="$HOME/.local/share/fonts"

            # if [ -e /etc/os-release ]; then
            # 	source /etc/os-release
            #
            # 	case "$ID" in
            # 	debian | ubuntu)
            # 		# Add the Ubuntu repository for additional software
            # 		# info "adding the Ubuntu repository for additional software..."
            # 		# sudo add-apt-repository --yes "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
            # 		;;
            #
            # 	*)
            # 		fail "detected operating system: $PRETTY_NAME"
            # 		;;
            # 	esac
            # fi
        fi

        # elif [ "$os" == "Darwin" ]; then
        # 	export DEST_FONTS_DIR="$HOME/Library/Fonts"

    else
        fail "unable to detect the operating system."
    fi
}

# Copies text to the clipboard using the appropriate method for the current OS
# Usage: copy_to_clipboard <file>
copy_to_clipboard() {
    local os
    os="$(uname)"

    case "$os" in
        Darwin*)
            if [ -x "$(command -v pbcopy)" ]; then
                pbcopy <"$1"
            fi
            ;;

        Linux*)
            if [ -x "$(command -v xclip)" ]; then
                xclip -selection clipboard <"$1"
            fi
            ;;

        *)
            user "clipboard copy is not supported on this operating system."
            return 1
            ;;
    esac
}
