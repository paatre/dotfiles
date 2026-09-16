#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_ROOT="$REPO_ROOT/ansible"

usage() {
    cat <<'USAGE'
Usage:
  ./ansible-local.sh list [tags]
  ./ansible-local.sh check [tags]
  ./ansible-local.sh apply [tags]

Examples:
  ./ansible-local.sh list
  ./ansible-local.sh check repos
  ./ansible-local.sh check keyboard,ptyxis
  ./ansible-local.sh apply installs

Tags mirror the Salt state names: repos, packages, installs, system for the
groups, and docker, nvm, keyboard and so on for individual states.
USAGE
}

[ $# -ge 1 ] || { usage; exit 1; }

command="$1"
shift

tags=()
if [ $# -ge 1 ]; then
    tags=(--tags "$1")
    shift
fi

cd "$ANSIBLE_ROOT"

case "$command" in
    list)
        ansible-playbook site.yml --list-tasks "${tags[@]}" "$@"
        ;;
    check)
        ansible-playbook site.yml --check --diff "${tags[@]}" "$@"
        ;;
    apply)
        # Tasks that touch the system escalate with become; user-level ones do
        # not. --ask-become-pass covers the former without prompting on runs
        # that only touch dconf or the home directory.
        ansible-playbook site.yml --diff --ask-become-pass "${tags[@]}" "$@"
        ;;
    *)
        usage
        exit 1
        ;;
esac
