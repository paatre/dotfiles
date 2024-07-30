# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tiikeri/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/tiikeri/.fzf/bin"
fi

eval "$(fzf --bash)"
