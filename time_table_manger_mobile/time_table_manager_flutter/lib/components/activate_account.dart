import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:time_table_manager_flutter/controllers/storage_controller.dart';
import 'package:time_table_manager_flutter/helpers/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ActivateAccount extends StatefulWidget {
  final data;

  ActivateAccount(this.data);

  @override
  State<ActivateAccount> createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  // controls if loading is on
  bool loadingOn = false;

  String loadingMessage = '';

  //otp field controllers
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.red, width: 3),
      borderRadius: BorderRadius.circular(1.0),
    );
  }

  // button animation variable
  bool changeVerifyButton = false;

  var otp = '';

  // backend api url
  static final String apiUrl =
      'time-table-manager-backend.swapnilcodes.repl.co';

  // user email id
  var data;

  // button animation function
  makeButtonAnimation() async {
    setState(() {
      changeVerifyButton = true;
    });

    await Future.delayed(Duration(milliseconds: 150));

    activateAccountFunction();

    setState(() {
      changeVerifyButton = false;
    });
  }

  // activate Account function
  activateAccountFunction() async {
    if (!otp.isEmpty) {
      await http
          .post(
            Uri(
              scheme: 'https',
              host: apiUrl,
              path: '/activateAccount',
            ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(
              <String, String>{
                'emailId': widget.data['emailId'],
                'otp': otp,
              },
            ),
          )
          .then((response) async => {
                print(response.statusCode),
                if (response.statusCode == 200 || response.statusCode == 201)
                  {
                    setState(() {
                      loadingOn = true;
                      loadingMessage = 'Loging in...';
                    }),
                    await http
                        .post(
                      Uri(
                        host: apiUrl,
                        path: '/login',
                        scheme: 'https',
                      ),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: json.encode(<String, String>{
                        'emailId': widget.data['emailId'],
                        'password': widget.data['password']
                      }),
                    )
                        .then((value) async {
                      var userData = json.decode(value.body)['data'];
                      await StorageController()
                          .setJWT(jwt_token: userData['accessToken']);
                      Navigator.of(context)
                          .pushNamed(Routes.home_route, arguments: userData);
                      print('userData $userData');
                    }).catchError((value) => print(value))
                  }
                else if (response.statusCode == 400)
                  {
                    print(response.body),
                    Navigator.of(context).pushNamed(Routes.defined_err_route,
                        arguments: 'Invalid OTP!')
                  }
                else if (response.statusCode == 500)
                  {
                    print(response.body),
                    Navigator.of(context).pushNamed(Routes.err_route)
                  }
              })
          .catchError((err) => {print(err.toString())});
    } else {
      Navigator.pushNamed(context, Routes.defined_err_route,
          arguments: 'Otp Cannot be empty');
    }
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    data = widget.data;

    print(data);

    var emailId = data['emailId'];

    print('emailId $emailId');

    double height = MediaQuery.of(context).size.height;

    if (!loadingOn) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Text(
                    'An OTP has been sent to Your Email id',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, color: Colors.white),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Note that it is valid for only 15 minutes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, color: Colors.white),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19.0),
                    child: PinPut(
                      eachFieldWidth: 50,
                      eachFieldHeight: 50,
                      fieldsCount: 6,
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration,
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration,
                      textStyle: TextStyle(color: Colors.white, fontSize: 23),
                      onChanged: (value) => {
                        setState(() {
                          otp = value;
                        })
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Material(
                    color: Color.fromRGBO(237, 47, 47, 0.8),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => makeButtonAnimation(),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        width: !changeVerifyButton ? 290 : 280,
                        height: !changeVerifyButton ? 70 : 65,
                        alignment: Alignment.center,
                        child: Text(
                          'Verify',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      data = widget.data;

      return (Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitThreeBounce(
              color: Colors.white,
              size: 70,
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              loadingMessage,
              style: TextStyle(color: Colors.white, fontSize: 27),
            )
          ],
        ),
      ));
    }
  }
}
