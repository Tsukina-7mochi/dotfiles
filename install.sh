#!/bin/bash
cd "$(dirname "$0")"

if [ -L "$HOME/.zshrc" ]; then
    read -n1 -p "Will you backup current .zshrc as .zshrc.bak? (y/N): " yn
    echo ""
    if [[ $yn = [yY] ]]; then
        rm -rf "$HOME/.zshrc.bak"
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
    fi
    rm -rf "$HOME/.zshrc"
fi

ln -svf "$(pwd)/config/.zshrc" "$HOME/.zshrc"
