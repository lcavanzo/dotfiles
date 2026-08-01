export PATH=/opt/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

ZSH_THEME=""

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# History Configuration
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

export WORDCHARS='~!#$%^&*(){}[]<>?.+;-'

# FZF Defaults
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude .bemol'
export FZF_CTRL_R_OPTS="--reverse --info hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export EDITOR='nvim'
export MANPAGER='nvim +Man!'

# Oh My Zsh Plugins
plugins=(
  git
  brew
  kubectl
  zsh-vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# Zsh Vi Mode (ZVM) Configuration
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

# Saves to clipboard on yank (Fixes jeffreytse/zsh-vi-mode #19)
function zvm_vi_yank() {
    zvm_yank
    printf %s "${CUTBUFFER}" | clipcopy
    zvm_exit_visual_mode
}

function my_zvm_init() {
    [ -f $XDG_CONFIG_HOME/fzf/fzf.zsh ] && source $XDG_CONFIG_HOME/fzf/fzf.zsh

    [[ $- == *i* ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh 2> /dev/null
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
    bindkey '^ ' autosuggest-accept
    bindkey '^r' atuin-search

    # ── PET INTEGRATION FOR ZSH-VI-MODE ──────────────────────────────────
    # This registers pet-select as an interactive widget and binds it to Ctrl+s
    if command -v pet &>/dev/null; then
        function pet-select() {
            BUFFER=$(pet search --query "$LBUFFER")
            CURSOR=$#BUFFER
            zle redisplay
        }
        zle -N pet-select
        bindkey '^s' pet-select
    fi
    # ─────────────────────────────────────────────────────────────────────
}
zvm_after_init_commands+=(my_zvm_init)

# Aliases
alias vim='nvim'
alias tm="tmux attach || tmux new"

# Kubernetes
alias kubesh='(){ kubectl run alpine-shell --rm -ti --image=alpine -n=$1 -- /bin/sh ;}'
alias k='kubectl'
alias kcl='kubectx'
alias kns='kubens'

alias checkPort='lsof -n -i'

# Git
alias lg='lazygit'
alias gb='git branch'
alias glo='git log --oneline'
alias gs='git status'

# Python
alias pip='pip3'
alias py='python3.14'
alias python='python3.14'

# Personal & Infrastructure
alias cat='bat'
alias catp='bat --style=header-filename'
alias ssh='ssh -o ServerAliveInterval=60'
alias pi='ssh -l pi 192.168.100.100'
alias myip='curl ifconfig.me'
alias tf='terraform'
alias ll='ls -alF'
alias wiki='cd ~/git/wiki/docs; vim bash.md'
alias cd='z'

# SadServer settings
alias sad='LC_ALL=C.UTF-8 ssh'

# Iximiuz Labs
export PATH=$PATH:/Users/lcavanzo/.iximiuz/labctl/bin

# Advanced Custom Functions
# Find-in-file using ripgrep + fzf preview
fg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --hidden --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Quick Python Environment Switcher
pyenv() {
  local envs_dir="$HOME/.python-envs"
  local selected_env=$(find "$envs_dir" -maxdepth 1 -mindepth 1 -type d | sed "s|$envs_dir/||" | fzf --prompt="Select Python environment: " --layout=reverse --pointer="➜")

  if [[ -n "$selected_env" ]]; then
    source "$envs_dir/$selected_env/bin/activate"
    echo "Activated $selected_env environment"
  else
    echo "No environment selected"
  fi
}

reloadzsh () {
   test -f ~/.zshrc && . ~/.zshrc
}

# Environment Bootstrap Tool
initsetup () {

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
  sh /opt/homebrew/opt/fzf/install --all
}

# Yazi File Manager Wrapper (tracks CWD on quit)
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Local Machine Settings
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

# Atuin Configuration
if [ -f "$HOME/.atuin/bin/env" ]; then
    source "$HOME/.atuin/bin/env"
fi

if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
else
    echo "Atuin not found. Please check installation and PATH."
fi

# Pet Snippet Manager Helper
sp(){
    print -z $(pet search $*)
}

# CLI Init Initializations
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Docker CLI Completions
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Rancher Desktop Managed Paths
export PATH="/Users/lcavanzo/.rd/bin:$PATH"

# Carapace Completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Post-Init FZF Source
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

. "$HOME/.local/share/../bin/env"

# Google Cloud SDK updates
export PATH="$PATH:/usr/local/bin/google-cloud-sdk/bin"
