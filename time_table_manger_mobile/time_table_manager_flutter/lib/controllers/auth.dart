import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth {
  static final String apiUrl = '10.0.2.2';

  static signUp(String name, String emailId, String password) async {
    var data = {'name': name, 'emailId': emailId, 'password': password};

    await http
        .post(Uri(host: apiUrl, path: '/signup', port: 5000, scheme: 'http'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(<String, String>{
              'name': name,
              'emailId': emailId,
              'password': password
            }))
        .then((response) {
      print(response.body);
      return response.body;
    }).catchError((error) {
      print(error.toString());
      return error.toString();
    });
    print('hey bruh where u get that from');
    return 'hey bruh';
  }
}
