import jwt from 'jsonwebtoken';

const generateJWT = (emailId) => {
  if (!emailId) {
    return { err: 'yaar parameter to bharo' };
  }

  const token = jwt.sign({ emailId }, 'swam@4782@__hello++world');

  return { token };
};

export default generateJWT;
