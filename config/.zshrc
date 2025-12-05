###########
### XDG ###
###########

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"


###########
### ZSH ###
###########

# History
HISTFILE="$HOME/.histfile"
HISTSIZE=1000
SAVEHIST=1000

# Disallow duplication in history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP
setopt inc_append_history

# Compleasion
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# Prompt
PS1='%B%F{blue}%n@%m%f %F{cyan}%~%f%b$ '

# Keys
# Emacs mode key configuration
bindkey -e

# Define Key table
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# Setup key accordingly
[[ -n "${key[Home]}"   ]] && bindkey "${key[Home]}"   beginning-of-line
[[ -n "${key[End]}"    ]] && bindkey "${key[End]}"    end-of-line
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


#############
### PATHS ###
#############

function add_path_if_exists() {
    [ -d "$1" ] && export PATH="$1:$PATH"
}

add_path_if_exists "$HOME/.local/bin" 
add_path_if_exists "$HOME/dotfiles/util" 


####################
### APPLICATIONS ###
####################

function source_if_exists() {
    [ -s "$1" ] && source "$1" 
}

# Homebrew
add_path_if_exists "/opt/homebrew/bin"

# zoxide
if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# nvm
local nvm_path="$XDG_CONFIG_HOME/.nvm"
if [ -d "$nvm_path" ]; then
    export NVM_DIR="$nvm_path"

    source_if_exists "$NVM_DIR/nvm.sh" 
    source_if_exists "$NVM_DIR/bash_completion"
fi

local pnpm_path="/home/ts7m/.local/share/pnpm"
if [ -d "$pnpm_path" ]; then
    export PNPM_HOME="$pnpm_path"
    export PATH="$PNPM_HOME:$PATH"
fi

# uv
if [ -x "$(command -v uv)" ]; then
    eval "$(uv generate-shell-completion zsh)"
fi

# VSCode
add_path_if_exists "/mnt/c/Program\\ Files/Microsoft\\ VS\\ Code/bin"

# Deno
local deno_path="$HOME/.deno"
if [ -d "$deno_path" ]; then
    export DENO_INSTALL="$deno_path"
    export DENO_DIR="$XDG_CACHE_HOME/deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Bun
local bun_path="$HOME/.bun"
if [ -d "$bun_path" ]; then
    export BUN_INSTALL="$bun_path"
    export PATH="$BUN_INSTALL/bin:$PATH"

    source_if_exists "$HOME/.bun/_bun" 
fi

# rustup
add_path_if_exists "$HOME/.cargo/bin"

# golang
local go_path="/usr/local/go/bin"
if [ -d "$go_path" ]; then
    export PATH="$go_path:$PATH"
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# nim
local nim_path="$HOME/programs/nim-2.2.6"
if [ -d "$nim_path" ]; then
    export NIM_INSTALL="$nim_path"
    export PATH="$NIM_INSTALL/bin:$PATH"
fi

# ghcup
source_if_exists "/home/ts7m/.ghcup/env" 

# clip.exe
if [ -f "/mnt/c/Windows/System32/clip.exe" ]; then
    alias "clip.exe"="iconv -t sjis | /mnt/c/Windows/System32/clip.exe"
fi

# google cloud sdk
source_if_exists "$HOME/google-cloud-sdk/path.zsh.inc"
source_if_exists "$HOME/google-cloud-sdk/completion.zsh.inc"

# eza
if [ -x "$(command -v eza)" ]; then
    local eza_ignore_paths="node_modules|.git|.cache"
    alias ls='eza --git'
    alias ll='eza --git -l'
    alias la='eza --git -al'
    alias lt="eza --tree --level=3 --ignore-glob=\"$eza_ignore_paths\""
fi

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


################
### START UP ###
################

# Start-up
if [ -z "$TMUX" ] && [ -x "$(command -v fastfetch)" ]; then
	fastfetch
fi

SEM_FILE_NAME="$HOME/.checkupdates-sem"
DATE="$(date '+%Y-%m-%d')"
if [ -f "$SEM_FILE_NAME" ] && [ "$(cat $SEM_FILE_NAME)" = "$DATE" ]; then
	# update check already executed
else
	echo "$DATE" > $SEM_FILE_NAME
	bash "$UTIL_PATH/checkupdates.sh"
fi

# powerlevel10k
source "$HOME/.p10k.zsh"
source "$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme"


################
### LOAD ENV ###
################

[ -s "$HOME/.env" ] && source "$HOME/.env"


############
### MISC ###
############

if [ -n "$CLAUDECODE" ]; then
    unalias cd
    unalias ls
    unalias dir
    unalias vdir
    unalias grep
    unalias fgrep
    unalias egrep
fi
