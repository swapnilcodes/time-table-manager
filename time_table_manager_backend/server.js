import express from 'express';
import mongoose from 'mongoose';
import Cors from 'cors';
import { signUp, activateAcc, login } from './controllers/auth.js';
import authJWT from './helpers/authorizeJWT.js';
import getMyInfo from './controllers/getMyInfo.js';
import {
  activateTimeTable,
  createTimeTable,
  deactivateTimeTable,
  deleteTimeTable,
  getMyTimeTables,
} from './controllers/timeTable.js';
import {
  addActivity,
  addActivitiesFromDay,
  copySingleActivityFromDay,
  copyActivitiesFromOtherTimeTable,
} from './controllers/activityManager.js';
import { setSocket } from './controllers/schedule.js';
import { createServer } from 'http';
import { Server } from 'socket.io';

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

  const httpServer = createServer(app, { cors: { origin: '*' } });

  const io = new Server(httpServer);

  io.on('connection', (socket) => {
    console.log(`new socket connected ${socket.id}`);
    setSocket(socket);
  });

  httpServer.listen(PORT, () => {
    console.log(`server started on port ${PORT}`);
  });
});

//routes
app.get('/', (req, res) => {
  res.status(200).send('Namaste Chacha');
});

app.post('/signup', signUp);

app.post('/activateAccount', activateAcc);

app.post('/login', login);

app.get('/getMyInfo', authJWT, getMyInfo);

app.post('/createTimeTable', authJWT, createTimeTable);

app.get('/getMyTimeTables', authJWT, getMyTimeTables);

app.delete('/deleteTimeTable', authJWT, deleteTimeTable);

app.put('/activateTimeTable', authJWT, activateTimeTable);

app.put('/addActivity', authJWT, addActivity);

app.put('/copyActivitiesFromDay', authJWT, addActivitiesFromDay);

app.put('/copySingleActivityFromDay', authJWT, copySingleActivityFromDay);

app.put(
  '/copyActivitiesFromOtherTimeTable',
  authJWT,
  copyActivitiesFromOtherTimeTable
);

app.delete('/deactivateTimeTable', authJWT, deactivateTimeTable);
