import userModel from '../models/User.js';
import timeTableModel from '../models/TimeTable.js';
import { nanoid } from 'nanoid';
import { manualAddSchedule } from './schedule.js';

const addActivity = async (req, res) => {
  const { emailId } = req.user;

  const {
    day,
    activityTitle,
    startingTimeHour,
    endingTimeHour,
    activityDescription,
    timeTableId,
    startingTimeMinute,
    endingTimeMinute,
  } = req.body;

  console.log(
    'day' + day,
    'activity title' + activityTitle,
    'starting time hour' + startingTimeHour,
    'ending time hour' + endingTimeHour,
    'activity description' + activityDescription,
    'time table id' + timeTableId,
    'starting time minute' + startingTimeMinute,
    'ending time minute' + endingTimeMinute
  );

  console.log(!day);
  console.log(!activityTitle);
  console.log(!startingTimeHour);
  console.log(!endingTimeHour);
  console.log(!activityDescription);
  console.log(!timeTableId);
  console.log(!startingTimeMinute);
  console.log(!endingTimeMinute);

  if (
    (!day ||
      !activityTitle ||
      !startingTimeHour ||
      !endingTimeHour ||
      !activityDescription ||
      !timeTableId ||
      !startingTimeMinute ||
      !endingTimeMinute) &&
    startingTimeMinute !== 0 &&
    startingTimeHour !== 0 &&
    endingTimeMinute !== 0 &&
    endingTimeHour !== 0
  ) {
    return res.status(400).send('fill all credentials');
  }

  if (activityTitle.length > 45) {
    return res.status(400).send('Too long activity Title');
  }

  if (activityDescription > 60) {
    return res.status(400).send('Too long activity description');
  }

  // time stuff
  if (startingTimeHour > 23 || startingTimeHour < 0) {
    return res.status(400).send('Invalid Starting Hour');
  }

  if (startingTimeMinute < 0 || startingTimeMinute > 59) {
    return res.status(400).send('Invalid Starting Minute');
  }

  if (endingTimeHour > 23 || endingTimeHour < startingTimeHour) {
    return res.status(400).send('Invalid Ending Hour');
  }

  if (endingTimeHour === startingTimeHour) {
    console.log(endingTimeMinute);
    console.log(startingTimeMinute);

    console.log(endingTimeMinute < startingTimeMinute);

    if (endingTimeMinute < startingTimeMinute) {
      return res.status(400).send('Bro are u a time traveller');
    }
  }

  if (endingTimeMinute < 0 || endingTimeMinute > 59) {
    return res.status(400).send('Invalid Ending Time Minute');
  }

  try {
    const userData = await userModel.findOne({ emailId });

    const timeTableData = await timeTableModel.findOne({ timeTableId });

    if (!userData) {
      return res.status(400).send('Aap lapata ho..');
    }

    if (!timeTableData) {
      return res.status(400).send('Invalid Time table id');
    }

    if (!timeTableData[day]) {
      return res.status(400).send('Invalid Day');
    }

    const activityId = nanoid();

    const endingActivityId = nanoid();

    timeTableData[day].push({
      activityTitle,
      activityDescription,
      startingTimeHour,
      startingTimeMinute,
      endingTimeHour,
      endingTimeMinute,
      activityId,
      endingActivityId,
    });

    if (timeTableData.active) {
      await manualAddSchedule(
        {
          activityTitle,
          activityDescription,
          startingTimeHour,
          startingTimeMinute,
          endingTimeHour,
          endingTimeMinute,
          activityId,
          endingActivityId,
        },
        timeTableId,
        day
      );

      const updatedActivities = timeTableData[day].filter(
        (value) => value.activityId !== activityId
      );

      updatedActivities.push({
        activityTitle,
        activityDescription,
        startingTimeHour,
        startingTimeMinute,
        endingTimeHour,
        endingTimeMinute,
        activityId,
        endingActivityId,
        scheduled: true,
      });
      timeTableData[day] = updatedActivities;
    }

    await timeTableData.save();

    return res.status(201).send('Added activity');
  } catch (err) {
    console.log(err);

    return res.status(400).send(err);
  }
};

const addActivitiesFromDay = async (req, res) => {
  const { emailId } = req.user;

  if (!emailId) {
    res.status(400).send('kucch to gadbad hai daya');
  }

  const { senderDay, receieverDay, timeTableId } = req.body;

  if (!senderDay || !receieverDay || !timeTableId) {
    return res.status(400).send('Fill all credentials');
  }

  try {
    const userData = await userModel.findOne({ emailId });

    if (!userData) {
      return res.status(400).send('How did u get our jwt token secret key');
    }

    const timeTableAvailable =
      userData.timeTables.filter((value) => value === timeTableId).length > 0;

    if (!timeTableAvailable) {
      return res.status(400).send('Invalid Timetable id');
    }

    const timeTableData = await timeTableModel.findOne({ timeTableId });

    if (!timeTableData) {
      return res.status(400).send('Invalid Timetable id');
    }

    if (
      timeTableData[senderDay] === null ||
      timeTableData[senderDay] === undefined
    ) {
      return res.status(400).send('Inavlid sender day');
    }

    if (
      timeTableData[receieverDay] === null ||
      timeTableData[receieverDay] === undefined
    ) {
      return res.status(400).send('Invalid receiver day');
    }

    console.log(timeTableData);

    console.log(timeTableData[receieverDay]);
    console.log(timeTableData[senderDay]);

    timeTableData[receieverDay] = timeTableData[senderDay];

    await timeTableData.save();
    return res.status(200).send('Copied from day');
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

const copySingleActivityFromDay = async (req, res) => {
  const { senderDay, receieverDay, timeTableId, activityId } = req.body;

  const { emailId } = req.user;

  if (!emailId) {
    return res.status(400).send('kucch to gadbad hai daya');
  }

  if (!senderDay || !receieverDay || !timeTableId || !activityId) {
    return res.status(400).send('Fill all credentials');
  }

  try {
    const userData = await userModel.findOne({ emailId });

    if (!userData) {
      return res.status(400).send(`You're missing`);
    }

    const timeTableExists =
      userData.timeTables.filter((value) => value === timeTableId).length > 0;

    if (!timeTableExists) {
      return res.status(400).send('Invalid Time Table Id');
    }

    const timeTableData = await timeTableModel.findOne({ timeTableId });

    if (!timeTableData) {
      return res.status(400).send('Invalid Time Table Id');
    }

    const activityExists =
      timeTableData[senderDay].filter(
        (value) => value.activityId === activityId
      ).length > 0;

    if (!activityExists) {
      return res.status(400).send('Invalid Activity Id');
    }

    const activityData = timeTableData[senderDay].filter(
      (value) => value.activityId === activityId
    )[0];

    timeTableData[receieverDay].push(activityData);

    await timeTableData.save();

    return res.status(200).send('Added Activity');
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

const copyActivitiesFromOtherTimeTable = async (req, res) => {
  const { senderDay, receieverDay, senderTimeTableId, receiverTimeTableId } =
    req.body;

  console.log(receiverTimeTableId);

  if (
    !senderDay ||
    !receieverDay ||
    !senderTimeTableId ||
    !receiverTimeTableId
  ) {
    return res.status(400).send('Fill all credentials');
  }

  const { emailId } = req.user;

  if (!emailId) {
    return res.status(400).send('Kucch to gadbad hai daya');
  }

  try {
    const userData = await userModel.findOne({ emailId });

    if (!userData) {
      return res.status(400).send(`You're missing bruh`);
    }

    const senderTimeTableExists =
      userData.timeTables.filter((value) => value === senderTimeTableId)
        .length > 0;

    if (!senderTimeTableExists) {
      return res.status(400).send('Invalid Sender Time table id');
    }

    const receiverTimeTableExists =
      userData.timeTables.filter((value) => value === receiverTimeTableId)
        .length > 0;

    if (!receiverTimeTableExists) {
      return res.status(400).send('Invalid receiver Time table id');
    }

    const senderTimeTableData = await timeTableModel.findOne({
      timeTableId: senderTimeTableId,
    });

    if (!senderTimeTableData) {
      return res.status(400).send('Invalid sender time table id');
    }

    const receiverTimeTableData = await timeTableModel.findOne({
      timeTableId: receiverTimeTableId,
    });

    if (!receiverTimeTableData) {
      return res.status(400).send('Invalid receiver time table id');
    }

    if (!senderTimeTableData[senderDay]) {
      return res.status(400).send('Invalid sender day');
    }

    if (!receiverTimeTableData[receieverDay]) {
      return res.status(400).send('Invalid receiver day');
    }

    console.log(senderTimeTableData);
    console.log(receiverTimeTableData);

    receiverTimeTableData[receieverDay] = senderTimeTableData[senderDay];

    await receiverTimeTableData.save();

    return res.status(200).send('Copied Activities');
  } catch (err) {
    console.log(err);
  }
};

export {
  addActivity,
  addActivitiesFromDay,
  copySingleActivityFromDay,
  copyActivitiesFromOtherTimeTable,
};
