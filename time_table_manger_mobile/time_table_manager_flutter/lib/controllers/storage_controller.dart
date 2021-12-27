import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageController {
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<String?> getJWT() async {
    var JWTValue = await storage.read(key: 'jwt_token');

    return JWTValue.toString();
  }

  setJWT({jwt_token = String}) async {
    await storage.write(key: 'jwt_token', value: jwt_token);
    print('added jwt');
  }

  deleteJWT() async {
    await storage.delete(key: 'jwt_token');
    print('deleted jwt');
  }

  Future<bool> jwtExists() async {
    bool jwtExists = await storage.containsKey(key: 'jwt_token');
    return jwtExists;
  }
}
