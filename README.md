# 🐳 Docker Compose for MongoDB Replica Set

## ⚙️ How to Use

1. Clone this repo  
2. Navigate to the downloaded repo folder  
3. Create a `.env` file using `.env.example` as a template:  
   - Rename `.env.example` to `.env`, or  
   - Copy and modify as needed  
4. To **start**, run:  
   ```
   run.cmd
   ```
5. On the first launch, **enter `Y`** when asked to initialize the MongoDB Replica Set  
6. To **stop**, run:  
   ```
   stop.cmd
   ```

---

## ⚠️ Important Notes

- 🔑 **Key File Required**:  
  You **must generate your own** `mongo-replication.key` and replace the default file.  
  See MongoDB documentation:  
  👉 https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-with-keyfile-access-control/

- 🕒 **Replica Init Timeout**:  
  If the Replica Set isn't working, increase the `TIMEOUT_INIT_REPLICA` value in your `.env` file.  
  Minimum recommended value: `40` seconds (enough for all nodes to fully start).

- 🧪 **[One Box Mode] (for testing only)**:  
  You can run all containers (Primary + Secondary-1 + Secondary-2) on **one host**.  
  ⚠️ Not recommended for production – defeats the purpose of replica setup.  
  Recommended: run **Primary** on one physical host, and **Secondaries** on others.

---

## 🧩 Connect with MongoDB Compass

Use the following URI in MongoDB Compass:

```
mongodb://<username>:<password>@<HOST_PRIMARY>:<PORT_PRIMARY>,<HOST_SECONDARY1>:<PORT_SECONDARY_1>,<HOST_SECONDARY2>:<PORT_SECONDARY_2>/
```

### Example:

```
mongodb://admin:Qwerty123@192.168.1.101:27017,192.168.1.102:27018,192.168.1.103:27019/
```

---

## 💻 Connect with Node.js

See examples in:  
```
examples/nodejs/
```