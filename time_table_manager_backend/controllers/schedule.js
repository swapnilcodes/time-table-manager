import schedule from 'node-schedule';
import timeTableModel from '../models/TimeTable.js';

const addSchedule = async (updateDescription, timeTableId) => {
  try {
    const activity = updateDescription.updatedFields;

    const timeTableData = await timeTableModel.findById(timeTableId);

    console.log(timeTableData);

    let dayNumber;

    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    days.forEach((currentDay) => {
      const inThisDay =
        timeTableData[currentDay].filter(
          (value) => value.activityId === activity.activityId
        ).length > 0;

      if (inThisDay) {
        dayNumber = days.indexOf(currentDay) + 1;
      }
    });

    const startingTimeString = `${activity.startingTimeMinute}${activity.startingTimeHour}**${dayNumber}`;

    const endingTimeString = `${activity.endingTimeMinute}${activity.endingTimeHour}**${dayNumber}`;

    schedule.scheduleJob(startingTimeString, function () {
      console.log(`Time for ${activity.activityTitle}`);
    });

    schedule.scheduleJob(endingTimeString, function () {
      console.log(`${activity.activityTitle} should be done`);
    });
  } catch (err) {
    console.log(err);
  }
};

export default addSchedule;
