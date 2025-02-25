export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export ZVM_INIT_MODE=sourcing

# uwsm
if uwsm check may-start && uwsm select; then
	exec systemd-cat -t uwsm_start uwsm start default
fi

ZSH_THEME="nanotech"
plugins=(git gradle zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# aliases
alias nv="nvim . "
alias paqi="pacman -Qi | grep -i name"
alias today="nvim -c ObsidianToday"
alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ')"
if command -v exa > /dev/null; then
    alias ls="exa -l --group-directories-first"
fi

# load private config
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

	alias th='theme.sh -i'

	# Interactively load a light theme
	alias thl='theme.sh --light -i'

	# Interactively load a dark theme
	alias thd='theme.sh --dark -i'
fi

# fzf
source <(fzf --zsh)

# nmon
export NMON=cmt

# zoxide
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/code/other/*"
eval "$(zoxide init zsh --cmd cd)"

# nvm
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  nvm_cmds=(nvm node npm yarn)
  for cmd in $nvm_cmds ; do
    alias $cmd="unalias $nvm_cmds && unset nvm_cmds && . $NVM_DIR/nvm.sh && $cmd"
  done
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

