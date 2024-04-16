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
setopt share_history



# Compleasion
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit



# Prompt
PS1='%B%F{green}%n@%m%f %F{blue}%~%f%b$ '



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



# dotenv
if [ -f "$HOME/.env" ]; then
    eval "$(cat "$HOME/.env" <(echo) <(declare -x))"
fi



# PATH and aliases
PATH="$PATH:$HOME/.local/bin"

# exa
local exa_ignore_paths="node_modules|.git|.cache"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='exa --git'
    alias ll='exa --git -l'
    alias la='exa --git -al'
    alias lt="exa --tree --level=3 --ignore-glob=\"$exa_ignore_paths\""

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Rye
PATH="$PATH:/home/ts7m/.rye/shims"

# pipenv-vscode
alias pipenv-vscode="bash $HOME/pipenv-vscode.sh"

# VSCode
PATH="$PATH:/mnt/c/Program Files/Microsoft VS Code/bin"

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# rustup
export PATH="$PATH:$HOME/.cargo/bin"

# Delichon
alias delichon='deno run --allow-read --allow-write --allow-net https://raw.githubusercontent.com/Tsukina-7mochi/delichon/deploy/mod.js --gh-token $DELICHON_GH_TOKEN'
alias delichon-update='deno cache https://raw.githubusercontent.com/Tsukina-7mochi/delichon/deploy/mod.js'

# golang
export PATH="$PATH:/usr/local/go/bin"

# thefuck
eval $(thefuck --alias)

# zoxide
alias cd="z"
eval "$(zoxide init zsh)"

# clip.exe
alias "clip.exe"="iconv -t sjis | /mnt/c/Windows/System32/clip.exe"

# act (GitHub Actions)
alias act="$HOME/programs/act/bin/act"



# Utilities
export UTIL_PATH="$HOME/dotfiles/util"

# Deepl
alias deepl="zsh $UTIL_PATH/deepl.sh"

# open
alias open="bash $UTIL_PATH/open.sh"



# Start-up
if [ -z "$TMUX" ]; then
	neofetch
fi

SEM_FILE_NAME="$HOME/.checkupdates-sem"
DATE="$(date '+%Y-%m-%d')"
if [ -f "$SEM_FILE_NAME" ] && [ "$(cat $SEM_FILE_NAME)" = "$DATE" ]; then
	# update check already executed
else
	echo "$DATE" > $SEM_FILE_NAME
	bash "$UTIL_PATH/checkupdates.sh"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
