import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  AuthController authController = Get.find();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      if (authController.isAuth()) {
        Get.toNamed(AppRoutes.dashboard);
      } else {
        Get.toNamed(AppRoutes.login);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text(
            "SM-DEV",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
    ;
  }
}
