# python aliases
alias python=python3

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsg="ls --group-directories-first"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

