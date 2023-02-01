import 'package:driving_getx/logic/controllers/condidatcontroller.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class CondidatsBuinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CondidatController());
    Get.put(AuthController());
  }
}
