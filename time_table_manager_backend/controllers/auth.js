import userModel from '../models/User.js';
import { nanoid } from 'nanoid';
import sendCodeMail from '../helpers/sendAuthMail.js';
import generateJWT from '../helpers/generateJWT.js';
import { encodeString, compareHash } from '../helpers/crypt.js';

const signUp = async (req, res) => {
  const { name, emailId, password } = req.body;

  if (!name || !emailId || !password) {
    return res.status(400).send('fill all credentials');
  }

  const userId = nanoid();

  const alreadyExists = await userModel.findOne({ emailId });

  if (alreadyExists) {
    return res
      .status(400)
      .send('A account already exists from the specified emailId');
  }

  // generating a random 6 digit code to send as OTP
  let code = Math.floor(100000 + Math.random() * 900000);

  let expiry = Date.now() + 60 * 1000 * 15;

  const err = await sendCodeMail(code, emailId);
  if (err) {
    return res.status(400).send(err);
  }

  const { hashErr, hashedPassword } = await encodeString(password);

  if (hashErr) {
    return res.status(400).send('An error occured try again');
  }

  await userModel.create({
    name,
    emailId,
    userId,
    password: hashedPassword,
    emailToken: code,
    emailTokenExpires: new Date(expiry),
  });

  return res.status(201).send('Account created and sent activation code');
};

const activateAcc = async (req, res) => {
  const { emailId, otp } = req.body;

  if (!emailId || !otp) {
    return res.status(400).send('Fill all credentials');
  }

  const userData = await userModel.findOne({
    emailId,
    emailToken: otp,
    emailTokenExpires: { $gt: Date.now() },
  });

  if (!userData) {
    return res.status(400).send('Invalid Credentials');
  }

  if (userData.active) {
    return res.status(400).send('Account already activated');
  }

  userData.active = true;

  userData.emailToken = null;

  userData.emailTokenExpires = null;

  await userData.save();

  return res.status(201).send('Activated Your Account');
};

const login = async (req, res) => {
  const { emailId, password } = req.body;

  if (!emailId || !password) {
    res.status(400).send('Fill all credentials');
  }

  const userData = await userModel.findOne({ emailId });

  if (!userData) {
    return res.status(400).send('Pehle signup karo baba');
  }

  const { hashErr, matches } = await compareHash(password, userData.password);

  console.log(hashErr);

  console.log(matches);

  if (hashErr) {
    return res.status(400).send(hashErr);
  }

  if (!matches) {
    return res.status(400).send('AAsatya password');
  }

  if (!userData.active) {
    return res.status(400).send('Account Activate karo pehle dada');
  }

  const { err, token } = generateJWT(emailId);

  if (err) {
    return res.status(500).send(err);
  }

  userData.accessToken = token;

  await userData.save();

  return res
    .status(200)
    .json({ message: 'hogaya bhai login tu', data: userData });
};

export { signUp, activateAcc, login };
