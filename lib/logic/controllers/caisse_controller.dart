import 'package:driving_getx/database/services/Condidat_service.dart';
import 'package:get/get.dart';
import '../../database/models/caisses.dart';

class CaisseController extends GetxController with StateMixin<List<Caisse>> {
  Rx<List<Caisse>> listeCaisse = Rx<List<Caisse>>([]);

  getListCaisse() async {
    change(null, status: RxStatus.loading());
    await ServiceCondidats.getCaisse().then((data) {
      change(data, status: RxStatus.success());
      listeCaisse.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return listeCaisse.value;
  }
}
