#!/bin/bash
cd "$(dirname "$0")"
set -eo pipefail

function check_availability() {
    name="${2:-$1}"
    echo -n "$name..."

    if [ -x "$(command -v $1)" ]; then
        echo -e "\033[1;32mAvailable\033[0m"
    else
        echo -e "\033[1;31mUnavailable\033[0m"
    fi
}

echo -e "\n\033[1mEssentials\033[0m\n"
check_availability 7z
check_availability bzip2
check_availability cmake
check_availability curl
check_availability gcc
check_availability git
check_availability gzip
check_availability make
check_availability nslookup
check_availability ping
check_availability sudo
check_availability tar
check_availability top
check_availability unzip
check_availability vim
check_availability wget

echo -e "\n\033[1mQOL\033[0m\n"
check_availability bat
check_availability eza
check_availability fastfetch
check_availability fzf
check_availability htop
check_availability jq
check_availability nvim "NeoVim"
check_availability rg "RipGrep"
check_availability tldr
check_availability tmux
check_availability zoxide
check_availability zsh

echo -e "\n\033[1mDevelopment\033[0m\n"
check_availability aws "aws-cli"
check_availability deno "Deno"
check_availability gradle "Gradle"
check_availability gdb
check_availability gh "GitHub CLI"
check_availability go "Go"
check_availability java "Java"
check_availability javac "Java Compiler"
check_availability llvm "LLVM"
check_availability lua "Lua"
check_availability node "Node.js"
check_availability pnpm
check_availability perl "Perl"
check_availability rustup "Rust"
check_availability uv
