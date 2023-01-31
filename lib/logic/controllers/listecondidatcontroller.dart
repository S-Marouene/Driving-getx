import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/services/getCondidat_service.dart';
import 'package:get/get.dart';

class ListeCondidatController extends GetxController
    with StateMixin<List<Condidat>> {
  Rx<List<Condidat>> listeAll = Rx<List<Condidat>>([]);

  @override
  void onInit() {
    super.onInit();
    ServiceGetCondidats.getCondidats().then((data) {
      change(data, status: RxStatus.success());
      listeAll.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
  }

  @override
  void onClose() {}
}
