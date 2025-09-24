#!/bin/bash

cd "${main_dir:-.}"

ENV_FILE=".env"

if [ -f "$ENV_FILE" ]; then
    echo "\"$ENV_FILE\" already exists. Skip creating \"$ENV_FILE\" ..."
else
    echo "Creating .env config ..."
    touch "$ENV_FILE"

    # Read from .env.example
    while IFS= read -r line || [ -n "$line" ]; do
        [ -z "$line" ] && continue
        KEY="${line%%=*}"
        DEFAULT_VALUE="${line#*=}"

        # Check if key already exists in .env
        if ! grep -q "^$KEY=" "$ENV_FILE"; then
            read -p "Input value for \"$KEY\" [${DEFAULT_VALUE}]: " VAR_VALUE
            VAR_VALUE="${VAR_VALUE:-$DEFAULT_VALUE}"

            # Remove quotes from input
            VAR_VALUE="${VAR_VALUE%\"}"
            VAR_VALUE="${VAR_VALUE#\"}"

            # If value contains spaces, wrap in quotes
            if [[ "$VAR_VALUE" =~ [[:space:]] ]]; then
                VAR_VALUE="\"$VAR_VALUE\""
            fi

            echo "$KEY=$VAR_VALUE" >> "$ENV_FILE"
        fi
    done < .env.example
fi

# Load environments from .env
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi