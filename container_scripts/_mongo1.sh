#!/bin/bash
bash /container_scripts/set-my-timezone.sh

if [ -z "$(ls -A /data/db)" ]; then
  echo "MongoDB data directory is empty. Initializing..."
  sleep 2
  echo "Running init with entrypoint..."
  /usr/local/bin/docker-entrypoint.sh mongod --quiet --bind_ip_all --port ${PORT_MONGO1} & pid=$!
  echo "Waiting for MongoDB to be ready..."
  until mongosh --quiet --port ${PORT_MONGO1} -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
    sleep 2
  done
  echo "Root user <${MONGO_INITDB_ROOT_USERNAME}> created."
  echo "MongoDB is ready. Exiting to trigger container restart..."
  mongod --shutdown
  exit 0
else
  echo "MongoDB data directory is not empty. Skipping initialization."
  mongod --quiet --replSet "${REPLICA_ID}" --bind_ip_all --port ${PORT_MONGO1} --keyFile /data/keyfiles/keyfile.key
fi
