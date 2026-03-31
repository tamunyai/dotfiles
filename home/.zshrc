# ~/.zshrc
#
# zsh-specific configuration

# --- LOAD SHARED CONFIG ------------------------------------------------------

SHELL_CONFIG_DIR="$HOME/.config/shell"

for file in $SHELL_CONFIG_DIR/{functions,exports,aliases,extras}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# --- PLUGINS -----------------------------------------------------------------

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# install zinit (light-weight plugin manager) if it's not present
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# load plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light MichaelAquilina/zsh-you-should-use       # suggests better aliases
zinit light Aloxaf/fzf-tab                           # use fzf for completions

# add plugin snippets from Oh My Zsh
zinit snippet OMZP::git

# initialize completions
autoload -U compinit && compinit
zinit cdreplay -q

# --- COMPLETION SETTINGS -----------------------------------------------------

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # use LS_COLORS in completions
zstyle ':completion:*' menu no                          # use fzf-tab instead of the default menu

# --- HISTORY -----------------------------------------------------------------

setopt appendhistory					# append to the history file, don't overwrite it.
setopt inc_append_history 		# save commands immediately after they're entered.
setopt hist_expire_dups_first	# expire duplicates first when trimming history.
setopt extended_history 			# save timestamp and command duration in history.
setopt share_history 					# share history between all Zsh sessions.
setopt hist_ignore_space 			# ignore commands that start with a space.
setopt hist_ignore_all_dups 	# remove all duplicate commands from history.
setopt hist_save_no_dups 			# don't save duplicate entries in history.
setopt hist_ignore_dups 			# don't record a command if it's a duplicate.
setopt hist_find_no_dups 			# don't display duplicates when searching.
setopt hist_reduce_blanks 		# remove superfluous blanks before saving history.

# --- KEYBINDINGS -------------------------------------------------------------

bindkey -e                           # use Emacs-style key bindings.
bindkey '^p' history-search-backward # bind Ctrl+P for backward search through history.
bindkey '^n' history-search-forward  # bind Ctrl+N for forward search through history.

# --- EXTRAS ------------------------------------------------------------------

# bat colorize --help and -h output for all commands.
if command -v "bat" >/dev/null 2>&1; then
  alias -g -- -h='-h 2>&1 | bat --style=plain --language=help'
  alias -g -- --help='--help 2>&1 | bat --style=plain --language=help'
fi

# fzf-tab preview
zstyle ':fzf-tab:complete:*' fzf-preview '
  # skip if realpath is empty or does not exist
  if [[ -z "$realpath" || ! -e "$realpath" ]]; then
    echo "No preview available"
    return
  fi

  if [[ -f $realpath ]]; then
    # file preview
    if command -v bat >/dev/null 2>&1; then
      bat --color=always --style=numbers --line-range=:500 "$realpath"

    else
      head -n 200 "$realpath"
    fi

  else
    # directory preview
    if command -v eza >/dev/null 2>&1; then
      eza --tree -L 1 --group-directories-first --icons "$realpath"

    else
      ls --color=always "$realpath"
    fi
  fi
'

# --- LOCAL OVERRIDES ---------------------------------------------------------

if [ -f "$SHELL_CONFIG_DIR/localrc" ]; then
  source "$SHELL_CONFIG_DIR/localrc"
fi
