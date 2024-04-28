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
    TARGET="$HOME/${2-$1}"

    prompt_and_make_backup "$TARGET"
    ln -svf "$(pwd)/config/$1" "$TARGET"
}

link_config .zshrc
link_config .tmux.conf
link_config .p10k.zsh
link_config .vimrc
link_config nvim .config

