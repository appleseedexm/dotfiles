export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export ZVM_INIT_MODE=sourcing

ZSH_THEME="nanotech"
plugins=(git zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# aliases
alias nv="nvim . "
alias paqi="paru -Qi | grep -i name"
alias today="tmux new-session 'nvim -c ObsidianToday'"
alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ')"
alias theme.sh="sh ~/.scripts/theme.sh"
alias agt="amdgpu_top"
alias f="fd --type f | fzf | sed 's/\ /\\\ /g' | xargs nvim"
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

# ssh
SESSION_TYPE_SSH_PREFIX="%F{red}%B[ssh]%b"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="$SESSION_TYPE_SSH_PREFIX"
# many other tests omitted
else
  case $(ps -o comm= -p "$PPID") in
    sshd|*/sshd) SESSION_TYPE="$SESSION_TYPE_SSH_PREFIX";;
  esac
fi

PS1="$SESSION_TYPE$PS1"

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


# fix oh-my-zsh edit mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
