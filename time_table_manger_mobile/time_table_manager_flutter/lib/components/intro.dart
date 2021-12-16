import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:time_table_manager_flutter/helpers/routes.dart';
import '../controllers/storage_controller.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  bool nullCheck(String? jwt) {
    print('jwt: $jwt');
    if (jwt != null) {
      if (!jwt.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  switchToNextScreen(BuildContext context) async {
    var storageController = StorageController();
    var jwtExists = await storageController.getJWT();
    print(jwtExists);
    if (nullCheck(jwtExists)) {
      print("jwt doesn't exist");
      await Future.delayed(Duration(seconds: 6));
      Navigator.pushNamed(context, Routes.no_login_home_route);
    } else {
      print("jwt exists");
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
