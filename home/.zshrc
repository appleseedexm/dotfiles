export PATH=$HOME/bin:/usr/local/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=nvim
export ZVM_INIT_MODE=sourcing

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# Set ZSH theme and plugins
ZSH_THEME="ys"
plugins=(git zsh-vi-mode zsh-syntax-highlighting)

# Source oh-my-zsh setup script
source $ZSH/oh-my-zsh.sh

# Aliases for common commands
alias nv="nvim . "
alias paqi="paru -Qi | grep -i name"
alias sunshine-present=sunshine controller=disabled keyboard=disabled mouse=disabled
alias today="tmux new-session 'nvim -c ObsidianToday'"
alias cargoupdate="cargo install $(cargo install --list | egrep '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ')"
alias theme.sh="sh ~/.scripts/theme.sh"
alias agt="amdgpu_top"
alias f="fd --type f -H | fzf | sed 's/\ /\\\ /g' | xargs nvim"
if command -v exa > /dev/null; then
    alias ls="exa -l --group-directories-first"
fi

# Load private configuration if it exists
if [ -f $HOME/.shell_local ]; then
    source $HOME/.shell_local
fi

# Theme management scripts
if command -v theme.sh > /dev/null; then
	[ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"

	# Optional functions and aliases for theme management

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

# SSH session type detection
SESSION_TYPE_SSH_PREFIX="%F{red}%B[ssh]%b"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="$SESSION_TYPE_SSH_PREFIX"
# many other tests omitted
else
  case $(ps -o comm= -p "$PPID") in
    sshd|*/sshd) SESSION_TYPE="$SESSION_TYPE_SSH_PREFIX";;
  esac
fi

# Set the PS1 prompt variable to include session type
PS1="$SESSION_TYPE$PS1"

# Source fzf integration for zsh
source <(fzf --zsh)

# Configuration for nmon tool
export NMON=cmt

# Zoxide configuration and initialization
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/code/other/*"
eval "$(zoxide init zsh --cmd cd)"

# Node version manager (nvm) setup
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  nvm_cmds=(nvm node npm yarn pnpm)
  for cmd in $nvm_cmds ; do
    alias $cmd="unalias $nvm_cmds && unset nvm_cmds && . $NVM_DIR/nvm.sh && $cmd"
  done
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# SDKMAN initialization script
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Fix oh-my-zsh edit mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# Auto-complete use vim bindings
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Yazi shorthand to cd
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
                zle reset-prompt
	fi
	rm -f -- "$tmp"
}

# zsh vi mode clipboard support
alias cbread='clipcopy'
alias cbprint='clippaste'
for f in zvm_backward_kill_region zvm_yank zvm_replace_selection zvm_change_surround_text_object zvm_vi_delete zvm_vi_change zvm_vi_change_eol; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { _$f \"\$@\"; echo -en \$CUTBUFFER | cbread }"
done
for f in zvm_vi_put_after zvm_vi_put_before zvm_vi_replace_selection; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { CUTBUFFER=\$(cbprint); _$f \"\$@\"; zvm_highlight clear }"
done
