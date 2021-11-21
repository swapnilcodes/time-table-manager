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

    const existingTimeTables = await timeTableModel.find({ user: emailId });

    console.log(existingTimeTables);

    if (existingTimeTables.length > 3) {
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
      active: false,
    });

    userData.timeTables.push(timeTableId);

    await userData.save();

    return res.status(201).send('created time table');
  } catch (err) {
    console.log(err);
    return res.status(500).send(err);
  }
};

const deleteTimeTable = async (req, res) => {
  const { timeTableId } = req.query;

  const { emailId } = req.user;

  if (!timeTableId) {
    return res.status(400).send('Fill all credentials');
  }

  if (!emailId) {
    return res.status(500).send('kucch to gadbad hai daya');
  }

  try {
    const userData = await userModel.findOne({ emailId });

    if (!userData) {
      return res.status(500).send('Aap lapata hai');
    }

    const timeTableExists =
      userData.timeTables.filter((value) => value === timeTableId).length > 0;

    if (!timeTableExists) {
      return res.status(400).send('Invalid TimeTable id');
    }

    await timeTableModel.deleteOne({ timeTableId });

    const newTimeTableList = userData.timeTables.filter(
      (value) => value !== timeTableId
    );

    userData.timeTables = newTimeTableList;

    await userData.save();

    return res.status(200).send('deleted Time table');
  } catch (err) {
    console.log(err);
    return res.status(500).send(err);
  }
};

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

const activateTimeTable = async (req, res) => {
  try {
    const { timeTableId } = req.body;

    const { emailId } = req.user;

    if (!emailId) {
      return res.status(400).send('kucch to gadbad hai daya');
    }

    if (!timeTableId) {
      return res.status(400).send('Fill all credentials');
    }

    const timeTableData = await timeTableModel.findOne({
      timeTableId,
      user: emailId,
    });

    if (!timeTableData) {
      return res.status(400).send('Invalid Time Table Data');
    }

    if (timeTableData.active) {
      return res.status(400).send('Time table already active');
    }

    const myTimeTables = await timeTableModel.find({ user: emailId });

    const activeTimeTables = myTimeTables.filter((value) => value.active);

    console.log(activeTimeTables);

    if (activeTimeTables.length > 0) {
      return res
        .status(400)
        .send(
          'Other time table is already active, deactivate it to activate this timetable'
        );
    }

    timeTableData.active = true;

    await timeTableData.save();

    return res.status(200).send('Activated this timetable');
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

export { createTimeTable, deleteTimeTable, getMyTimeTables, activateTimeTable };
