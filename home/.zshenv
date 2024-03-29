# Language settings
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Disable brew analytics
export HOMEBREW_NO_ANALYTICS=1

# Enable `ls` colors
export CLICOLOR=1

# Set XDG values
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

if [ -f "/usr/local/bin/brew" ]; then
    eval $(/usr/local/bin/brew shellenv)
fi

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [ -d "$HOME/go/bin" ]; then
    path+=$HOME/go/bin
fi

if [ -d "/usr/local/go/bin" ]; then
    export GOROOT=/usr/local/go
    path+=/usr/local/go/bin
fi

if [ -d "/opt/homebrew/bin" ]; then
    path+=/opt/homebrew/bin/python3
fi

if [ -d "$HOME/.local/bin" ]; then
    path+=$HOME/.local/bin
fi

if [ -d "$HOME/nvim/bin" ]; then
    path+=$HOME/nvim/bin/
fi

if [ -f "$HOME/.zshenv.local" ]; then
    source "$HOME/.zshenv.local"
fi
