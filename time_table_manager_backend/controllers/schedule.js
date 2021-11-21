import schedule from 'node-schedule';
import timeTableModel from '../models/TimeTable.js';

function findValueByPrefix(object, prefix) {
  if (object[prefix]) {
    console.log('direct available');
    console.log(object[prefix][0]);
    return object[prefix][0];
  } else {
    for (var property in object) {
      if (
        object.hasOwnProperty(property) &&
        property.toString().startsWith(prefix)
      ) {
        return object[property];
      }
    }
  }
}

const addSchedule = async (updateDescription, timeTableId, socket) => {
  try {
    const timeTableData = await timeTableModel.findById(timeTableId);

    const activityData = updateDescription.updatedFields;

    if (!timeTableData) {
      console.log('time table is missing');
    }

    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    let dayNumber;
    let day;

    console.log(activityData);

    console.log(`activityId ${activityData.activityId}`);

    days.some((currentDay) => {
      console.log(currentDay);
      console.log(timeTableData[currentDay]);

      let inThisDay =
        timeTableData[currentDay].filter(
          (value) =>
            value.activityId ===
            findValueByPrefix(activityData, currentDay).activityId
        ).length > 0;

      console.log(`in this day: ${inThisDay}`);

      if (inThisDay) {
        dayNumber = days.indexOf(currentDay) + 1;
        day = currentDay;
        console.log(`dayNumber: ${dayNumber}, day: ${day}`);
        return true;
      }
    });

    const startingTimeString = `${
      findValueByPrefix(activityData, day).startingTimeMinute
    } ${
      findValueByPrefix(activityData, day).startingTimeHour
    } * * ${dayNumber}`;

    const endingTimeString = `${
      findValueByPrefix(activityData, day).endingTimeMinute
    } ${findValueByPrefix(activityData, day).endingTimeHour} * * ${dayNumber}`;

    schedule.scheduleJob(startingTimeString, function () {
      console.log(
        `time to start ${findValueByPrefix(activityData, day).activityTitle}`
      );
      socket.emit('start', {
        activity: findValueByPrefix(activityData, day).activityTitle,
      });
    });

    schedule.scheduleJob(endingTimeString, function () {
      console.log(
        `time to end ${findValueByPrefix(activityData, day).activityTitle}}`
      );
      socket.emit('end', {
        activity: findValueByPrefix(activityData, day).activityTitle,
      });
    });
  } catch (err) {
    console.log(err);
  }
};

export default addSchedule;
