#!/bin/bash
bash /container_scripts/set-my-timezone.sh

if [ -f /data/db/replica_initialized.flag ]; then
  rm -f /data/db/replica_initialized.flag
fi

/container_scripts/wait-for-it.sh mongo1:${PORT_MONGO1} -t ${TIMEOUT_INIT_REPLICA} -- \
mongosh -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --host mongo1 --eval "
  try {
    rs.status();
    print('Replica set already initialized.');
  } catch (e) {
    var timeoutReplica = parseInt(${TIMEOUT_INIT_REPLICA}) * 1000 * 1.5;
    print('Replica set not initialized. Proceeding with initialization...');
    print('>>> Sleep for ' + timeoutReplica + ' started');
    sleep(timeoutReplica);
    print('>>> Sleep finished');
    rs.initiate({
      _id: '${REPLICA_ID}',
      members: [
        { _id: 0, host: '${RS_PUBLIC_HOST1}:${PORT_MONGO1}' },
        { _id: 1, host: '${RS_PUBLIC_HOST2}:${PORT_MONGO2}' },
        { _id: 2, host: '${RS_PUBLIC_HOST3}:${PORT_MONGO3}' }
      ]
    });
    if (!rs.status().ok) {
      quit(1);
    }
  }
"

if [ $? -eq 0 ]; then
  touch /data/db/replica_initialized.flag
else
  echo 'Replica set initialization failed!'
  exit 1
fi