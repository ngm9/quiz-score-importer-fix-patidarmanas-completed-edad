#!/bin/bash

TASK_DIR="/root/task"

echo "[kill.sh] Stopping and removing Docker containers..."
docker-compose -f "$TASK_DIR/docker-compose.yml" down --volumes --remove-orphans || true
echo "[kill.sh] Containers stopped."

echo "[kill.sh] Pruning all Docker resources (containers, images, volumes, networks)..."
docker system prune -a --volumes -f || true
echo "[kill.sh] Docker resources pruned."

echo "[kill.sh] Removing task directory $TASK_DIR..."
rm -rf "$TASK_DIR" || true
echo "[kill.sh] Task directory removed."

echo "[kill.sh] Cleanup complete."
