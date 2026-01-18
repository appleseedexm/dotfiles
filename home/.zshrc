# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

setopt AUTO_PUSHD
setopt PUSHD_SILENT

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' accept-exact false
zstyle ':completion:*' accept-exact-dirs false
zstyle ':completion:*' path-completion true

# Completion
autoload -U compinit; compinit

# SSH session type detection
# SESSION_TYPE_SSH_PREFIX="%F{red}%B[ssh]%b"
# if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
#   SESSION_TYPE="$SESSION_TYPE_SSH_PREFIX"
# else
#   case $(ps -o comm= -p "$PPID") in
#     sshd|*/sshd) SESSION_TYPE="$SESSION_TYPE_SSH_PREFIX";;
#   esac
# fi
# # Set the PS1 prompt variable to include session type
# PS1="$SESSION_TYPE$PS1"

# Starship
eval "$(starship init zsh)"

# zsh-vi-mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# clipboard support
alias cbread='wl-copy'
alias cbprint='wl-paste'
for f in zvm_backward_kill_region zvm_yank zvm_replace_selection zvm_change_surround_text_object zvm_vi_delete zvm_vi_change zvm_vi_change_eol; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { _$f \"\$@\"; echo -en \$CUTBUFFER | cbread }"
done
for f in zvm_vi_put_after zvm_vi_put_before zvm_vi_replace_selection; do
  eval "$(echo "_$f() {"; declare -f $f | tail -n +2)"
  eval "$f() { CUTBUFFER=\$(cbprint); _$f \"\$@\"; zvm_highlight clear }"
done

# Source fzf integration for zsh
source <(fzf --zsh)

# zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# edit mode
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

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

# Yazi shorthand to cd
# function yy() {
# 	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
# 	yazi "$@" --cwd-file="$tmp"
# 	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
# 		cd -- "$cwd"
#                 zle reset-prompt
# 	fi
# 	rm -f -- "$tmp"
# }

# ripgrep in dir and pipe to nvim
function rg_fzf_nvim(){
  rg $1 | fzf | egrep -o '^[^:]+' | xargs nvim
}

# cd multiple folders up
function cd_up() {
  cd $(printf "%0.s../" $(seq 1 $1 ));
}

# Aliases for common commands
alias nv="nvim . "
alias paqi="paru -Qi | grep -i name"
alias sunshine-present="sunshine controller=disabled keyboard=disabled mouse=disabled"
alias today="tmux new-session 'nvim -c ObsidianToday'"
alias cfniri="nvim $XDG_CONFIG_HOME/niri/"
alias agt="amdgpu_top --dark"
alias 'cd..'='cd_up'
alias 'cd...'='cd_up 2'
alias 'cd....'='cd_up 3'
alias f="fd --type f -H | fzf | sed 's/\ /\\\ /g' | xargs nvim"
alias s="rg_fzf_nvim"
alias o="xdg-open"
alias q="$HOME/.scripts/default-browser.sh"

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsa='ls -lah'
if command -v eza > /dev/null; then
    alias ls="eza -l --group-directories-first"
    alias ld="l --sort date"
fi

# Load private configuration if it exists
if [ -f $HOME/.shell_local ]; then
    source $HOME/.shell_local
fi
