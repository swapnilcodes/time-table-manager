import mongoose from 'mongoose';

const timeTableSchema = mongoose.Schema({
  timeTableId: { type: String, required: true },
  user: { type: String, required: true },
  title: {type: String, required: true},
  monday: [
    {
      startingTimeHour: String,
      endingTimeHour: String,
      startingTimeMinute: String,
      endingTimeMinute: String,
      activityTitle: String,
      activityDescription: String,
      activityId: String,
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
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
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
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
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
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
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
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
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
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
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
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
      scheduled: { type: Boolean, default: false },
      endingActivityId: String,
    },
  ],
  active: { type: Boolean, default: false },
});

const timeTableModel = mongoose.model('timeTables', timeTableSchema);

export default timeTableModel;
