import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_table_manager_flutter/helpers/routes.dart';

class NoLoginHome extends StatefulWidget {
  const NoLoginHome({Key? key}) : super(key: key);

  @override
  State<NoLoginHome> createState() => _NoLoginHomeState();
}

class _NoLoginHomeState extends State<NoLoginHome> {
  bool changeSignUpButton = false;
  bool changeLoginButton = false;

  makeSignUpAnimation() async {
    setState(() {
      changeSignUpButton = true;
    });

    await Future.delayed(Duration(milliseconds: 150));

    setState(() {
      changeSignUpButton = false;
    });
    await Future.delayed(Duration(milliseconds: 150));

    Navigator.pushNamed(context, Routes.signup_route);
  }

  makeLoginAnimation() async {
    setState(() {
      changeLoginButton = true;
    });

    await Future.delayed(Duration(milliseconds: 150));

    setState(() {
      changeLoginButton = false;
    });

    await Future.delayed(Duration(milliseconds: 150));

    Navigator.pushNamed(context, Routes.login_route);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 140,
              ),
              Center(
                child: Text(
                  'Time Table Manager',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: GoogleFonts.raleway().fontFamily),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Material(
                color: Color.fromRGBO(237, 47, 47, 0.8),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => makeSignUpAnimation(),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: !changeSignUpButton ? 290 : 280,
                    height: !changeSignUpButton ? 70 : 65,
                    alignment: Alignment.center,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Material(
                color: Color.fromRGBO(237, 47, 47, 0.8),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => makeLoginAnimation(),
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: !changeLoginButton ? 290 : 250,
                    height: !changeLoginButton ? 70 : 55,
                    alignment: Alignment.center,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
