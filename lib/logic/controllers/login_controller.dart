import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../database/services/auth_service.dart';
import '../../routes/routes.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  late TextEditingController emailController, passwordController;

  final loginformKey = GlobalKey<FormState>();
  String email = '', password = '';

  final storage = const FlutterSecureStorage();

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  doLogin() async {
    bool isValidate = loginformKey.currentState!.validate();

    if (isValidate) {
      isLoading(true);
      try {
        var data = await AuthService.login(
            email: emailController.text, password: passwordController.text);
        if (data != null) {
          print(data);
          await storage.write(key: 'token', value: data);
          loginformKey.currentState!.save();
          Get.toNamed(AppRoutes.dashboard);
        } else {
          Get.snackbar("login", "problem");
        }
      } finally {
        isLoading(false);
      }
    }
  }
}
