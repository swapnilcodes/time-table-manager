import 'package:flutter/material.dart';
import 'package:time_table_manager_flutter/components/signup.dart';
import 'components/intro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helpers/routes.dart';
import 'components/no_login_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[900],
          fontFamily: GoogleFonts.raleway().fontFamily,
          primaryColor: Colors.black26,
          accentColor: Colors.white,
          hintColor: Colors.white),
      routes: {
        Routes.intro_route: (context) => Intro(),
        Routes.no_login_home_route: (context) => NoLoginHome(),
        Routes.signup_route: (context) => Signup()
      },
    );
  }
}
