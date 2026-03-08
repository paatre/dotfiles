#!/bin/bash

# Configuration
CONTAINER_NAME="setup-test-fresh"
IMAGE="ubuntu:24.04"
DOTFILES_DIR="$HOME/dotfiles"  # Adjust this to your local dotfiles path

echo "🚀 Starting Fresh LXC Test..."

# 1. Cleanup existing container
if lxc info "$CONTAINER_NAME" >/dev/null 2>&1; then
    echo "♻️ Deleting old container..."
    lxc delete -f "$CONTAINER_NAME"
fi

# 2. Launch fresh container
echo "🏗️ Launching $IMAGE..."
lxc launch "$IMAGE" "$CONTAINER_NAME"

# Wait for network to be ready
echo "🌐 Waiting for network connectivity..."
ITER=0
MAX_RETRIES=30
while ! lxc exec "$CONTAINER_NAME" -- ping -c 1 -W 1 google.com >/dev/null 2>&1; do
    printf "."
    sleep 1
    ITER=$((ITER+1))
    if [ $ITER -ge $MAX_RETRIES ]; then
        echo -e "\n❌ Error: Network timeout in $CONTAINER_NAME"
        exit 1
    fi
done
echo -e "\n✨ Network is up!"

# 3. Push files
echo "📤 Pushing dotfiles and setup.sls..."
# Push the whole directory to the container
lxc file push -r "$DOTFILES_DIR" "$CONTAINER_NAME/root/"

# 4. Run Bootstrap
echo "⚡ Running Bootstrap..."
lxc exec "$CONTAINER_NAME" -- bash -c "cd /root/dotfiles && chmod +x bootstrap.sh && ./bootstrap.sh"

echo "✅ Deployment Complete!"
echo "💻 Enter the container with: lxc exec $CONTAINER_NAME -- bash"
