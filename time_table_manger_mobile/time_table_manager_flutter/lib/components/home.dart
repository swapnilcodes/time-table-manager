import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_table_manager_flutter/components/home_child.dart';
import 'package:time_table_manager_flutter/components/new.dart';
import 'package:time_table_manager_flutter/components/profile.dart';
import 'package:time_table_manager_flutter/controllers/storage_controller.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final data;

  Home(this.data);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final String apiUrl =
      'time-table-manager-backend.swapnilcodes.repl.co';

  int currentIndex = 0;

  void indexChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getCurrentPage(Map userData) {
    if (currentIndex == 0) {
      return HomeChild(userData);
    } else if (currentIndex == 1) {
      return Profile();
    } else {
      return New(userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    Map userData = widget.data;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;

    var homeBackground = Color.fromRGBO(0, 0, 0, 0);

    print(userData);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
                opacity: 30,
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.2),
                  BlendMode.difference,
                ),
              ),
            ),
            child: getCurrentPage(userData),
          ),
        ),
        bottomNavigationBar: Container(
          height: 95,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1,
                color: Colors.white,
              ),
            ),
          ),
          child: BottomNavigationBar(
            selectedFontSize: 20,
            unselectedFontSize: 20,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.1),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                  color: currentIndex == 0
                      ? Colors.white
                      : Color.fromRGBO(255, 255, 255, 0.6),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.profile_circled,
                  color: currentIndex == 1
                      ? Colors.white
                      : Color.fromRGBO(255, 255, 255, 0.6),
                ),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.add,
                  color: currentIndex == 2
                      ? Colors.white
                      : Color.fromRGBO(255, 255, 255, 0.6),
                ),
                label: 'New',
              )
            ],
            currentIndex: currentIndex,
            unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.6),
            selectedItemColor: Colors.white,
            onTap: (index) => indexChange(index),
          ),
        ),
      ),
    );
  }
}
