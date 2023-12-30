alias python=python3

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsg="ls --group-directories-first"

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias cal="if [ -t 1 ] ; then ncal -b ; else /usr/bin/cal ; fi"

