import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_table_manager_flutter/controllers/storage_controller.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userData;
  var jwt;
  static final String apiUrl = '10.0.2.2';

  loadJWT() async {
    jwt = await StorageController().getJWT();

    setState(() {});
  }

  loadData() async {
    if (jwt != null) {
      await http
          .get(Uri(host: apiUrl, scheme: 'http', port: 5000, path: '/getMyInfo'),
              headers: <String, String>{
            'authToken': jwt
          }).then((value) => {
                setState(() {
                  userData = json.decode(value.body.toString());
                })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadJWT();
    loadData();
    if (userData != null) {
      print(userData['name']);
    } else {
      print('userdata is null');
    }
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Welcome ${userData != null ? userData['name'] : 'Welcome'}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
