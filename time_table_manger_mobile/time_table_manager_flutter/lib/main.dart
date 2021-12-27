import 'package:flutter/material.dart';
import 'package:time_table_manager_flutter/components/activate_account.dart';
import 'package:time_table_manager_flutter/components/defined_err.dart';
import 'package:time_table_manager_flutter/components/err.dart';
import 'package:time_table_manager_flutter/components/home.dart';
import 'package:time_table_manager_flutter/components/login.dart';
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
          scaffoldBackgroundColor: Colors.black,
          fontFamily: GoogleFonts.raleway().fontFamily,
          primaryColor: Colors.black26,
          accentColor: Colors.white,
          hintColor: Colors.white),
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          Routes.intro_route: (ctx) => Intro(),
          Routes.no_login_home_route: (ctx) => NoLoginHome(),
          Routes.signup_route: (ctx) => Signup(),
          Routes.err_route: (ctx) => Err(),
          Routes.defined_err_route: (ctx) =>
              DefinedError(settings.arguments.toString()),
          Routes.account_activation_route: (ctx) =>
              ActivateAccount(settings.arguments),
          Routes.home_route: (ctx) => Home(settings.arguments),
          Routes.login_route: (ctx) => Login(),
        };
        WidgetBuilder? builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder!(ctx));
      },
    );
  }
}
