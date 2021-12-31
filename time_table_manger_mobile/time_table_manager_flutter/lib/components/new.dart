import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:time_table_manager_flutter/helpers/routes.dart';

class New extends StatefulWidget {
  var userData;

  New(this.userData);

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  bool changeCreateButton = false;

  var titleError = '';

  var title = '';
  static final String apiUrl =
      'time-table-manager-backend.swapnilcodes.repl.co';

  makeCreateAnimation() async {
    setState(() {
      changeCreateButton = true;
    });

    await Future.delayed(Duration(milliseconds: 150));
    createTimeTable();
    setState(() {
      changeCreateButton = false;
    });
  }

  createTimeTable() {
    if (title.isNotEmpty) {
      if (title.length <= 20) {
        http
            .post(
          Uri(
            scheme: 'https',
            host: apiUrl,
            path: '/createTimeTable',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authToken': widget.userData['accessToken'],
          },
          body: json.encode(
            <String, String>{
              'title': title,
            },
          ),
        )
            .then((response) {
          if (response.statusCode == 201 || response.statusCode == 200) {
            setState(() {
              title = '';
            });
            showModalBottomSheet<void>(
              backgroundColor: Colors.black,
              // context and builder are
              // required properties in this widget
              context: context,
              builder: (BuildContext context) {
                // we set up a container inside which
                // we create center column and display text
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Created Time Table',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (response.statusCode == 400) {
            Navigator.of(context).pushNamed(
              Routes.defined_err_route,
              arguments: response.body.toString(),
            );
          } else if (response.statusCode == 500) {
            Navigator.of(context).pushNamed(Routes.err_route);
          }
        });
      } else {
        setState(() {
          titleError = 'Title can be maximum 9 characters';
        });
      }
    } else {
      setState(() {
        titleError = 'Title Cannot be empty';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 110,
        ),
        Text(
          'Create New Time Table',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter The Title',
              labelText: 'Title',
              fillColor: Colors.white,
              focusColor: Colors.white,
              hoverColor: Colors.white,
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              errorText: titleError,
              errorStyle: TextStyle(fontSize: 17),
            ),
            style: TextStyle(color: Colors.white, fontSize: 20),
            onChanged: (value) => {
              setState(() {
                title = value;
              })
            },
          ),
        ),
        SizedBox(
          height: 45,
        ),
        Material(
          color: Color.fromRGBO(237, 47, 47, 0.8),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () => makeCreateAnimation(),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: !changeCreateButton ? 290 : 280,
              height: !changeCreateButton ? 70 : 65,
              alignment: Alignment.center,
              child: Text(
                'Create',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
