#!/bin/bash

set -e

main_dir="$(pwd)"
cd "$main_dir"

# Load environment variables and create .env if needed
./scripts/dotenv.sh

# Create Docker network if needed
./scripts/create-docker-network.sh

# Create docker-compose file from template
./scripts/create-compose.sh "$DOCKER_COMPOSE_TEMPLATE_NAME" "$DOCKER_COMPOSE_NAME"

# Start docker-compose
docker-compose -f "$DOCKER_COMPOSE_NAME" up -d

# Optional: Wait a bit before exit (similar to timeout)
sleep 3