#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

echo "🚀 Bootstrapping the system..."

as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

ensure_salt_installed() {
    if command -v salt-call &> /dev/null; then
        return
    fi

    echo "Adding Salt Project repository..."
    as_root mkdir -m 755 -p /etc/apt/keyrings
    curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | gpg --dearmor | as_root tee /etc/apt/keyrings/salt-archive-keyring.pgp > /dev/null
    curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | as_root tee /etc/apt/sources.list.d/salt.sources

    echo "Installing Salt..."
    as_root apt update
    as_root apt install -y salt-minion
}

if [ "${1:-}" = "--salt-only" ]; then
    ensure_salt_installed
    echo "✅ Salt installed successfully!"
    exit 0
fi

if [ $# -ne 0 ]; then
    echo "Usage: ./bootstrap.sh [--salt-only]"
    exit 1
fi

ensure_salt_installed

export SUDO_USER_HOME=$HOME
"$REPO_ROOT/salt-local.sh" highstate

echo "✅ System state applied successfully!"
