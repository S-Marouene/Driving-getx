import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';

class AuthController extends GetxController {
  var storage = const FlutterSecureStorage();

  var token = '';
  var user = ''.obs;

  late TextEditingController emailController, passwordController;

  @override
  void onInit() {
    authdata();
    super.onInit();
  }

  authdata() async {
    token = (await storage.read(key: 'token'))!;
  }

  gtuserInfo() async {
    user.value = (await storage.read(key: 'user'))!;
    if (kDebugMode) {
      print(user.value);
    }
  }

  bool isAuth() {
    return token.isNotEmpty;
  }

  doLogout() async {
    await storage.deleteAll();
    Get.toNamed(AppRoutes.login);
  }
}
