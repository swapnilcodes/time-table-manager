import timeTableModel from '../models/TimeTable.js';
import userModel from '../models/User.js';
import { nanoid } from 'nanoid';

const createTimeTable = async (req, res) => {
  const { emailId } = req.user;

  if (!emailId) {
    return res.status(400).send('kucch to gadbad hai daya');
  }

  try {
    const userData = await userModel.findOne({ emailId });
    if (!userData) {
      return res.status(500).send('Aap lapata hai');
    }

    const existingTimeTables = await timeTableModel.find({ user: emailId })
      .length;

    if (existingTimeTables > 3) {
      return res
        .status(400)
        .send(`You've already reached maximum number of timeTables`);
    }

    const timeTableId = nanoid();

    await timeTableModel.create({
      user: emailId,
      timeTableId,
      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: [],
      sunday: [],
    });

    userData.timeTables.push(timeTableId);

    await userData.save();

    return res.status(201).send('created time table');
  } catch (err) {
    console.log(err);
    return res.status(500).send(err);
  }
};

const deleteTimeTable = () => {};

const getMyTimeTables = async (req, res) => {
  const { emailId } = req.user;

  if (!emailId) {
    return res.status(400).send('Kucch to gadbad hai daya');
  }

  try {
    const userData = await userModel.findOne({ emailId });

    if (!userData) {
      return res.status(400).send('Aap lapata hai');
    }

    const myTimeTables = await timeTableModel.find({ user: emailId });

    if (myTimeTables.length < 1) {
      return res.status(200).send("You haven't created any timeTables yet...");
    }

    return res.status(200).send(myTimeTables);
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

export { createTimeTable, deleteTimeTable, getMyTimeTables };
