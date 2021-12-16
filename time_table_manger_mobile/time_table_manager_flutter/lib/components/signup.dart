import 'package:flutter/material.dart';
import '../helpers/routes.dart';
import '../controllers/auth.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool changeSignupButton = false;

  String name = '';
  String emailId = '';
  String password = '';

  String nameErrorText = '';
  String emailIdErrorText = '';
  String passwordErrorText = '';

  makeSignUpAnimation() async {
    setState(() {
      changeSignupButton = true;
    });

    await Future.delayed(Duration(milliseconds: 150));

    setState(() {
      changeSignupButton = false;
    });
    sendSignUpRequest();
  }

  sendSignUpRequest() {
    if (!name.isEmpty) {
      if (!emailId.isEmpty) {
        if (password.length >= 5) {
          setState(() {
            passwordErrorText = '';
            emailIdErrorText = '';
            nameErrorText = '';
          });
          var result = Auth.signUp(name, emailId, password);
          print(result.toString());
        } else {
          setState(() {
            passwordErrorText = 'Your password needs to be atleast 6 digits';
          });
        }
      } else {
        setState(() {
          emailIdErrorText = 'Your EmailId cannot be empty';
        });
      }
    } else {
      setState(() {
        nameErrorText = 'Your Name cannot be empty';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Your Name',
                        labelText: 'Name',
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
                        errorText: nameErrorText,
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      onChanged: (value) => {
                        setState(() {
                          name = value;
                        })
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Enter Your Emailid',
                          labelText: 'Emailid',
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          errorText: emailIdErrorText),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      onChanged: (value) => {
                        setState(() {
                          emailId = value;
                        })
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => {
                        setState(() {
                          password = value;
                        })
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter Your Password',
                          labelText: 'Password',
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          errorText: passwordErrorText),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Material(
                color: Color.fromRGBO(237, 47, 47, 0.8),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => makeSignUpAnimation(),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: !changeSignupButton ? 290 : 280,
                    height: !changeSignupButton ? 70 : 65,
                    alignment: Alignment.center,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
