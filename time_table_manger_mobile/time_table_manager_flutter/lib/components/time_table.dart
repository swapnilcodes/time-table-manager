import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeTable extends StatefulWidget {
  final timeTable;
  final setTimeTableOpen;

  TimeTable(this.timeTable, this.setTimeTableOpen);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(),
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 14,
                ),
                IconButton(
                  onPressed: () async {
                    await Future.delayed(
                      Duration(
                        milliseconds: 300,
                      ),
                    );
                    widget.setTimeTableOpen(false, widget.timeTable);
                  },
                  icon: Icon(CupertinoIcons.back),
                  color: Colors.white,
                ),
                SizedBox(
                  width: 22,
                ),
                Text(
                  '${widget.timeTable['title'].toUpperCase()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () => print('hoi hoi'),
                    child: Container(
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.64),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'MONDAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  widget.timeTable['monday'].length > 0
                                      ? '${widget.timeTable['monday'].length} Activities'
                                      : 'Empty',
                                  style: TextStyle(
                                    color: widget.timeTable['monday'].length > 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                            child: TextButton(
                              onPressed: () => print('tap'),
                              child: Text(
                                'Open',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => print('hoi hoi'),
                    child: Container(
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.64),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'TUESDAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  widget.timeTable['tuesday'].length > 0
                                      ? '${widget.timeTable['tuesday'].length} Activities'
                                      : 'Empty',
                                  style: TextStyle(
                                    color:
                                        widget.timeTable['tuesday'].length > 0
                                            ? Colors.green
                                            : Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                            child: TextButton(
                              onPressed: () => print('tap'),
                              child: Text(
                                'Open',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => print('hoi hoi'),
                    child: Container(
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.64),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'WEDNESDAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  widget.timeTable['wednesday'].length > 0
                                      ? '${widget.timeTable['wednesday'].length} Activities'
                                      : 'Empty',
                                  style: TextStyle(
                                    color:
                                        widget.timeTable['wednesday'].length > 0
                                            ? Colors.green
                                            : Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                            child: TextButton(
                              onPressed: () => print('tap'),
                              child: Text(
                                'Open',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => print('hoi hoi'),
                    child: Container(
                      width: 350,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.64),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  'THURSDAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: Text(
                                  widget.timeTable['thursday'].length > 0
                                      ? '${widget.timeTable['thursday'].length} Activities'
                                      : 'Empty',
                                  style: TextStyle(
                                    color:
                                        widget.timeTable['thursday'].length > 0
                                            ? Colors.green
                                            : Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                            child: TextButton(
                              onPressed: () => print('tap'),
                              child: Text(
                                'Open',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
