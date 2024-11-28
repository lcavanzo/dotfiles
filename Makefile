SHELL = /bin/bash
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
UNAME_S := $(shell uname -s)


BREW_PACKAGES	:= \
	atuin awscli azure-cli bat exa fish fd fzf git git-delta go imagemagick helm htop jq knqyf263/pet/pet kubectl Azure/kubelogin/kubelogin lazygit \
	neofetch neovim node nmap pkgconfig pngpaste poppler rar ripgrep starship stow terraform tree unzip vlc watch wget wezterm trash yazi yq xclip zoxide zsh

ZSH_PLUGINS_PACKAGES	:= \
	romkatv/powerlevel10k

all:: install-brew-packages link install-terminfo install-fonts download-zsh-plugins update-zsh-plugins

link::
	stow --verbose --no-folding --target=$$HOME --dir=$(DIR) --restow home


unlink::
	stow --verbose --no-folding --target=$$HOME --dir=$(DIR) --delete home

install-brew-packages:
	if [ -z "$$(command -v brew)" ]; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	export PATH="/opt/homebrew/bin:$PATH"
	/opt/homebrew/bin/brew install $(BREW_PACKAGES)

install-terminfo:
	curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz && \
	/usr/bin/tic -xe tmux-256color terminfo.src

install-fonts:
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -P /tmp && \
	unzip /tmp/JetBrainsMono.zip -d ~/Library/Fonts/JetBrainsMono/

download-zsh-plugins:
	rm -rf ~/.zsh && \
	mkdir -p ~/.zsh && \
	cd ~/.zsh && \
	for repo in $(ZSH_PLUGINS_PACKAGES); do \
		git clone --depth=1 https://github.com/$$repo.git; \
	done

update-zsh-plugins:
	cd ~/.zsh && \
	ls | xargs -I{} git -C {} pull
