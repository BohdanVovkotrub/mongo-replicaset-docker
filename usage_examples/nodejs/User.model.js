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