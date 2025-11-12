# dotenv
if [ -f "$HOME/.set_env.sh" ]; then
    . "$HOME/.set_env.sh"
fi



# History file
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



# PATH and aliases
PATH="$PATH:$HOME/.local/bin"

# eza
local eza_ignore_paths="node_modules|.git|.cache"

# Homebrew
PATH="/opt/homebrew/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
fi
if [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]; then
    . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# Pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init --path)"
fi

# uv
if [ -v "$(command -v uv)" ]; then
    eval "$(uv generate-shell-completion zsh)"
fi

# VSCode
PATH="$PATH:/mnt/c/Program Files/Microsoft VS Code/bin"

# Deno
export DENO_INSTALL="$HOME/.deno"
export DENO_DIR="$HOME/.cache/deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# rustup
export PATH="$PATH:$HOME/.cargo/bin"

# golang
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# zoxide
eval "$(zoxide init zsh)"

# clip.exe
alias "clip.exe"="iconv -t sjis | /mnt/c/Windows/System32/clip.exe"

# act (GitHub Actions)
alias act="$HOME/programs/act/bin/act"

# Utilities
export UTIL_PATH="$HOME/dotfiles/util"

# Deepl
alias deepl="zsh $UTIL_PATH/deepl.zsh"

# open
alias open="bash $UTIL_PATH/open.sh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="/home/ts7m/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

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

# fnm
if [ -x "$(command -v fnm)" ]; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# claude code
alias claude="$HOME/.local/bin/claude"


# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ ! "$CLAUDECODE" ]; then
    if [ -x "$(command -v eza)" ]; then
        alias ls='eza --git'
        alias ll='eza --git -l'
        alias la='eza --git -al'
        alias lt="eza --tree --level=3 --ignore-glob=\"$eza_ignore_paths\""
    fi

    if [ -n "$(command -v z)" ]; then
        alias cd="z"
    fi
fi

