# Docker Compose for MongoDB Replica Set 

## How to use it

1. clone this repo
2. go to the downloaded repo
3. Create a file ```.env``` as in example ```.env.example```
   or rename ```.env.example``` to ```.env```
4. In ```.env```
   set the address of PC with docker desktop (docker engine) for GUEST_HOST
   set USERNAME and PASSWORD which will be created.
6. To running run ```run-mongodb.cmd```
7. Please, input Y if you run this at the first time while Init the mongoDB Replica Set.
8. To stop run ```run-mongodb.cmd```


To connect in Mongo Compass use this URI:

mongodb://<username>:<password>@<GUEST_HOST>:27017,<GUEST_HOST>:27018,<GUEST_HOST>:27019/ 


## How to connect to this mongodb using NodeJS

Install mongoose from NPM:

```
npm i dotenv mongoose bcrypt
```


```
//// MongoDB.js
const mongoose = require('mongoose');

const thisScriptPath = `./MongoDB.js`;

class MongoDB {
  constructor(mongodbConfig) {
    this.username = mongodbConfig.MONGO_USERNAME;
    this.password = mongodbConfig.MONGO_PASSWORD;
    this.replicaSetId = mongodbConfig.MONGO_REPLICA_SET_ID;
    this.host_primary = mongodbConfig.MONGO_HOST_PRIMARY;
    this.port_primary = mongodbConfig.MONGO_PORT_PRIMARY;
    this.host_secondary_1 = mongodbConfig.MONGO_HOST_SECONDARY_1;
    this.port_secondary_1 = mongodbConfig.MONGO_PORT_SECONDARY_1;
    this.host_secondary_2 = mongodbConfig.MONGO_HOST_SECONDARY_2;
    this.port_secondary_2 = mongodbConfig.MONGO_PORT_SECONDARY_2;
    this.dbName = mongodbConfig.MONGO_DB;

  };

  connectToReplicaSet = async () => {
    try {
      const hosts = [
        `${this.host_primary}:${this.port_primary}`,
        `${this.host_secondary_1}:${this.port_secondary_1}`,
        `${this.host_secondary_2}:${this.port_secondary_2}`,
      ];
      const uri = `mongodb://${hosts.join(',')}/?replicaSet=${this.replicaSetId}`;
      await mongoose.connect(uri, {
        dbName: this.dbName,
        auth: {
          username: this.username,
          password: this.password,
        },
      });
      console.log(`Connected to MongoDB <${uri}>`);
      return;
    } catch (error) {
      console.error(`Error while <connectToReplicaSet> in class <${this.constructor.name}> in script <${thisScriptPath}>:`, error?.message);
      throw error;
    };
  };
};

module.exports = MongoDB;
```

```
//// User.model.js
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const SALT_WORK_FACTOR = 10;

function generateRandomPassword(length = 12) {
  const alphabet = 'abcdefghijklmnopqrstuvwxyz';
  const uppercaseAlphabet = alphabet.toUpperCase();
  const numbers = '0123456789';
  const symbols = '!@#$%^&*()_+-=[]{}|;:",.<>?/`~';
  const combinedArray = [...alphabet, ...uppercaseAlphabet, ...numbers, ...symbols];
  const getRandomOne = () => combinedArray[Math.floor(Math.random() * combinedArray.length)];
  const password = new Array(length).map(getRandomOne).join('');
  return password;
};

async function hashPassword(password = '') {
  const salt = await bcrypt.genSalt(SALT_WORK_FACTOR);
  const hashedPassword = await bcrypt.hash(password, salt);
  return hashedPassword;
};

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    match: /^(?!\\.)(?!.*\\.\\.)[a-zA-Z0-9\\.]{1,253}(?<!\\.)$/,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    default: '',
  },
  email: {
    type: String,
    match: /^$|^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    default: "",
  },
  description: {
    type: String,
    match: /^.{0,1024}$/,
    default: "",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});
async function preSave(next) {
  try {
    this.set({ updatedAt: Date.now() });
    if (!this.password) {
      this.set({password: generateRandomPassword()});
    }
    if (this.isModified('password') === true) {
      const hashedPassword = await hashPassword(this.password);
      this.set({ password: hashedPassword });
    };
    return next();
  } catch (error) {
    next(error);
  }
};
async function postSave(savedUser, next) {
  try {
    if (!savedUser) return;
    console.log(`New user named <${savedUser.name}> was created with id <${savedUser._id}>`);
    next();
  } catch (error) {
    next(error);
  }
};
async function preFindOneAndUpdate() {
  const oldUser = await this.model.findOne(this.getQuery()); 
  if (!oldUser) throw ApiError.DataNotFound();
  this._oldUser = oldUser;
  const update = this.getUpdate();
  if (!!update.password) {
    const hashedPassword = await hashPassword(update.password);
    this.set({ password: hashedPassword });
  };
  this.set({ updatedAt: Date.now() });
};
userSchema.pre('save', preSave);
userSchema.post('save', postSave);
userSchema.pre('findOneAndUpdate', preFindOneAndUpdate);

const User = mongoose.model('User', userSchema);
module.exports = User;
```


```
//// index.js
require('dotenv').config();
const MongoDB = require('./MongoDB.js');
const User = require('./User.model.js');

const thisScriptPath = `./index.js`;

const run = async (mongodbConfig) => {
 try {
   const mongodb = new MongoDB(mongodbConfig);
   await mongodb.connectToReplicaSet();
   return;
 } catch (error) {
   console.error(`Error while <run> in script <${thisScriptPath}>:`, error?.message);
   throw error;
 }
};

const createNewUser = async () => {
   try {
      const totalCount = await User.countDocuments();
      const name = `user_${parseInt(totalCount) + 1}`;
      const createdUser = await User.create({name});
      return createdUser;
    } catch (error) {
      console.error(`Error while <createNewUser> in script <${thisScriptPath}>:`, error?.message);
      throw error;
    }
};

const using = async () => {
    try {
      const initData = {
           config: {
             mongodbConfig: {
               MONGO_REPLICA_SET_ID: process.env.MONGO_REPLICA_SET_ID,
               MONGO_HOST_PRIMARY: process.env.MONGO_HOST_PRIMARY,
               MONGO_PORT_PRIMARY: process.env.MONGO_PORT_PRIMARY,
               MONGO_HOST_SECONDARY_1: process.env.MONGO_HOST_SECONDARY_1, 
               MONGO_PORT_SECONDARY_1: process.env.MONGO_PORT_SECONDARY_1,
               MONGO_HOST_SECONDARY_2: process.env.MONGO_HOST_SECONDARY_2,
               MONGO_PORT_SECONDARY_2: process.env.MONGO_PORT_SECONDARY_2,
               MONGO_USERNAME: process.env.MONGO_USERNAME,
               MONGO_PASSWORD: process.env.MONGO_PASSWORD,
               MONGO_DB: process.env.MONGO_DB,
             },
           },
         };

      await run(initData.config.mongodbConfig);
      const createdUser = await createNewUser();
      console.log({createdUser});
    } catch (error) {
      console.error(`Error while <using> in script <${thisScriptPath}>:`, error?.message);
      throw error;
    }
}
```

In Terminal run:

```
node index.js
```
