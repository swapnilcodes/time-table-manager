import nodemailer from 'nodemailer';

const sendCodeMail = (otp, reciever) => {
  const message = `<h1>Your OTP for verifying your account is ${otp}</h1>`;

  var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'deshmaneswapnil737@gmail.com',
      pass: 'swam@4782s',
    },
  });

  const mailOptions = {
    from: 'deshmaneswapnil737@gmail.com',
    to: reciever,
    subject: 'Activate Your Account',
    text: '',
    html: message,
  };

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      return err;
    }
    console.log('message sent: ' + info.messageId);
  });
};

export default sendCodeMail;
