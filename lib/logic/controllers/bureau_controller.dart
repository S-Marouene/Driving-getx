import 'package:driving_getx/database/models/bureaux.dart';
import 'package:driving_getx/database/services/Condidat_service.dart';
import 'package:get/get.dart';

class BureauController extends GetxController with StateMixin<List<Bureau>> {
  Rx<List<Bureau>> liste = Rx<List<Bureau>>([]);

  getList() async {
    change(null, status: RxStatus.loading());
    await ServiceCondidats.Listbureau().then((data) {
      change(data, status: RxStatus.success());
      liste.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return liste.value;
  }
}
