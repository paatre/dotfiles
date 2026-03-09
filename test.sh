#!/bin/bash

CONTAINER_NAME="setup-test-fresh"
IMAGE="ubuntu:24.04"
DOTFILES_DIR="$HOME/dotfiles"

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

echo "⚡ Running Bootstrap..."
lxc exec "$CONTAINER_NAME" -- bash -c "cd /root/dotfiles && chmod +x bootstrap.sh && ./bootstrap.sh"

echo "✅ Deployment Complete!"
echo "💻 Enter the container with: lxc exec $CONTAINER_NAME -- bash"
