import 'package:driving_getx/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(GetMaterialApp(
    title: "SM-DEV",
    initialRoute: AppRoutes.splash,
    getPages: AppRoutes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
