import jwt from 'jsonwebtoken';

const authJWT = (req, res, next) => {
  const authToken = req.header('authToken');

  if (!authToken) {
    return res.status(400).send('bhai token kidhar hai');
  }

  var decoded = jwt.verify(authToken, 'swam@4782@__hello++world');

  if (!decoded.emailId) {
    return res.status(400).send('invalid token');
  }

  req.user = decoded;

  next();
};

export default authJWT;
