import userModel from '../models/User.js';
import timeTableModel from '../models/TimeTable.js';
import { nanoid } from 'nanoid';

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

    timeTableData[day].push({
      activityTitle,
      activityDescription,
      startingTimeHour,
      startingTimeMinute,
      endingTimeHour,
      endingTimeMinute,
      activityId: nanoid(),
    });

    await timeTableData.save();

    return res.status(201).send('Added activity');
  } catch (err) {
    console.log(err);

    return res.status(400).send(err);
  }
};

export { addActivity };
