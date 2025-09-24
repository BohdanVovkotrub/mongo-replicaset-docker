#!/bin/bash

set -e

main_dir="$(pwd)"
cd "$main_dir"

FOLDER="data"

if [ ! -d "$FOLDER" ]; then
    echo "Folder \"$FOLDER\" does not exist."
    exit 0
fi

while true; do
    read -p "Are you sure you want to delete the folder '$FOLDER' along with all its contents? (y/n): " CONFIRM
    case "$CONFIRM" in
        [Yy] )
            rm -rf "$FOLDER"
            echo "Folder \"$FOLDER\" removed."
            break
            ;;
        [Nn] )
            echo "Canceled by user."
            break
            ;;
        * )
            echo "Please, input only Y or N"
            ;;
    esac
done

# Optional: Wait a bit before exit (similar to timeout)
sleep 3