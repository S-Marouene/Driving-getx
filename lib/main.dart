import 'package:driving_getx/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

//AppStore appStore = AppStore();
void main() {
  runApp(GetMaterialApp(
    /* theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.deepPurpleAccent)), */
    //title: "SM-DEV",
    initialRoute: AppRoutes.splash,
    getPages: AppRoutes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
