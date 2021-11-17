import mongoose from 'mongoose';

const timeTableSchema = mongoose.Schema({
  timeTableId: { type: String, required: true },
  user: { type: String, required: true },
  monday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
  tuesday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
  wednesday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
  thursday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
  friday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
  saturday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
  sunday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
    },
  ],
});

const timeTableModel = mongoose.model('timeTables', timeTableSchema);

export default timeTableModel;
