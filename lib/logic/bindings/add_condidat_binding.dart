import 'package:get/get.dart';
import '../controllers/add_condidat_controller.dart';
import '../controllers/auth_controller.dart';

class AddCondidatBuinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCondidatController());
    Get.put(AuthController());
  }
}
