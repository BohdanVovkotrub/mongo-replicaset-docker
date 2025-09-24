#!/bin/bash


mongosh --quiet --port ${PORT_MONGO1} --eval "db.adminCommand(\"ping\")" \
|| mongosh --quiet --port ${PORT_MONGO1} -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --eval "db.adminCommand(\"ping\")";

if [ $? -ne 0 ]; then
  echo "MongoDB is not healthy"
  exit 1
else
  echo "MongoDB is healthy"
  exit 0
fi


