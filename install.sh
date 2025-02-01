#!/bin/bash
cd "$(dirname "$0")"
set -eo pipefail

if [ "$EUID" -eq 0 ]; then
    echo "abort: Do not run this script as root."
    exit 1
fi

PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$HOME/.deno/bin"

# parse options
SKIP_UPDATE=0
SKIP_INSTALL=0
SKIP_LINK=0
INSTALL_MINIMUM=0
PKG_MANAGER=""

if [ -x "$(command -v brew)" ]; then
    PKG_MANAGER="brew"
elif [ -x "$(command -v pacman)" ]; then
    PKG_MANAGER="pacman"
elif [ -x "$(command -v apt)" ]; then
    PKG_MANAGER="apt"
fi

for arg in "$@"; do
    case "$arg" in
        "--no-update")
            SKIP_UPDATE=1 ;;
        "--no-install")
            SKIP_INSTALL=1 ;;
        "--no-link")
            SKIP_LINK=1 ;;
        "--minimum")
            INSTALL_MINIMUM=1 ;;
        "--pkg-manager="*)
            PKG_MANAGER="${arg#--pkg-manager=}" ;;
        "--help")
            echo "$0 [options]"
            echo ""
            echo "Options"
            echo "    --no-update  Skips registory and package update."
            echo "    --no-install Skips package installation."
            echo "    --no-link    Skips making symlinks to configuration files."
            echo "    --minimum    Install only minimum (not for development) packages."
            exit 0
            ;;
        *)
            echo "abort: Unknown option: $arg"
            exit 1
            ;;
    esac
done

if [ -z "$PKG_MANAGER" ]; then
    echo "abort: Cannot find a package manager."
    exit 1
fi
echo "Package manager: $PKG_MANAGER"



# define utilities

# prtints given values in bold, highlighted style
function echo_emph() {
    echo -en "\033[1;33m"
    echo $@
    echo -en "\033[0m"
}
# prtints given values in bold style
function echo_emph2() {
    echo -en "\033[1m"
    echo $@
    echo -en "\033[0m"
}

# executes install command with detected package manager
function install() {
    echo_emph2 "Installing $@"
    case "$PKG_MANAGER" in
        "brew")
            brew install $@ ;;
        "pacman")
            sudo pacman -S --noconfirm $@ ;;
        "apt")
            DEBIAN_FRONTEND=noninteractive sudo --preserve-env=DEBIAN_FRONTEND apt install -y $@ ;;
    esac
}

# creates symbolic link from /config/$1 to $2
# if file $2 already exists, makes backups of them as $2.bak
function link_config() {
    if [[ -f "$1" && ! -L "$1" ]]; then
        cp -rvf "$1" "$1.bak"
    fi
    ln -svf "$(pwd)/config/$1" "$2"
}

# detect package manager
# install programs
if [ "$SKIP_UPDATE" = "0" ]; then
    echo_emph "Updating"

    case "$PKG_MANAGER" in
        "brew")
            brew update
            brew upgrade
            ;;
        "pacman")
            sudo pacman -Syu
            ;;
        "apt")
            sudo apt update
            sudo apt upgrade -y
            ;;
    esac
fi

if [ "$SKIP_INSTALL" = "0" ]; then
    echo_emph "Installing packages"

    INSTALL_TARGETS=""

    if [ ! -x "$(command -v add-apt-repository)" ]; then
        if [ "$PKG_MANAGER" = "apt" ]; then
            install software-properties-common
        fi
    fi

    [ -x "$(command -v bzip2)" ] || INSTALL_TARGETS="$INSTALL_TARGETS bzip2"
    [ -x "$(command -v cmake)" ] || INSTALL_TARGETS="$INSTALL_TARGETS cmake"
    [ -x "$(command -v curl)" ]  || INSTALL_TARGETS="$INSTALL_TARGETS curl"
    [ -x "$(command -v gdb)" ]   || INSTALL_TARGETS="$INSTALL_TARGETS gdb"
    [ -x "$(command -v git)" ]   || INSTALL_TARGETS="$INSTALL_TARGETS git"
    [ -x "$(command -v gzip)" ]  || INSTALL_TARGETS="$INSTALL_TARGETS gzip"
    [ -x "$(command -v make)" ]  || INSTALL_TARGETS="$INSTALL_TARGETS make"
    [ -x "$(command -v unzip)" ] || INSTALL_TARGETS="$INSTALL_TARGETS unzip"
    [ -x "$(command -v vim)" ]   || INSTALL_TARGETS="$INSTALL_TARGETS vim"
    [ -x "$(command -v wget)" ]  || INSTALL_TARGETS="$INSTALL_TARGETS wget"

    if [ ! -x "$(command -v 7z)" ]; then
        case "$PKG_MANAGER" in
            "brew")   INSTALL_TARGETS="$INSTALL_TARGETS p7zip" ;;
            "pacman") INSTALL_TARGETS="$INSTALL_TARGETS 7zip" ;;
            "apt")    INSTALL_TARGETS="$INSTALL_TARGETS p7zip-full" ;;
        esac
    fi

    if [ ! -x "$(command -v gcc)" ]; then
        case "$PKG_MANAGER" in
            "brew")   INSTALL_TARGETS="$INSTALL_TARGETS gcc" ;;
            "pacman") INSTALL_TARGETS="$INSTALL_TARGETS gcc" ;;
            "apt")    INSTALL_TARGETS="$INSTALL_TARGETS build-essential" ;;
        esac
    fi

    if [ ! -x "$(command -v ping)" ]; then
        case "$PKG_MANAGER" in
            "apt")    INSTALL_TARGETS="$INSTALL_TARGETS iputils-ping" ;;
        esac
    fi

    if [ ! -x "$(command -v nslookup)" ]; then
        case "$PKG_MANAGER" in
            "pacman") INSTALL_TARGETS="$INSTALL_TARGETS dnsutils" ;;
            "apt")    INSTALL_TARGETS="$INSTALL_TARGETS dnsutils" ;;
        esac
    fi

    if [ "$INSTALL_MINIMUM" = "0" ]; then
        if [ ! -x "$(command -v fastfetch)" ]; then
            if [ "$PKG_MANAGER" = "apt" ]; then
                sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
                sudo apt update -y
            fi
            INSTALL_TARGETS="$INSTALL_TARGETS fastfetch"
        fi

        [ -x "$(command -v fzf)" ]  || INSTALL_TARGETS="$INSTALL_TARGETS fzf"
        [ -x "$(command -v jq)" ]   || INSTALL_TARGETS="$INSTALL_TARGETS jq"
        [ -x "$(command -v nvim)" ] || INSTALL_TARGETS="$INSTALL_TARGETS neovim"
        [ -x "$(command -v rg)" ]   || INSTALL_TARGETS="$INSTALL_TARGETS ripgrep"
        [ -x "$(command -v tldr)" ] || INSTALL_TARGETS="$INSTALL_TARGETS tldr"
        [ -x "$(command -v tmux)" ] || INSTALL_TARGETS="$INSTALL_TARGETS tmux"
        [ -x "$(command -v zsh)" ]  || INSTALL_TARGETS="$INSTALL_TARGETS zsh"

        if [ ! -x "$(command -v lua)" ]; then
            case "$PKG_MANAGER" in
                "brew")   INSTALL_TARGETS="$INSTALL_TARGETS lua" ;;
                "pacman") INSTALL_TARGETS="$INSTALL_TARGETS lua" ;;
                "apt")    INSTALL_TARGETS="$INSTALL_TARGETS lua5.4" ;;
            esac
        fi
    fi

    if [ -n "$INSTALL_TARGETS" ]; then
        install $INSTALL_TARGETS
    fi

    if [ "$INSTALL_MINIMUM" = "0" ]; then
        # install poewrlevel10k
        if [ ! -d "$HOME/.local/share/powerlevel10k" ]; then
            echo_emph2 "Installing powerlevel10k"
            git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "$HOME/.local/share/powerlevel10k"
        fi

        # install rustup
        if [ ! -x "$(command -v rustup)" ]; then
            echo_emph2 "Installing rustup"
            curl --proto "=https" --tlsv1.2 -sSf "https://sh.rustup.rs" | sh -s -- -y
        fi

        INSTALL_TARGETS=""
        [ -x "$(command -v exa)" ]    || INSTALL_TARGETS="$INSTALL_TARGETS exa"
        [ -x "$(command -v fnm)" ]    || INSTALL_TARGETS="$INSTALL_TARGETS fnm"
        [ -x "$(command -v zoxide)" ] || INSTALL_TARGETS="$INSTALL_TARGETS zoxide"

        if [ -n "$INSTALL_TARGETS" ]; then
            echo_emph2 "Installing $INSTALL_TARGETS"
            cargo install $INSTALL_TARGETS
        fi

        # install nodejs
        if [ -x "$(command -v node)" ]; then
            echo_emph2 "Installing Node.js"
            fnm install --lts
        fi

        # install deno
        if [ ! -x "$(command -v deno)" ]; then
            echo_emph2 "Installing Deno"
            curl -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path
        fi

        # install uv
        if [ ! -x "$(command -v uv)" ]; then
            echo_emph2 "Installing uv"
            curl -fsSL https://astral.sh/uv/install.sh | sh
        fi
    fi
fi

# install configurations

if [ "$SKIP_LINK" = "0" ]; then
    echo_emph "Making symlinks to configuration files"

    mkdir -p "$HOME/.config"

    link_config .zshrc "$HOME/.zshrc"
    link_config .tmux.conf "$HOME/.tmux.conf"
    link_config .p10k.zsh "$HOME/.p10k.zsh"
    link_config .vimrc "$HOME/.vimrc"
    link_config .gitconfig "$HOME/.gitconfig"
    link_config nvim "$HOME/.config/nvim"
fi

