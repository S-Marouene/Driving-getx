import 'package:driving_getx/database/models/centreexams.dart';
import 'package:driving_getx/database/services/Condidat_service.dart';
import 'package:get/get.dart';

class CentreExamController extends GetxController
    with StateMixin<List<CentreExam>> {
  Rx<List<CentreExam>> liste = Rx<List<CentreExam>>([]);

  getList() async {
    change(null, status: RxStatus.loading());
    await ServiceCondidats.Listcentre_exam().then((data) {
      change(data, status: RxStatus.success());
      liste.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return liste.value;
  }
}
