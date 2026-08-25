#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SALT_ROOT="$REPO_ROOT/salt"
RENDER_CACHE="${TMPDIR:-/tmp}/dotfiles-salt-cache-${UID:-$(id -u)}-$$"
RENDER_CONFIG="${TMPDIR:-/tmp}/dotfiles-salt-config-${UID:-$(id -u)}-$$"

export SUDO_USER_HOME="${SUDO_USER_HOME:-$HOME}"

usage() {
    cat <<'EOF'
Usage:
  ./salt-local.sh render <state>
  ./salt-local.sh test <state>
  ./salt-local.sh apply <state>
  ./salt-local.sh highstate

Examples:
  ./salt-local.sh render repos
  ./salt-local.sh test installs.nvm
  ./salt-local.sh apply system.dotfiles
  ./salt-local.sh highstate
EOF
}

salt_call_highstate() {
    local command=(salt-call \
        --local \
        --file-root="$SALT_ROOT" \
        -l info \
        --out=highstate \
        --force-color \
        "$@")

    if [ "$(id -u)" -eq 0 ]; then
        "${command[@]}"
    else
        sudo --preserve-env=SUDO_USER_HOME,SUDO_USER "${command[@]}"
    fi
}

salt_render() {
    mkdir -p "$RENDER_CACHE"
    mkdir -p "$RENDER_CONFIG"
    trap 'rm -rf "$RENDER_CACHE" "$RENDER_CONFIG"' EXIT

    salt-call \
        --local \
        --config-dir="$RENDER_CONFIG" \
        --file-root="$SALT_ROOT" \
        --cachedir="$RENDER_CACHE" \
        --log-file=/dev/null \
        -l info \
        --out=yaml \
        --force-color \
        "$@"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

command="$1"
shift

case "$command" in
    render)
        if [ $# -ne 1 ]; then
            usage
            exit 1
        fi
        salt_render state.show_sls "$1"
        ;;
    test)
        if [ $# -ne 1 ]; then
            usage
            exit 1
        fi
        salt_call_highstate state.sls "$1" test=True
        ;;
    apply)
        if [ $# -ne 1 ]; then
            usage
            exit 1
        fi
        salt_call_highstate state.sls "$1"
        ;;
    highstate)
        if [ $# -ne 0 ]; then
            usage
            exit 1
        fi
        salt_call_highstate state.apply
        ;;
    *)
        usage
        exit 1
        ;;
esac
