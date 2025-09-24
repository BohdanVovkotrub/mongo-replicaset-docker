#!/bin/bash

set -e

main_dir="$(pwd)"
cd "$main_dir"

# Load environment variables and create .env if needed
./scripts/dotenv.sh

echo "$DOCKER_COMPOSE_NAME"
docker-compose -f "$DOCKER_COMPOSE_NAME" down -v --remove-orphans

# Optional: Wait a bit before exit (similar to timeout)
sleep 3