#!/usr/bin/env zsh

# --- FUNCTIONS ---------------------------------------------------------------

function source_if_exists() {
    [[ -r "$1" ]] && source "$1";
}

# --- PLUGINS SETUP -----------------------------------------------------------

# Array of user-plugin_name pairs
plugins=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-history-substring-search"
    "MichaelAquilina/zsh-you-should-use"
    "Aloxaf/fzf-tab"
)

# Install and source plugins
for plugin in "${plugins[@]}"; do
    components=(${(s:/:)plugin})
    github_user=$components[1]
    plugin_name=$components[2]
    install_dir="$HOME/.zsh/plugins/$plugin_name"
    repo_url="https://github.com/$github_user/$plugin_name.git"

    if [ ! -d "$install_dir" ]; then
        git clone "$repo_url" "$install_dir"
    fi

    source_if_exists "$install_dir/$plugin_name.plugin.zsh"
done

# --- ENVIRONMENT VARIABLES ---------------------------------------------------

# Set default editors.
export EDITOR='nvim'
export VISUAL="$EDITOR"

# Python UTF-8 output encoding.
export PYTHONIOENCODING='UTF-8'

# Increase Zsh history size.
export HISTSIZE=32768                    # Maximum number of commands to remember
export SAVEHIST=$HISTSIZE                # Same value for history file storage
export HISTFILE="$HOME/.zsh_history"     # Location of the history file

# Paths.
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# Update FPATH to include completions
export FPATH="$HOME/.eza/completions/zsh:$FPATH"

# Prevent screen clearing after quitting a manual page.
export MANPAGER='less -X'

# Hide the macOS Zsh warning.
export BASH_SILENCE_DEPRECATION_WARNING=1

# GCC colors.
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LESS_TERMCAP_md="${yellow}"

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Android Sdk
os_name="$(uname -s)"

case "$os_name" in
Linux*)
  if [ -n "$WSL_DISTRO_NAME" ]; then
    WINDOWS_HOME="$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
    export ANDROID_HOME="$WINDOWS_HOME/AppData/Local/Android/Sdk"
    alias adb="$ANDROID_HOME/platform-tools/adb.exe"
    # ln -sf "$ANDROID_HOME/platform-tools/adb.exe" "$ANDROID_HOME/platform-tools/adb" # For expo-cli

  else
    export ANDROID_HOME="$HOME/Android/Sdk"
  fi
  ;;
Darwin*)
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  ;;
*)
  echo "Unsupported OS. Please set ANDROID_HOME manually."
  ;;
esac

export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# --- HISTORY OPTIONS ---------------------------------------------------------

setopt appendhistory                 # Append to the history file, don't overwrite it.
setopt inc_append_history            # Save commands immediately after they're entered.
setopt hist_expire_dups_first        # Expire duplicates first when trimming history
setopt extended_history              # Save timestamp and command duration in history
setopt share_history                 # Share history between all Zsh sessions
setopt hist_ignore_space             # Ignore commands that start with a space.
setopt hist_ignore_all_dups          # Remove all duplicate commands from history.
setopt hist_save_no_dups             # Don't save duplicate entries in history.
setopt hist_ignore_dups              # Don't record a command if it's a duplicate.
setopt hist_find_no_dups             # Don't display duplicates when searching.
setopt hist_reduce_blanks            # Remove superfluous blanks before saving history

# --- KEYBINDINGS -------------------------------------------------------------

bindkey -e                           # Use Emacs-style key bindings
bindkey '^p' history-search-backward # Bind Ctrl+P for backward search through history
bindkey '^n' history-search-forward  # Bind Ctrl+N for forward search through history

# --- ALIASES -----------------------------------------------------------------

# Useful aliases
alias l="eza -alh --icons"
alias ls="eza --icons"
alias sl="eza --icons"
alias tree="eza --tree -I 'node_modules|.git|.expo' -L 1 --icons"

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Create directories with verbose output
alias mkdir='mkdir -pv'

# Prevent accidental deletion or renaming of system-critical files
alias rm='rm -I --preserve-root'
alias mv='mv -i'                     # Prompt before overwriting files with mv
alias cp='cp -i'                     # Prompt before overwriting files with cp
alias ln='ln -i'                     # Prompt before creating symlinks

# Download files with continuation support
alias wget='wget -c'

# Colorize output for grep, fgrep, and egrep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Python virtualenv management
alias ve='python3 -m venv ./venv'
alias va='source ./venv/bin/activate'

# Notification after command completion
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//")"'

# --- ZOXIDE INIT -------------------------------------------------------------

# (smart `cd` replacement) for faster navigation
eval "$(zoxide init --cmd cd zsh)"

# --- CLEANUP -----------------------------------------------------------------
unset source_if_exists
