import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:time_table_manager_flutter/helpers/routes.dart';
import '../controllers/storage_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  static final String apiUrl =
      'time-table-manager-backend.swapnilcodes.repl.co';

  switchToNextScreen(BuildContext context) async {
    try {
      var storageController = StorageController();
      bool jwtExists = await storageController.jwtExists();
      print('jwt exists: $jwtExists');
      await Future.delayed(Duration(seconds: 6));
      if (!jwtExists) {
        print("jwt doesn't exist");
        Navigator.pushNamed(context, Routes.no_login_home_route);
      } else {
        var jwt = await storageController.getJWT();

        await http.get(
          Uri(
            scheme: 'https',
            host: apiUrl,
            path: '/getMyInfo',
          ),
          headers: <String, String>{
            'authToken': jwt.toString(),
          },
        ).then((userData) => {
              Navigator.pushNamed(context, Routes.home_route,
                  arguments: json.decode(userData.body.toString()))
            });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var modalRoute = ModalRoute.of(context);

    if (modalRoute != null) {
      print('TestWidget: ${modalRoute.isCurrent}');

      if (modalRoute.isCurrent) {
        switchToNextScreen(context);
      }
    } else {
      print('model route null');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 170,
            ),
            Center(
              child: Container(
                child: Image.asset(
                  'assets/images/intro_icon.png',
                  fit: BoxFit.cover,
                  width: 270,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Center(
              child: Text(
                "Time Table Manager",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: SpinKitPouringHourGlassRefined(
                color: Colors.white,
                duration: Duration(seconds: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
