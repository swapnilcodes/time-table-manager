import mongoose from 'mongoose';

const userSchema = mongoose.Schema({
  name: { type: String, required: true },
  emailId: { type: String, required: true },
  password: { type: String, required: true },
  emailToken: { type: Number, default: null },
  emailTokenExpires: { type: Date, default: null },
  active: { type: Boolean, default: false },
  timeTables: [String],
  userId: { type: String, required: true },
  accessToken: { type: String, default: null },
});

const userModel = mongoose.model('users', userSchema);

export default userModel;
