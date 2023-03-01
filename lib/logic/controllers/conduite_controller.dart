import 'package:driving_getx/database/models/conduite.dart';
import 'package:driving_getx/database/services/conduite_service.dart';
import 'package:get/get.dart';

class ConduiteController extends GetxController
    with StateMixin<List<Conduite>> {
  Rx<List<Conduite>> listeConduite = Rx<List<Conduite>>([]);

  getAllConduite() async {
    change(null, status: RxStatus.loading());
    await ServiceConduite.getConduites().then((data) {
      change(data, status: RxStatus.success());
      listeConduite.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return listeConduite.value;
  }
}
