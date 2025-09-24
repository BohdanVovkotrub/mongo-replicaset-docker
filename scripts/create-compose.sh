#!/bin/bash

set -e

cd "${main_dir:-.}"

TEMPLATE_FILE="$1"
COMPOSE_FILE="$2"

if [ -z "$TEMPLATE_FILE" ] || [ -z "$COMPOSE_FILE" ]; then
  echo "Usage: $0 <template-file> <compose-file>"
  exit 1
fi

if [ -f "$COMPOSE_FILE" ]; then
  rm -f "$COMPOSE_FILE"
fi

cp "$TEMPLATE_FILE" "$COMPOSE_FILE"

{
  echo ""
  echo "networks:"
  echo "  ${DOCKER_NETWORK_NAME}:"
  echo "    external: true"
  echo ""
} >> "$COMPOSE_FILE"