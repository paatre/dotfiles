#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

echo "🚀 Bootstrapping the system..."

# 1. Install Salt Minion from official Salt Project repo
if ! command -v salt-call &> /dev/null; then
    echo "Adding Salt Project repository..."
    sudo mkdir -m 755 -p /etc/apt/keyrings

    # Download the key and the source list
    curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | gpg --dearmor | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp > /dev/null
    curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources

    echo "Installing Salt..."
    sudo apt update
    sudo apt install -y salt-minion
fi

# 2. Run Salt in Masterless mode (--local)
# We pass the current directory's 'salt' folder as the file root
export SUDO_USER_HOME=$HOME
sudo --preserve-env=SUDO_USER_HOME salt-call --local --file-root="$(pwd)/salt" state.apply -l info --out=highstate --force-color

echo "✅ System state applied successfully!"
