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
XDG_DATA_HOME="$HOME/.local/share"

link_config .zshrc "$HOME/.zshrc"
link_config .tmux.conf "$XDG_CONFIG_HOME/tmux/tmux.conf"
link_config .p10k.zsh "$XDG_DATA_HOME/powerlevel10k/.p10k.zsh"
link_config .vimrc "$XDG_CONFIG_HOME/vim/vimrc"
link_config .gitconfig "$XDG_CONFIG_HOME/git/config"
link_config .gitignore_global "$XDG_CONFIG_HOME/git/.gitignore"
link_config alacritty.toml "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
link_config nvim "$XDG_CONFIG_HOME/nvim"

link_config agents/AGENTS.md "$HOME/.claude/CLAUDE.md"
link_config agents/agents "$HOME/.claude/agents"
link_config agents/commands "$HOME/.claude/commands"
link_config agents/rules "$HOME/.claude/rules"
link_config agents/settings.claude.json "$HOME/.claude/settings.json"
link_config agents/statusline.sh "$HOME/.claude/statusline.sh"

link_config agents/AGENTS.md "$HOME/.codex/CLAUDE.md"
link_config agents/agents "$HOME/.codex/agents"
link_config agents/commands "$HOME/.codex/commands"
link_config agents/rules "$HOME/.codex/rules"
