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

let socket;

const setSocket = async (socketInstance) => {
  socket = socketInstance;
};

const manualAddSchedule = async (activityData, timeTableId, day) => {
  try {
    const timeTableData = await timeTableModel.findOne({ timeTableId });

    if (!timeTableData) {
      console.log('time table is missing');
    }

    if (activityData.scheduled) {
      return { err: 'activity already scheduled' };
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

    const dayNumber = days.indexOf(day) + 1;

    const startingTimeString = `${activityData.startingTimeMinute} ${activityData.startingTimeHour} * * ${dayNumber}`;

    const endingTimeString = `${activityData.endingTimeMinute} ${activityData.endingTimeHour} * * ${dayNumber}`;

    if (activityData.scheduled === true) {
      return { err: 'Activity Already Registered' };
    }

    console.log(activityData);

    schedule.scheduleJob(activityData.activityId, startingTimeString, () => {
      console.log(`time to start ${activityData.activityTitle}`);
      if (socket) {
        socket.emit('start', {
          activity: activityData.activityTitle,
          user: timeTableData.user,
        });
      }
    });

    schedule.scheduleJob(
      activityData.endingActivityId,
      endingTimeString,
      () => {
        console.log(`time to end ${activityData.activityTitle}`);
        if (socket) {
          socket.emit('end', {
            activity: activityData.activityTitle,
            user: timeTableData.user,
          });
        }
      }
    );

    console.log(`activityId ${activityData.activityId}`);
  } catch (err) {
    console.log(err);
  }
};

const removeSchedule = async (activityData, timeTableId, day) => {
  try {
    if (!activityData.scheduled) {
      return { err: 'pehle schedule to karo aana' };
    }

    const timeTableData = await timeTableModel.findOne({ timeTableId });

    if (!timeTableData) {
      return { err: 'Invalid time table id' };
    }

    const activityExists =
      timeTableModel.day.filter(
        (value) => value.activityId === activityData.activityId
      ).length > 0;

    if (!activityExists) {
      return { err: 'activity does not exist' };
    }

    const startingJob = schedule.scheduledJobs[activityData.activityId];

    startingJob.cancel();

    const endingJob = schedule.scheduledJobs[activityData.endingActivityId];

    endingJob.cancel();

    console.log('removed job');

    return { message: 'removed job' };
  } catch (err) {
    console.log(err);

    return { err };
  }
};

export { manualAddSchedule, setSocket, removeSchedule };
