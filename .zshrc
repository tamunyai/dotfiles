#!/usr/bin/env zsh

# --- FUNCTIONS ---------------------------------------------------------------

function source_if_exists() {
    test -r "$1" && source "$1";
}

# --- SOURCE FILES ------------------------------------------------------------

source_if_exists $HOME/.env

# -- PLUGINS

# Array of user-plugin_name pairs
plugins=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-history-substring-search"
)

# Install and source plugins
for plugin in "${plugins[@]}"; do
    components=(${(s:/:)plugin})
    github_user=$components[1]
    plugin_name=$components[2]
    install_dir="$HOME/.zsh/$plugin_name"
    repo_url="https://github.com/$github_user/$plugin_name.git"

    if [ ! -d "$install_dir" ]; then
        git clone "$repo_url" "$install_dir"
    fi

    source_if_exists "$install_dir/$plugin_name.plugin.zsh"
done

# --- EXPORTS -----------------------------------------------------------------

# Make vim the default editor.
export EDITOR='nvim'
export VISUAL="$EDITOR"

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8'

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth'

# Add `~/bin`, `~/.local/bin` to the `$PATH`
export PATH="$PATH:${HOME}/bin:${HOME}/.local/bin"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X'

# Hide the “default interactive shell is now zsh” warning on macOS.
export BASH_SILENCE_DEPRECATION_WARNING=1

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LESS_TERMCAP_md="${yellow}"

# --- SET OPTIONS -------------------------------------------------------------

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

# --- ALIASES -----------------------------------------------------------------

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias mkdir='mkdir -pv'
alias wget='wget -c'
alias ve='python3 -m venv ./venv'
alias va='source ./venv/bin/activate'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='command ls --color=auto'
    alias l.='ls -d .* --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//")"'
