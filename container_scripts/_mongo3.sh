#!/bin/bash
bash /container_scripts/set-my-timezone.sh
echo "Waiting for mongo1 to be restarted for first time..."

if [ -z "$(ls -A /data/db)" ]; then
  echo "MongoDB data directory is empty. Waiting for mongo1 to be ready..."
  /container_scripts/wait-for-it.sh mongo1:${PORT_MONGO1} -t ${TIMEOUT_INIT_REPLICA} -- \
  echo "sleep ${TIMEOUT_INIT_REPLICA}..." && sleep ${TIMEOUT_INIT_REPLICA} && echo "Sleep finished."
fi

/container_scripts/wait-for-it.sh mongo1:${PORT_MONGO1} -t ${TIMEOUT_INIT_REPLICA} -- \
mongod --quiet --replSet "${REPLICA_ID}" --bind_ip_all --port ${PORT_MONGO3} --keyFile /data/keyfiles/keyfile.key
