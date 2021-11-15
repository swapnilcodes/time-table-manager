import express from 'express';
import mongoose from 'mongoose';
import Cors from 'cors';
import { signUp, activateAcc, login } from './controllers/auth.js';

// app config
const app = express();

const connectionUrl =
  'mongodb+srv://admin:swam4782s@cluster0.evz5t.mongodb.net/timeTableDb?retryWrites=true&w=majority';

mongoose
  .connect(connectionUrl, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .catch((err) => {
    console.log(err);
  });

const PORT = process.env.PORT || 5000;

// middlewares
app.use(express.json({ limit: '90mb' }));
app.use(Cors());

// starting the server
const db = mongoose.connection;

db.once('open', () => {
  console.log('connected to mongodb');

  app.listen(PORT, () => {
    console.log(`server started on ${PORT}`);
  });
});

//routes
app.get('/', (req, res) => {
  res.status(200).send('Namaste Chacha');
});

app.post('/signup', signUp);

app.post('/activateAccount', activateAcc);

app.post('/login', login);
