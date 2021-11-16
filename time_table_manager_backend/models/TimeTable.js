import mongoose from 'mongoose';

const timeTableSchema = mongoose.Schema({
  timeTableId: { type: String, required: true },
  user: { type: String, required: true },
  monday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
  tuesday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
  wednesday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
  thursday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
  friday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
  saturday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
  sunday: [
    {
      startingTime: String,
      endingTime: String,
      activityTitle: String,
      activityDescription: String,
    },
  ],
});

const timeTableModel = mongoose.model('timeTables', timeTableSchema);

export default timeTableModel;
