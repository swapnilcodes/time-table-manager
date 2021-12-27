import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:time_table_manager_flutter/controllers/storage_controller.dart';
import 'package:time_table_manager_flutter/helpers/routes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String emailIdErr = '';
  String passwordErr = '';
  String emailId = '';
  String password = '';
  bool changeLoginButton = false;

  static final String apiUrl =
      'time-table-manager-backend.swapnilcodes.repl.co';

  makeLoginAnimation() async {
    setState(() {
      changeLoginButton = true;
    });

    await Future.delayed(Duration(milliseconds: 150));
    loginRequest();

    setState(() {
      changeLoginButton = false;
    });
  }

  loginRequest() async {
    if (emailId.isNotEmpty) {
      if (password.isNotEmpty) {
        await http
            .post(Uri(scheme: 'https', host: apiUrl, path: '/login'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(<String, String>{
                  'emailId': emailId,
                  'password': password,
                }))
            .then((response) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var userData = json.decode(response.body.toString())['data'];

            StorageController().setJWT(jwt_token: userData['accessToken']);
            Navigator.pushNamed(context, Routes.home_route,
                arguments: userData);
          } else if (response.statusCode == 400) {
            Navigator.pushNamed(context, Routes.defined_err_route,
                arguments: response.body.toString());
          } else if (response.statusCode == 500) {
            Navigator.pushNamed(context, Routes.err_route);
          }
        }).catchError((err) {
          Navigator.pushNamed(context, Routes.err_route);
          throw err;
        });
      } else {
        setState(() {
          passwordErr = 'Password Cannot be empty';
        });
      }
    } else {
      setState(() {
        emailIdErr = 'EmailId cannot be empty';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
              ),
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 90,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Your EmailId',
                        labelText: 'EmailId',
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        errorText: emailIdErr,
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      onChanged: (value) => {
                        setState(() {
                          emailId = value;
                        })
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        labelText: 'Password',
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        errorText: passwordErr,
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      onChanged: (value) => {
                        setState(() {
                          password = value;
                        })
                      },
                    ),
                  ],
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
                    duration: Duration(milliseconds: 150),
                    width: !changeLoginButton ? 290 : 280,
                    height: !changeLoginButton ? 70 : 65,
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
