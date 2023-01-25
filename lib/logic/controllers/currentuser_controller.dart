import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../database/models/user.dart';

class CurrentUserController extends GetxController {
  var storage = const FlutterSecureStorage();
  final Rx<User> _currentuser = User().obs;
  User get user => _currentuser.value;

  gtuserInfo() async {
    User? getfromlocal = User.deserialize((await storage.read(key: 'user'))!);
    _currentuser.value = getfromlocal;
  }

  getToken() async {
    String token = (await storage.read(key: 'token'))!;
    return token;
  }
}
