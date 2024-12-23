 export PATH=/opt/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"


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
  git
  brew
  kubectl
  # zsh-vi-mode
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

    [[ $- == *i* ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh 2> /dev/null
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
    bindkey '^ ' autosuggest-accept
    bindkey '^r' atuin-search
}

zvm_after_init_commands+=(my_zvm_init)


# Directories
# workplace is a dir with work code
alias vim='nvim'
alias tm="tmux attach || tmux new"

alias kubesh='(){ kubectl run alpine-shell --rm -ti --image=alpine -n=$1 -- /bin/sh ;}'
alias k='kubectl'
alias kcl='kubectx'
alias kns='kubens'

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
alias cd='z'

# SadServer settings
alias sad='LC_ALL=C.UTF-8 ssh'


# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fg() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --hidden --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}


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

initsetup () {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
  sh /opt/homebrew/opt/fzf/install --all
} 


### yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

set rtp+=/opt/homebrew/opt/fzf

#### antuin configuration ##########
if [ -f "$HOME/.atuin/bin/env" ]; then
    source "$HOME/.atuin/bin/env"
fi

if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"

else
    echo "Atuin not found. Please check installation and PATH."
fi
# source "$HOME/.atuin/bin/env"
# if command -v atuin &>/dev/null; then
#
#     else
#         echo "Atuin not found. Please check installation and PATH."
# fi
# # Variable to store the time of the last Tab press
# last_tab_press=0
#
# # Function to handle Tab key press
# handle_tab() {
#     local current_time=$(date +%s)
#     local time_diff=$((current_time - last_tab_press))
#
#     if [[ $time_diff -le 1 ]]; then # 1 second threshold for double-tap
#         zle _atuin_search_widget
#     else
#         zle expand-or-complete
#     fi
#
#     last_tab_press=$current_time
# }
#
# # Create a new widget from our function
# zle -N handle_tab
#
# # Bind the Tab key to our new widget
# bindkey '^I' handle_tab
####################################

#### pet configuration ##########
sp(){
    print -z $(pet search $*)
}
####################################

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

