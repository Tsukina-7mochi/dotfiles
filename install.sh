#!/bin/bash
cd "$(dirname "$0")"
set -eo pipefail

## options
SKIP_UPDATE=0
SKIP_INSTALL=0
SKIP_LINK=0

for arg in "$@"; do
    if [ "$arg" = "--no-update" ]; then
        SKIP_UPDATE=1
    elif [ "$arg" = "--no-install" ]; then
        SKIP_INSTALL=1
    elif [ "$arg" = "--no-link" ]; then
        SKIP_LINK=1
    elif [ "$arg" = "--help" ]; then
        echo "$0 [options]"
        echo ""
        echo "Options"
        echo "    --no-update  Skips registory and package update."
        echo "    --no-install Skips package installation."
        echo "    --no-link    Skips making symlinks to configuration files."

        exit 0
    fi
done

## Utilities
PROMPT_YN=true

function prompt_yn() {
    read -n1 -p "$1" yn
    echo ""

    if [[ $yn = [yY] ]]; then
        PROMPT_YN=true
    elif [[ $yn = [nN] ]]; then
        PROMPT_Y=false
    else
        echo "abort"
        exit 1
    fi
}

function echo_bold() {
    echo -en "\033[1;33m"
    echo $@
    echo -en "\033[0m"
}


## Install programs

function update_registories_and_packages() {
    if [ -n "$(command -v "brew")" ]; then
        sudo brew update
        sudo brew upgrade
    elif [ -n "$(command -v "apt")" ]; then
        sudo apt update
        sudo apt upgrade -y
    elif [ -n "$(command -v "pacman")" ]; then
        sudo pacman -Syu
    else
        echo "abort: Cannot find a package manager."
        exit 1
    fi
}

function install_system_package_manager() {
    if [ -n "$(command -v "brew")" ]; then
        sudo brew install $@
    elif [ -n "$(command -v "apt")" ]; then
        sudo apt install -y $@
    elif [ -n "$(command -v "pacman")" ]; then
        sudo pacman -S --noconfirm $@
    else
        echo "abort: Cannot find a package manager."
        exit 1
    fi
}

if [ "$SKIP_UPDATE" = "0" ]; then
    echo_bold "Updating"
    update_registories_and_packages
fi

if [ "$SKIP_INSTALL" = "0" ]; then
    echo_bold "Installing packages"
    install_system_package_manager "bzip2 cmake curl gcc gdb git gzip make sed sudo tar unzip wget"
    install_system_package_manager "fzf jq lua micro neofetch neovim tldr tmux zsh"

    echo "$HOME"

    #### with rustup
    if [ ! -d "$HOME/.cargo" ]; then
        curl --proto "=https" --tlsv1.2 -sSf "https://sh.rustup.rs" | sh
    fi

    #### poewrlevel10k
    if [ ! -d "$HOME/programs/powerlevel10k" ]; then
        mkdir -p "$HOME/programs"
        git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$HOME/programs/powerlevel10k"
    fi
fi

## Install configurations

function prompt_and_make_backup() {
    prompt_yn "Will you backup current $1 as $1.bak? (y/N): "
    
    if $PROMPT_YN; then
        cp -rvf "$1" "$1.bak"
    else
        rm -rf "$1"
    fi
}

function link_config() {
    if [[ -f "$1" && ! -L "$1" ]]; then
        prompt_and_make_backup "$2"
    fi
    ln -svf "$(pwd)/config/$1" "$2"
}

if [ "$SKIP_LINK" = "0" ]; then
    echo_bold "Making symlinks to configuration files"

    mkdir -p "$HOME/.config"

    link_config .zshrc "$HOME/.zshrc"
    link_config .tmux.conf "$HOME/.tmux.conf"
    link_config .p10k.zsh "$HOME/.p10k.zsh"
    link_config .vimrc "$HOME/.vimrc"
    link_config .gitconfig "$HOME/.gitconfig"
    link_config nvim "$HOME/.config/nvim"
fi

