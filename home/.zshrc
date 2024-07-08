# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

 export PATH=/opt/homebrew/bin:$PATH
# eval "$(starship init zsh)"
# export STARSHIP_CONFIG=~/example/non/default/path/starship.toml


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME=""

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"


# https://unix.stackexchange.com/questions/599641/why-do-i-have-duplicates-in-my-zsh-history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

export WORDCHARS='~!#$%^&*(){}[]<>?.+;-'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude .bemol'
export FZF_CTRL_R_OPTS="--reverse --info hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export EDITOR='nvim'
export MANPAGER='nvim +Man!'

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  git
  brew
  kubectl
  zsh-vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

# https://github.com/jeffreytse/zsh-vi-mode/issues/19
# saves to clipboard on yank
function zvm_vi_yank() {
    zvm_yank
    printf %s "${CUTBUFFER}" | clipcopy
    zvm_exit_visual_mode
}

function my_zvm_init() {
    [ -f $XDG_CONFIG_HOME/fzf/fzf.zsh ] && source $XDG_CONFIG_HOME/fzf/fzf.zsh

    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
    bindkey '^ ' autosuggest-accept
    [[ $- == *i* ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh 2> /dev/null
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
}

zvm_after_init_commands+=(my_zvm_init)


# Directories
# workplace is a dir with work code
#alias gS="cd ~/Code"
alias vim='nvim'

alias kubesh='(){ kubectl run alpine-shell --rm -ti --image=alpine -n=$1 -- /bin/sh ;}'
alias k='kubectl'

alias checkPort='lsof -n -i'

# git aliases
alias lg='lazygit'
alias gb='git branch'
alias glo='git log --oneline'
alias gs='git status'

# python aliases
alias pip='pip3'
alias py='python3'

# personal aliases
alias cat='bat'
alias ssh='ssh -o ServerAliveInterval=60'
alias pi='ssh -l pi 192.168.100.100'
alias myip='curl ifconfig.me'
alias tf='terraform'
alias ll='ls -alF'
alias wiki='cd ~/git/wiki/docs; vim bash.md'
alias ndots='cd ~/.config/nvim/lua/lcavanzo/'
alias dots='cd ~/.config'

# SadServer settings
alias sad='LC_ALL=C.UTF-8 ssh'


# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --hidden --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}


# fd - cd to selected directory
fd() {

  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

reloadzsh () {
   test -f ~/.zshrc && . ~/.zshrc
}

initsetup () {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
  sh /opt/homebrew/opt/fzf/install --all
}

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

