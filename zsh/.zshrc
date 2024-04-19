export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="nanotech"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# aliases
alias silent="dunstctl set-paused toggle"

# load private configs 
if [ -f $HOME/.shell_aliases ]; then
    source $HOME/.shell_aliases
fi

if [ -f $HOME/.shell_local ]; then
    source $HOME/.shell_local
fi

# theme.sh
if command -v theme.sh > /dev/null; then
	[ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"

	# Optional

	# Bind C-o to the last theme.
	last_theme() {
		theme.sh "$(theme.sh -l|tail -n2|head -n1)"
	}

	zle -N last_theme
	bindkey '^O' last_theme

	alias th='theme.sh -i'

	# Interactively load a light theme
	alias thl='theme.sh --light -i'

	# Interactively load a dark theme
	alias thd='theme.sh --dark -i'
fi

# nmon
export NMON=cmt

# zoxide
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/code/other/*"
eval "$(zoxide init zsh --cmd cd)"

# nvm
source /usr/share/nvm/init-nvm.sh --no-use

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


