import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';

class LoginBuinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.put(AuthController());
  }
}
