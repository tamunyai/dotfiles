# ~/.bashrc
#
# bash-specific configuration
# executed by bash(1) for non-login shells.

# --- LOAD SHARED CONFIG ------------------------------------------------------

[ -f "$HOME/.shell/commonrc" ] && source "$HOME/.shell/commonrc"
[ -f "$HOME/.shell/localrc" ] && source "$HOME/.shell/localrc"

# --- SAFETY / DEFAULTS -------------------------------------------------------

# if not running interactively, don't do anything
case $- in
	*i*) ;;
		*) return;;
esac

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

# --- CLEANUP -----------------------------------------------------------------
unset -f command_exists 2>/dev/null
unset -v color_prompt force_color_prompt debian_chroot 2>/dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
