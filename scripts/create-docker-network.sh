#!/bin/bash

# Check if DOCKER_NETWORK_NAME is set
if [ -z "$DOCKER_NETWORK_NAME" ]; then
  echo "DOCKER_NETWORK_NAME environment variable is not set."
  exit 1
fi

if ! docker network inspect "$DOCKER_NETWORK_NAME" >/dev/null 2>&1; then
  echo "Creating network \"$DOCKER_NETWORK_NAME\""
  docker network create "$DOCKER_NETWORK_NAME"
fi