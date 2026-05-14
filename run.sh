#!/bin/bash
set -e

TASK_DIR="/root/task"

echo "[run.sh] Starting PostgreSQL container..."
docker-compose -f "$TASK_DIR/docker-compose.yml" up -d

echo "[run.sh] Waiting for PostgreSQL to be ready..."
until docker exec edtech_postgres pg_isready -U edtech_user -d edtech_db > /dev/null 2>&1; do
  echo "[run.sh] PostgreSQL not ready yet, retrying in 2 seconds..."
  sleep 2
done
echo "[run.sh] PostgreSQL is ready."

echo "[run.sh] Loading database schema and sample data..."
docker exec -i edtech_postgres psql -U edtech_user -d edtech_db < "$TASK_DIR/init_database.sql"
echo "[run.sh] Database initialized successfully."

echo "[run.sh] Installing Python dependencies..."
pip install -r "$TASK_DIR/requirements.txt" --quiet
echo "[run.sh] Python dependencies installed."

echo "[run.sh] Environment is ready. You may now work on main.py in $TASK_DIR"
