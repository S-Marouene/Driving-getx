import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/database/services/examen_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamenController extends GetxController with StateMixin<List<Examen>> {
  Rx<List<Examen>> listeExamen = Rx<List<Examen>>([]);

  TextEditingController num_listeController = TextEditingController();
  TextEditingController num_convocationController = TextEditingController();
  TextEditingController date_examenController = TextEditingController();
  TextEditingController centre_examenController = TextEditingController();
  TextEditingController type_examenController = TextEditingController();
  TextEditingController bureauontroller = TextEditingController();
  TextEditingController resultatController = TextEditingController();
  TextEditingController examinateurController = TextEditingController();
  TextEditingController timeExamController = TextEditingController();

  var res = "".obs;
  var resDelete = "".obs;

  getListExamenByID(id) async {
    change(null, status: RxStatus.loading());
    await ServiceExamens.getExamByid(id).then((data) {
      change(data, status: RxStatus.success());
      listeExamen.value = data;
      //print(data);
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return listeExamen.value;
  }

  addExamen(
    String schoolId,
    String schoolName,
    String condidatId,
    String numListe,
    String numConvocation,
    String dateExamen,
    String centreExamen,
    String typeExamen,
    String bureau,
  ) async {
    Examen examenModel = Examen.fromJson({
      "school_id": schoolId,
      "school_name": schoolName,
      "condidat_id": condidatId,
      "num_liste": numListe,
      "num_convocation": numConvocation,
      "date_examen": dateExamen,
      "centre_examen": centreExamen,
      "type_examen": typeExamen,
      "bureau": bureau
    });

    await ServiceExamens.AddExamServ(examenModel).then((data) {
      //print(data);
      if (data != null) {
        if (data["success"] != null) {
          res.value = data["success"].toString();
          num_listeController.clear();
          num_convocationController.clear();
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

  DeleteExamenByID(id) async {
    await ServiceExamens.DeleteExamentServ(id).then((data) {
      if (data != null) {
        if (data["success"] != null) {
          resDelete.value = data["success"].toString();
          return resDelete.value;
        } else {
          resDelete.value = data.toString();
          return resDelete.value;
        }
      }
    });
    return resDelete.value;
  }

  Rx<List<Examen>> ListExamClrd = Rx<List<Examen>>([]);

  getallExmCalndr() async {
    change(null, status: RxStatus.loading());
    await ServiceExamens.getAllexamCldr().then((data) {
      change(data, status: RxStatus.success());
      ListExamClrd.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return ListExamClrd.value;
  }
}
