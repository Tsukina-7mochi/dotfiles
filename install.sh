#!/bin/bash
cd "$(dirname "$0")"

function prompt_and_make_backup() {
    if [[ -f "$1" && ! -L "$1" ]]; then
        read -n1 -p "Will you backup current $1 as $1.bak? (y/N): " yn
        echo ""
        if [[ $yn = [yY] ]]; then
            cp -rvf "$1" "$1.bak"
        elif [[ $yn = [nN] ]]; then
            rm -rf "$1"
        else
            echo "abort"
            exit 1
        fi
    fi
}

function link_config() {
    prompt_and_make_backup "$2"
    ln -svf "$(pwd)/config/$1" "$2"
}

link_config .zshrc "$HOME/.zshrc"
link_config .tmux.conf "$HOME/.tmux.conf"
link_config .p10k.zsh "$HOME/.p10k.zsh"
link_config .vimrc "$HOME/.vimrc"
link_config .gitconfig "$HOME/.gitconfig"
link_config nvim "$HOME/.config/nvim"

