// ignore_for_file: depend_on_referenced_packages

import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({
    Key? key,
  }) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  AuthController authController = Get.find();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (authController.isAuth()) {
        Get.offNamed(AppRoutes.dashboard);

        //Get.toNamed(AppRoutes.dashboard);
      } else {
        Get.offNamed(AppRoutes.login);
        //Get.toNamed(AppRoutes.login);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF076ACF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset('images/app/sdlogo.png', height: 105),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: Text("SM-DEV",
                  style: secondaryTextStyle(size: 25, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
