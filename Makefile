SHELL = /bin/bash
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
UNAME_S := $(shell uname -s)
ZSH_CUSTOM ?= ~/.oh-my-zsh/custom


BREW_PACKAGES	:= \
	atuin awscli azure-cli bat  fish fd fzf git git-delta go imagemagick helm btop jq knqyf263/pet/pet kubectl Azure/kubelogin/kubelogin lazygit \
	fastfetch neovim node nmap pkgconfig pngpaste poppler rar ripgrep starship stow terraform tree unzip vlc watch wget wezterm trash yazi yq xclip zoxide zsh

all:: install-brew-packages link install-terminfo install-fonts 

link::
	/opt/homebrew/bin/stow --verbose --no-folding --target=$$HOME --dir=$(DIR) --restow home

unlink::
	/opt/homebrew/bin/stow --verbose --no-folding --target=$$HOME --dir=$(DIR) --delete home

install-brew-packages:
	if [ -z "$$(command -v brew)" ]; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	export PATH="/opt/homebrew/bin:$$PATH"
	/opt/homebrew/bin/brew install $(BREW_PACKAGES)

install-terminfo:
	curl -sLO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz && \
	/usr/bin/tic -xe tmux-256color terminfo.src

install-fonts:
	/opt/homebrew/bin/wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -P /tmp && \
	unzip -o /tmp/JetBrainsMono.zip -d ~/Library/Fonts/JetBrainsMono/

