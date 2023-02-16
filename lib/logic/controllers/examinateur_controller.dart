import 'package:driving_getx/database/services/Condidat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../database/models/examinateur.dart';

class ExaminateurController extends GetxController
    with StateMixin<List<Examinateur>> {
  Rx<List<Examinateur>> liste = Rx<List<Examinateur>>([]);

  TextEditingController examinateur = TextEditingController();
  TextEditingController ResultatController = TextEditingController();

  var res = "".obs;
  getList() async {
    change(null, status: RxStatus.loading());
    await ServiceCondidats.getExaminateur().then((data) {
      change(data, status: RxStatus.success());
      liste.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return liste.value;
  }

  UpdateExamenRes(ExamenId, examinateur, resultat) async {
    var examenUpdate = {
      "examinateur": examinateur,
      "resultat": resultat,
    };

    await ServiceCondidats.UpdateExamRes(examenUpdate, ExamenId).then((data) {
      if (data != null) {
        if (data["success"] != null) {
          res.value = data["success"].toString();
          // num_listeController.clear();
          // num_convocationController.clear();
          return res.value;
        } else {
          res.value = data.toString();
          //print("ok" + res.value);
          return res.value;
        }
      }
    });
    return res.value;
  }
}
