#!/usr/bin/env zsh

# --- FUNCTIONS ---------------------------------------------------------------
function source_if_exists() {
    [[ -r "$1" ]] && source "$1";
}

# --- PLUGINS SETUP -----------------------------------------------------------
# Set the directory for Zinit and plugins.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install Zinit if it's not already installed.
if [ ! -d "$ZINIT_HOME" ]; then
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load Zinit.
source_if_exists "${ZINIT_HOME}/zinit.zsh"

# Install and load plugins with Zinit.
zinit light zsh-users/zsh-syntax-highlighting         # Syntax highlighting
zinit light zsh-users/zsh-autosuggestions             # Autosuggestions
zinit light zsh-users/zsh-completions                 # Additional completions
zinit light zsh-users/zsh-history-substring-search    # History substring search
zinit light Aloxaf/fzf-tab                            # fzf-tab
zinit light MichaelAquilina/zsh-you-should-use

# Add snippets.
zinit snippet OMZP::git                               # Git plugin
zinit snippet OMZP::sudo                              # Sudo plugin

# Load completions.
autoload -Uz compinit && compinit

# Replay directory change history quietly.
zinit cdreplay -q

# --- NVM SETUP ---------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

# --- ANDROID SDK SETUP -------------------------------------------------------
os_name="$(uname -s)"

case "$os_name" in
Linux*)
  if [ -n "$WSL_DISTRO_NAME" ]; then
    WINDOWS_HOME="$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
    export ANDROID_HOME="$WINDOWS_HOME/AppData/Local/Android/Sdk"
    alias adb="$ANDROID_HOME/platform-tools/adb.exe"
    ln -sf "$ANDROID_HOME/platform-tools/adb.exe" "$ANDROID_HOME/platform-tools/adb" # For expo-cli

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

# --- COMPLETION SETTINGS -----------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# --- ALIASES -----------------------------------------------------------------
# Useful aliases
alias vi='nvim'
alias l="eza -alh --icons"
alias ls=eza
alias sl=eza
alias tree="eza --tree -I 'node_modules|.git|.expo' -L 1"

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

# --- STARSHIP & ZOXIDE INIT --------------------------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"   # (smart `cd` replacement) for faster navigation

# --- CLEANUP -----------------------------------------------------------------
unset source_if_exists
