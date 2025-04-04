HISTFILE=${HOME}/.ksh_history
HISTSIZE=5000
HISTCONTROL=ignoredups  # Ignore duplicate commands

export EDITOR="${EDITOR:-vim}"  # Fallback if EDITOR is not set
export VISUAL="${VISUAL:-vim}"  # Fallback if VISUAL is not set
export PAGER=less
export TERM=xterm-256color

export LESS='-R -i -g -F -X'  # Quits if content fits
export LESSHISTFILE=/dev/null  # Disable history file for less

alias ls='ls -F --color=auto'
alias ll='ls -la --color=auto'
alias l='ls'
alias h='fc -l'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -p'
alias cls='clear'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

case "$(uname)" in
    "Linux")
        alias ls='ls --color=auto'
        alias ll='ls -la --color=auto'
        ;;
    "Darwin")
        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad
        alias ls='ls -G'
        alias ll='ls -laG'
        ;;
esac

function mkcd {
    mkdir -p "$1" && cd "$1"
}

function ex {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.tar.bz2)   tar xjf "$1" ;;
        *.tar.gz)    tar xzf "$1" ;;
        *.bz2)       bunzip2 "$1" ;;
        *.rar)       unrar x "$1" ;;
        *.gz)        gunzip "$1" ;;
        *.tar)       tar xf "$1" ;;
        *.tbz2)      tar xjf "$1" ;;
        *.tgz)       tar xzf "$1" ;;
        *.zip)       unzip "$1" ;;
        *.Z)         uncompress "$1" ;;
        *)           echo "'$1' cannot be extracted" ;;
    esac
}

# Git branch display function
function get_git_branch {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

# Prompt with Git branch
PS1='${USER}@$(hostname):$(if [[ "${PWD#$HOME}" != "$PWD" ]]; then print -n "~${PWD#$HOME}"; else print -n "${PWD}"; fi)$(get_git_branch 2>/dev/null | sed "s/^/ (/;s/$/)/") $ '

# Add user's bin directory to PATH if it exists
if [ -d "$HOME/bin" ]; then
    PATH=$PATH:$HOME/bin
fi

# Source additional local configurations if they exist
if [ -f ~/.ksh_aliases ]; then
    . ~/.ksh_aliases
fi
