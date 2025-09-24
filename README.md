# Docker Compose for Mongodb Replica Set

<hr>

# Requirements

Docker  
Docker-Compose

> I recommend using **Docker Desktop** because it is easier to use and contains all the necessary Docker modules, such as Compose and others.

<br>

## Configure before using

1. **Set environment variables:**  
   Copy `.env.example` to `.env` and edit values as needed, or let the script prompt you for values.

2. **Check Docker Compose template:**  
   Make sure `docker-compose-template.yml` is configured for your needs.


<br>

## `.env` file description

The `.env` file contains environment variables used to configure the MongoDB replica set and supporting services.  
You can copy `.env.example` to `.env` and adjust values as needed.

**Main variables:**

- `DOCKERHUB_IMAGE_MONGO` — Docker image for MongoDB.
- `DOCKER_NETWORK_NAME` — Name of the Docker network for containers.
- `DOCKER_COMPOSE_NAME` — Name of the generated Docker Compose file.
- `DOCKER_COMPOSE_TEMPLATE_NAME` — Name of the Docker Compose template file.
- `KEYFILE_NAME` — Name of the keyfile for replica set authentication.
- `REPLICA_ID` — Replica set ID.
- `MONGO_INITDB_ROOT_USERNAME` — MongoDB root username.
- `MONGO_INITDB_ROOT_PASSWORD` — MongoDB root password.
- `RS_PUBLIC_HOST1`, `RS_PUBLIC_HOST2`, `RS_PUBLIC_HOST3` — Hostnames or IP addresses for the MongoDB nodes (`mongo1`, `mongo2`, and `mongo3`).  
  If all your MongoDB clients run inside Docker on the same network as the replica set, you can use the default values: `mongo1`, `mongo2`, and `mongo3`. 
  If you need to connect from external services (outside Docker), set these variables to the IP address of your Docker host where the replica set is running.  
  Alternatively, you can keep the default values and add the following lines to your `/etc/hosts` file on the client machine:
  ```
  127.0.0.1       mongo1
  127.0.0.1       mongo2
  127.0.0.1       mongo3
  ```
- `PORT_MONGO1`, `PORT_MONGO2`, `PORT_MONGO3` — Ports for MongoDB nodes.
- `TIMEOUT_INIT_REPLICA` — Timeout (in seconds) for replica set initialization.
- `TZ` — Timezone for containers.
- `DOCKERHUB_IMAGE_MONGO_EXPRESS` — Docker image for mongo-express.
- `ME_EXPORT_PORT` — Port for mongo-express web UI.
- `ME_CONFIG_BASICAUTH` — Enable basic authentication for mongo-express web interface.
- `ME_CONFIG_BASICAUTH_USERNAME`, `ME_CONFIG_BASICAUTH_PASSWORD` — Credentials for mongo-express web interface.
- `ME_CONFIG_MONGODB_ENABLE_ADMIN` — Enable admin access in mongo-express.


<br>

## How to use it

Firstly, go to this folder:
```
cd "<path-to-this-folder>"
```

<br>

### Windows

**To run:**

Double click on `run.cmd`  
or run in Command Line (or PowerShell):
```
run.cmd
```

**To stop and remove containers:**
```
stop.cmd
```

**To remove all MongoDB data:**
```
remove-data.cmd
```

<br>

### Linux / MacOS

**To run:**
```
./run.sh
```

**To stop and remove containers:**
```
./stop.sh
```

**To remove all MongoDB data:**
```
./remove-data.sh
```

> If you get a "Permission denied" error, make scripts executable:
```
chmod +x *.sh scripts/*.sh container_scripts/*.sh
```

<br>

## What happens when you run the scripts?

- `.env` will be created and loaded with environment variables.
- Docker network will be created if it does not exist.
- Docker Compose file will be generated from the template.
- MongoDB replica set containers and mongo-express will be started.
- The folder `data` will be created. This folder contain all data from containers.

**Containers created:**
- `first-init`  
  *Generates the MongoDB keyfile for replica set authentication and sets permissions for scripts in forlder "container_scripts". Runs only once before other containers start.*

- `mongo1`  
  *Primary MongoDB node. Initializes the database and creates the root user if the data directory is empty. Starts as the first member of the replica set.*

- `mongo2`  
  *Secondary MongoDB node. Waits for `mongo1` to be ready before joining the replica set.*

- `mongo3`  
  *Secondary MongoDB node. Waits for `mongo1` to be ready before joining the replica set.*

- `mongo-init-replica`  
  *Initializes the replica set configuration after all MongoDB nodes are running. Adds all members to the replica set.*

- `mongo-express`  
  *Web-based MongoDB admin interface. Connects to the replica set and provides a UI for managing databases and collections after `mongo-init-replica` will stopped.*




<br>

## Thanks / Further Reading

* [Setting Up a 3-Node MongoDB Replica Set Cluster with Docker Compose](https://dev.to/denisakp/setting-up-a-3-node-mongodb-replica-set-cluster-with-docker-compose-50kn)
* [UpSync-Dev / docker-compose-mongo-replica-set](https://github.com/UpSync-Dev/docker-compose-mongo-replica-set)