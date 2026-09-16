#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_ROOT="$REPO_ROOT/ansible"

usage() {
    cat <<'USAGE'
Usage:
  ./ansible-local.sh list [tags] [--no-pass] [ansible-playbook args...]
  ./ansible-local.sh check [tags] [--no-pass] [ansible-playbook args...]
  ./ansible-local.sh apply [tags] [--no-pass] [ansible-playbook args...]

Examples:
  ./ansible-local.sh list
  ./ansible-local.sh check
  ./ansible-local.sh check repos,packages
  ./ansible-local.sh apply installs
  ./ansible-local.sh check keyboard --no-pass

Tags mirror the Salt state names: repos, packages, installs and system for the
groups, and docker, nvm, keyboard and so on for individual states.

Tasks that touch the system escalate with become, so a sudo password is asked
for unless sudo is already cached. Tags that only configure the user's desktop
or home directory need no privileges at all -- pass --no-pass to skip the
prompt for those.
USAGE
}

[ $# -ge 1 ] || { usage; exit 1; }

command="$1"
shift

# Pull --no-pass out of the arguments wherever it appears; everything else is
# passed through to ansible-playbook untouched.
ask_become=true
args=()
for arg in "$@"; do
    case "$arg" in
        --no-pass) ask_become=false ;;
        *) args+=("$arg") ;;
    esac
done
set -- ${args[@]+"${args[@]}"}

# The first remaining argument, if it is not a flag, is the tag list.
tag_args=()
if [ $# -ge 1 ] && [[ "$1" != -* ]]; then
    tag_args=(--tags "$1")
    shift
fi

become_args=()
if [ "$ask_become" = true ] && ! sudo -n true 2>/dev/null; then
    become_args=(--ask-become-pass)
fi

cd "$ANSIBLE_ROOT"

case "$command" in
    list)
        ansible-playbook site.yml --list-tasks ${tag_args[@]+"${tag_args[@]}"} "$@"
        ;;
    check)
        ansible-playbook site.yml --check --diff \
            ${tag_args[@]+"${tag_args[@]}"} ${become_args[@]+"${become_args[@]}"} "$@"
        ;;
    apply)
        ansible-playbook site.yml --diff \
            ${tag_args[@]+"${tag_args[@]}"} ${become_args[@]+"${become_args[@]}"} "$@"
        ;;
    *)
        usage
        exit 1
        ;;
esac
