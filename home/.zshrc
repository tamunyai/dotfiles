# ~/.zshrc
#
# zsh-specific configuration

# --- LOAD SHARED CONFIG ------------------------------------------------------

[ -f "$HOME/.shell/commonrc" ] && source "$HOME/.shell/commonrc"
[ -f "$HOME/.shell/localrc" ] && source "$HOME/.shell/localrc"

# --- PLUGINS SETUP -----------------------------------------------------------

# array of user-plugin_name pairs
plugins=(
	"zsh-users/zsh-syntax-highlighting"
	"zsh-users/zsh-autosuggestions"
	"zsh-users/zsh-history-substring-search"
	"MichaelAquilina/zsh-you-should-use"
	"Aloxaf/fzf-tab"
)

# install and source plugins
for plugin in "${plugins[@]}"; do
	components=(${(s:/:)plugin})
	github_user=$components[1]
	plugin_name=$components[2]
	install_dir="$HOME/.shell/plugins/$plugin_name"
	repo_url="https://github.com/$github_user/$plugin_name.git"

	if [ ! -d "$install_dir" ]; then
		git clone "$repo_url" "$install_dir"
	fi

	# source plugin
	source "$install_dir/$plugin_name.plugin.zsh"
done

# --- ENVIRONMENT VARIABLES ---------------------------------------------------

# update FPATH to include completions
if command_exists "eza"; then
	export FPATH="$HOME/.eza/completions/zsh:$FPATH"
fi

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

# --- ENVIRONMENT VARIABLES ---------------------------------------------------

if command_exists "nvim"; then
	export EDITOR='nvim'
	export VISUAL="$EDITOR"
fi

# --- EXTRAS ------------------------------------------------------------------

# starship prompt
if command_exists "starship"; then
	export STARSHIP_CACHE="${HOME}/.starship/cache"
	export STARSHIP_CONFIG="${HOME}/.starship/config.toml"

	eval "$(starship init zsh)"
fi

# zoxide (smart `cd` replacement) for faster navigation
if command_exists "zoxide"; then
	eval "$(zoxide init --cmd cd zsh)"
fi

# --- CLEANUP -----------------------------------------------------------------
unset -f command_exists 2>/dev/null
