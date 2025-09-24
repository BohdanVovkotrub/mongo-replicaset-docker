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