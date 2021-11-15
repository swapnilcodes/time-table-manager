import userModel from '../models/User.js';

const getMyInfo = async (req, res) => {
  try {
    const { user } = req;

    if (!user) {
      return res.status(400).send('kucch to gadbad hai daya');
    }

    const userData = await userModel.findOne({ emailId: user.emailId });

    if (!userData) {
      return res.status(400).send('tera account zinda hi nhi hai yaar');
    }

    return res.status(200).json(userData);
  } catch (err) {
    return res.status(400).send(err);
  }
};

export default getMyInfo;
