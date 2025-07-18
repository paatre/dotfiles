# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#
# Shell prompt settings
#

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#
# PATH management
#

# Environment variables for tools' paths
export PYENV_ROOT="$HOME/.pyenv"
export CARGO_HOME="$HOME/.cargo"
export DENO_INSTALL="$HOME/.deno"

# Initialize an array for custom paths to prepend to PATH
declare -a PREPEND_PATHS

if [[ -d "$PYENV_ROOT/bin" ]]; then
    PREPEND_PATHS+=("$PYENV_ROOT/bin")
fi

if [[ -d "$CARGO_HOME/bin" ]]; then
    PREPEND_PATHS+=("$CARGO_HOME/bin")
fi

if [[ -d "$DENO_INSTALL/bin" ]]; then
    PREPEND_PATHS+=("$DENO_INSTALL/bin")
fi

SYSTEM_GO_BIN="/usr/local/go/bin"

if [ -d "$SYSTEM_GO_BIN" ]; then
    PREPEND_PATHS+=("$SYSTEM_GO_BIN")

    GOPATH_BIN="$("$SYSTEM_GO_BIN/go" env GOPATH)/bin"

    if [ -d "$GOPATH_BIN" ]; then
        PREPEND_PATHS+=("$GOPATH_BIN")
    fi
fi

PREPEND_PATHS+=(
    "$HOME/dotfiles/bash/scripts/"  # Personal Bash scripts
    "$HOME/.local/bin"              # Local user binaries
)

if [ ${#PREPEND_PATHS[@]} -gt 0 ]; then
    export PATH="$(IFS=:; echo "${PREPEND_PATHS[*]}"):$PATH"
fi

unset PREPEND_PATHS SYSTEM_GO_BIN GOPATH_BIN

#
# Aliases
#

alias kernel='uname -sr'

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

alias '?'=duck
alias '??'=google

alias dc='docker compose'
alias dts=docker-tmux-setup

alias c=clear
alias tldr="tldr --auto-update-interval 1"

alias ai='ollama run llama3.1'

alias dotfiles='cd ~/dotfiles'

alias bashrc='nvim ~/.bashrc'
alias gitconfig='nvim ~/.gitconfig'
alias nv='nvim ~/.config/nvim/init.lua'
alias tmuxconf='nvim ~/.tmux.conf'

#
# Tab completion settings
#

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#
# Editor settings
#

# Set default editor
export EDITOR=nvim

#
# History settings
#

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# History (~/.bash_history) time format
HISTTIMEFORMAT="%d/%m/%y %T "

#
# Window settings
#

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#
# Globbing settings
#

# The pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#
# Less settings
#

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Don't create a .lesshst file to $HOME
export LESSHISTFILE="-"

#
# ZFZ settings
#
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Let ZFZ to find hidden files as well by default
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'

#
# NVM settings
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

#
# Node and NPM settings
#
export NODE_REPL_HISTORY=""

#
# Starship settings
#
eval "$(starship init bash)"

#
# Pyenv settings
#
eval "$(pyenv init -)"

#
# Zoxide settings
#
eval "$(zoxide init --cmd cd bash)"
