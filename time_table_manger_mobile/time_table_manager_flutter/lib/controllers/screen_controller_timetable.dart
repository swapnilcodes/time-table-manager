import 'package:time_table_manager_flutter/components/home.dart';

class ScreenController {
  static bool timeTableOpen = false;
  static var currentTimeTable;

  static setCurrentTimeTable(timeTable) {
    currentTimeTable = timeTable;
  }

  static setTimeTableOpen(bool open) {
    timeTableOpen = open;
  }
}
