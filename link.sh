#!/bin/bash
cd "$(dirname "$0")"
set -eo pipefail

# creates symbolic link from ./config/$1 to $2
# if file $2 already exists, makes backups of them as $2.bak
function link_config() {
    mkdir -p "$(dirname "$2")"

    if [[ -f "$2" && ! -L "$2" ]]; then
        cp -rvf "$2" "$2.bak"
    fi
    ln -svf "$(pwd)/config/$1" "$2"
}

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

link_config .zshrc "$HOME/.zshrc"
link_config .tmux.conf "$XDG_CONFIG_HOME/tmux/.tmux.conf"
link_config .p10k.zsh "$HOME/.p10k.zsh"
link_config .vimrc "$HOME/.vimrc"
link_config .gitconfig "$XDG_CONFIG_HOME/git/config"
link_config .gitignore_global "$XDG_CONFIG_HOME/git/.gitignore"
link_config nvim "$XDG_CONFIG_HOME/nvim"
