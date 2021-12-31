import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:time_table_manager_flutter/components/intro.dart';
import 'package:time_table_manager_flutter/controllers/screen_controller_timetable.dart';
import 'package:time_table_manager_flutter/helpers/routes.dart';
import 'home.dart';

class HomeChild extends StatefulWidget {
  var userData;

  static final String apiUrl =
      'time-table-manager-backend.swapnilcodes.repl.co';

  final setTimeTableOpen;

  HomeChild(this.userData, this.setTimeTableOpen);

  @override
  State<HomeChild> createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  var timeTables = [];
  var first = false;
  var reloadWidget = false;
  bool timeTableLoading = true;

  bool activeLoading = false;
  String activeLoadingTimeTableId = '';
  bool deleteLoading = false;

  getTimeTables() async {
    setState(() {
      timeTableLoading = true;
    });
    await http.get(
      Uri(
        scheme: 'http',
        host: HomeChild.apiUrl,
        path: '/getMyTimeTables',
      ),
      headers: <String, String>{
        'authToken': widget.userData['accessToken'],
      },
    ).then(
      (response) {
        if (response.statusCode == 200) {
          print(response.body);
          if (response.body.toString().toLowerCase() !=
              "you haven't created any timetables yet...") {
            setState(() {
              timeTableLoading = false;
              timeTables = json.decode(response.body.toString());
            });
          } else {
            setState(() {
              timeTableLoading = false;

              timeTables = [];
            });
          }
        } else {
          Navigator.pushNamed(context, Routes.err_route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!first) {
      getTimeTables();
      setState(() {
        first = true;
      });
    }
    print('timeTableLoading $timeTableLoading');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 0, 0),
          child: Text(
            'Welcome ${widget.userData['name']}',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        SizedBox(
          height: 70,
        ),
        timeTables.isNotEmpty && !timeTableLoading
            ? Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: timeTables.length,
                      // shrinkWrap: true,
                      itemExtent: 120,
                      itemBuilder: (context, index) {
                        final timeTable = timeTables[index];

                        var activeOn = timeTable['active'];

                        return Padding(
                          key: Key(
                            timeTable['timeTableId'],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: () async {
                              await Future.delayed(Duration(milliseconds: 400));
                              widget.setTimeTableOpen(true, timeTable);
                            },
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.67),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                        ),
                                        child: Text(
                                          timeTable['title'].toUpperCase(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                        ),
                                        child: Text(
                                          timeTable['active']
                                              ? 'Active'
                                              : 'Not Active',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: timeTable['active']
                                                ? Colors.green
                                                : Colors.red,
                                            fontFamily: GoogleFonts.raleway()
                                                .fontFamily,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () => showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Are You Sure To Delete This Time table?',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Color.fromRGBO(0, 0, 0, 0.9),
                                              actions: [
                                                !deleteLoading
                                                    ? TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);

                                                          setState(() {
                                                            timeTableLoading =
                                                                true;
                                                          });

                                                          http.delete(
                                                            Uri(
                                                              host: HomeChild
                                                                  .apiUrl,
                                                              scheme: 'https',
                                                              path:
                                                                  '/deleteTimeTable',
                                                              query:
                                                                  'timeTableId=${timeTable['timeTableId']}',
                                                            ),
                                                            headers: <String,
                                                                String>{
                                                              'authToken': widget
                                                                      .userData[
                                                                  'accessToken']
                                                            },
                                                          ).then(
                                                              (response) async {
                                                            print(
                                                                response.body);
                                                            print(response
                                                                .statusCode);

                                                            await http.get(
                                                              Uri(
                                                                host: HomeChild
                                                                    .apiUrl,
                                                                scheme: 'https',
                                                                path:
                                                                    '/getMyTimeTables',
                                                              ),
                                                              headers: <String,
                                                                  String>{
                                                                'authToken': widget
                                                                        .userData[
                                                                    'accessToken']
                                                              },
                                                            ).then((response) {
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                if (response
                                                                        .body
                                                                        .toString()
                                                                        .toLowerCase() !=
                                                                    "you haven't created any time tables yet") {
                                                                  setState(() {
                                                                    timeTableLoading =
                                                                        false;
                                                                    timeTables =
                                                                        json.decode(response
                                                                            .body
                                                                            .toString());
                                                                    deleteLoading =
                                                                        false;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    timeTableLoading =
                                                                        false;
                                                                    timeTables =
                                                                        [];
                                                                    deleteLoading =
                                                                        false;
                                                                  });
                                                                }
                                                              } else {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    Routes
                                                                        .err_route);
                                                              }
                                                            }).catchError(
                                                                (err) {
                                                              print(err);
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          }).catchError((err) {
                                                            print(err);
                                                          });
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ),
                                                      )
                                                    : SpinKitDoubleBounce(
                                                        color: Colors.white,
                                                      ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color: Colors.greenAccent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        icon: Icon(
                                          CupertinoIcons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      !activeLoading ||
                                              activeLoadingTimeTableId !=
                                                  timeTable['timeTableId']
                                          ? Switch(
                                              activeTrackColor: Colors.green,
                                              inactiveTrackColor: Colors.red,
                                              value: timeTable['active'],
                                              onChanged: (value) async {
                                                setState(() {
                                                  activeLoadingTimeTableId =
                                                      timeTable['timeTableId'];
                                                  activeLoading = true;

                                                  timeTables = timeTables;
                                                });
                                                if (value) {
                                                  await http
                                                      .put(
                                                    Uri(
                                                      host: HomeChild.apiUrl,
                                                      path:
                                                          '/activateTimeTable',
                                                      scheme: 'https',
                                                    ),
                                                    headers: <String, String>{
                                                      'authToken':
                                                          widget.userData[
                                                              'accessToken'],
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: json.encode(
                                                      <String, String>{
                                                        'timeTableId':
                                                            timeTable[
                                                                'timeTableId'],
                                                      },
                                                    ),
                                                  )
                                                      .then(
                                                    (response) async {
                                                      if (response.statusCode ==
                                                              200 ||
                                                          response.statusCode ==
                                                              201) {
                                                        await http.get(
                                                            Uri(
                                                              host: HomeChild
                                                                  .apiUrl,
                                                              path:
                                                                  '/getMyTimeTables',
                                                              scheme: 'https',
                                                            ),
                                                            headers: <String,
                                                                String>{
                                                              'authToken': widget
                                                                      .userData[
                                                                  'accessToken'],
                                                            }).then((response) {
                                                          if (response.statusCode ==
                                                                  200 ||
                                                              response.statusCode ==
                                                                  201) {
                                                            if (response.body
                                                                    .toString()
                                                                    .toLowerCase() !=
                                                                "you haven't created any timetables yet...") {
                                                              setState(() {
                                                                timeTableLoading =
                                                                    false;
                                                                activeLoading =
                                                                    false;
                                                                activeLoadingTimeTableId =
                                                                    '';
                                                                timeTables = json
                                                                    .decode(response
                                                                        .body
                                                                        .toString());
                                                              });
                                                            } else {
                                                              setState(() {
                                                                timeTableLoading =
                                                                    false;
                                                                activeLoading =
                                                                    false;
                                                                activeLoadingTimeTableId =
                                                                    '';
                                                                timeTables = [];
                                                              });
                                                            }
                                                          }
                                                        }).catchError((err) {
                                                          print(err);
                                                        });
                                                      } else if (response
                                                              .statusCode ==
                                                          400) {
                                                        setState(() {
                                                          activeLoading = false;
                                                          activeLoadingTimeTableId =
                                                              '';
                                                        });
                                                        Navigator.pushNamed(
                                                          context,
                                                          Routes
                                                              .defined_err_route,
                                                          arguments: response
                                                              .body
                                                              .toString(),
                                                        );
                                                      } else {
                                                        setState(() {
                                                          activeLoading = false;
                                                          activeLoadingTimeTableId =
                                                              '';
                                                        });
                                                        Navigator.pushNamed(
                                                            context,
                                                            Routes.err_route);
                                                      }
                                                    },
                                                  ).catchError((err) {
                                                    print(err);
                                                  });
                                                } else {
                                                  await http.delete(
                                                    Uri(
                                                        host: HomeChild.apiUrl,
                                                        path:
                                                            '/deactivateTimeTable',
                                                        scheme: 'https',
                                                        query:
                                                            'timeTableId=${timeTable['timeTableId']}'),
                                                    headers: <String, String>{
                                                      'authToken':
                                                          widget.userData[
                                                              'accessToken'],
                                                    },
                                                  ).then((response) async {
                                                    if (response.statusCode ==
                                                            200 ||
                                                        response.statusCode ==
                                                            201) {
                                                      await http.get(
                                                        Uri(
                                                          host:
                                                              HomeChild.apiUrl,
                                                          path:
                                                              '/getMyTimeTables',
                                                          scheme: 'https',
                                                        ),
                                                        headers: <String,
                                                            String>{
                                                          'authToken': widget
                                                                  .userData[
                                                              'accessToken'],
                                                        },
                                                      ).then((response) {
                                                        if (response.statusCode ==
                                                                200 ||
                                                            response.statusCode ==
                                                                201) {
                                                          if (response.body
                                                                  .toString()
                                                                  .toLowerCase() !=
                                                              "you haven't created any timetables yet...") {
                                                            setState(() {
                                                              activeLoading =
                                                                  false;
                                                              timeTables = json
                                                                  .decode(response
                                                                      .body
                                                                      .toString());
                                                            });
                                                          } else {
                                                            setState(() {
                                                              activeLoading =
                                                                  false;
                                                              timeTables = [];
                                                            });
                                                          }
                                                        }
                                                      }).catchError((err) {
                                                        print(err);
                                                      });
                                                    } else {
                                                      print(response.body
                                                          .toString());
                                                      Navigator.pushNamed(
                                                          context,
                                                          Routes.err_route);
                                                    }
                                                  }).catchError((err) {
                                                    print(err);
                                                  });
                                                }
                                              },
                                            )
                                          : SpinKitDoubleBounce(
                                              color: Colors.white,
                                            )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Center(
                    child: timeTableLoading
                        ? SpinKitWave(
                            color: Colors.white,
                          )
                        : Text(
                            'You havent created a time table yet.',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontSize: 25,
                            ),
                          ),
                  ),
                ],
              ),
      ],
    );
  }

  setDeleteLoading(setState) {
    setState(() {
      deleteLoading = true;
    });
  }

  resetDeleteLoading(setState) {
    setState(() {
      deleteLoading = false;
    });
  }
}
