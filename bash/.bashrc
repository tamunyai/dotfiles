# ~/.bashrc
#
# bash-specific configuration
# executed by bash(1) for non-login shells.

# --- INTERACTIVE CHECK -------------------------------------------------------

# if not running interactively, don't do anything
case $- in
	*i*) ;;
		*) return;;
esac

# --- LOAD SHARED CONFIG ------------------------------------------------------

SHELL_CONFIG_DIR="$HOME/.config/shell"

for file in $SHELL_CONFIG_DIR/{functions,exports,aliases,extras}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# --- DEFAULTS ----------------------------------------------------------------

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion

  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- HISTORY -----------------------------------------------------------------

# append to the history file, don't overwrite it
shopt -s histappend 2>/dev/null || true

# save and reload history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize 2>/dev/null || true

# if set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar 2>/dev/null || true

# auto-correct minor typos in 'cd' commands
shopt -s cdspell 2>/dev/null || true

# make filename globbing case-insensitive
shopt -s nocaseglob 2>/dev/null || true

# --- LOCAL OVERRIDES ---------------------------------------------------------

if [ -f "$SHELL_CONFIG_DIR/localrc" ]; then
  source "$SHELL_CONFIG_DIR/localrc"
fi
