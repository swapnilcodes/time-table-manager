import bcrpyt from 'bcrypt';

const encodeString = async (password) => {
  if (!password) {
    return {
      hashErr: 'parameter aapke pitaashri bharenge',
      hashedPassword: null,
    };
  }
  try {
    const saltRounds = 10;

    const hashedPassword = await bcrpyt.hash(password, saltRounds);

    return { hashErr: null, hashedPassword };
  } catch (err) {
    return { hashErr: err };
  }
};

const compareHash = async (password, hash) => {
  if (!password || !hash) {
    return { hashErr: 'parameter aapke pitaashri bharenge', matches: null };
  }

  try {
    const result = await bcrpyt.compare(password, hash);

    console.log(`result ${result}`);

    return { hashErr: null, matches: result };
  } catch (err) {
    return { hashErr: err, matches: null };
  }
};

export { encodeString, compareHash };
