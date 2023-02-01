import 'package:driving_getx/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/services.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  runApp(GetMaterialApp(
    initialRoute: AppRoutes.splash,
    getPages: AppRoutes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
