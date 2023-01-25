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

  Future authdata() async {
    token = (await storage.read(key: 'token'))!;
    return token;
  }

  bool isAuth() {
    return token.isNotEmpty;
  }

  doLogout() async {
    await storage.deleteAll();
    Get.toNamed(AppRoutes.login);
  }
}
