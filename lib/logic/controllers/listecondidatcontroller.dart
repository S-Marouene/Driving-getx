import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/services/getCondidat_service.dart';
import 'package:get/get.dart';

class ListeCondidatController extends GetxController
    with StateMixin<List<Condidat>> {
  @override
  void onInit() {
    super.onInit();
    ServiceGetCondidats.getCondidats().then((value) {
      change(value, status: RxStatus.success());
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }
}
