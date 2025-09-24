#!/bin/bash

if [ -f /data/keyfiles/keyfile.key ]; then
    echo 'Keyfile already exists. Skipping generation.';
    exit 0;
else
    openssl rand -base64 756 > /data/keyfiles/keyfile.key;
    chmod 400 /data/keyfiles/keyfile.key;
    chown mongodb:mongodb /data/keyfiles/keyfile.key;
    echo 'Keyfile generated and permissions set.';
fi

bash /container_scripts/set-my-timezone.sh;
echo 'Now You can start the MongoDB containers!';
exit 0;
