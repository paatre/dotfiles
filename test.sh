#!/bin/bash
set -euo pipefail

CONTAINER_NAME="setup-test-fresh"
IMAGE="ubuntu:25.10"
DOTFILES_DIR="$HOME/dotfiles"
STATE="${1:-}"

if [ $# -gt 1 ]; then
    echo "Usage: ./test.sh [state]"
    exit 1
fi

if [ -n "$STATE" ] && [[ ! "$STATE" =~ ^[A-Za-z0-9_.-]+$ ]]; then
    echo "Invalid state name: $STATE"
    exit 1
fi

echo "🚀 Starting Fresh LXC Test..."

if lxc info "$CONTAINER_NAME" >/dev/null 2>&1; then
    echo "♻️ Deleting old container..."
    lxc delete -f "$CONTAINER_NAME"
fi

echo "🏗️ Launching $IMAGE..."
lxc launch "$IMAGE" "$CONTAINER_NAME"

echo "🌐 Waiting for network connectivity..."
TIMEOUT=15
while ! lxc exec "$CONTAINER_NAME" -- ping -c 1 -W 1 google.com >/dev/null 2>&1; do
    printf "."
    sleep 1
    ((TIMEOUT--))
    if [ $TIMEOUT -le 0 ]; then
        echo -e "\n❌ Error: Network timeout. Check host bridge."
        exit 1
    fi
done
echo -e "\n✨ Online!"

echo "📤 Pushing dotfiles and setup.sls..."
lxc file push -r "$DOTFILES_DIR" "$CONTAINER_NAME/root/"

if [ -n "$STATE" ]; then
    echo "⚡ Installing Salt and dry-running state: $STATE"
    lxc exec "$CONTAINER_NAME" -- bash -c 'cd /root/dotfiles && chmod +x bootstrap.sh salt-local.sh && ./bootstrap.sh --salt-only && ./salt-local.sh test "$1"' -- "$STATE"
else
    echo "⚡ Running Bootstrap..."
    lxc exec "$CONTAINER_NAME" -- bash -c "cd /root/dotfiles && chmod +x bootstrap.sh salt-local.sh && ./bootstrap.sh"
fi

echo "✅ Deployment Complete!"
echo "💻 Enter the container with: lxc exec $CONTAINER_NAME -- bash"
