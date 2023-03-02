import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/models/payements.dart';
import 'package:driving_getx/database/services/Condidat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CondidatController extends GetxController with StateMixin<List<Condidat>> {
  Rx<List<Condidat>> listeAll = Rx<List<Condidat>>([]);

  getListCondidat() async {
    change(null, status: RxStatus.loading());
    await ServiceCondidats.getCondidats().then((data) {
      change(data, status: RxStatus.success());
      listeAll.value = data;
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return listeAll.value;
  }
}

class PayementController extends GetxController with StateMixin<List<Payement>> {
  Rx<List<Payement>> listePayement = Rx<List<Payement>>([]);

  TextEditingController caisseTextController = TextEditingController();
  TextEditingController typeTextController = TextEditingController();
  TextEditingController montantTextController = TextEditingController();
  TextEditingController mode_paiementtextController = TextEditingController();
  TextEditingController datePayementAdd = TextEditingController();
  var res = "".obs;
  var resDelete = "".obs;

  @override
  void onClose() {
    super.onClose();
    caisseTextController.dispose();
    typeTextController.dispose();
    montantTextController.dispose();
    datePayementAdd.dispose();
  }

  getListPayementByID(id) async {
    change(null, status: RxStatus.loading());
    await ServiceCondidats.getPayementByid(id).then((data) {
      change(data, status: RxStatus.success());
      listePayement.value = data;
      //print(data);
    }, onError: (error) {
      change(null, status: RxStatus.error(error.toString()));
    });
    return listePayement.value;
  }

  DeletePayementByID(id) async {
    await ServiceCondidats.DeletePayementServ(id).then((data) {
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

  addPayement(String schoolId, String schoolName, String condidatId, String caisse, String type, String montant,
      String mode_paiement, String date_paiement) async {
    Payement paymentModel = Payement.fromJson({
      "school_id": schoolId,
      "school_name": schoolName,
      "condidat_id": condidatId,
      "caisse": caisse,
      "type": type,
      "montant": montant,
      "mode_paiement": mode_paiement,
      "date_paiement": date_paiement
    });

    await ServiceCondidats.AddPayementServ(paymentModel).then((data) {
      if (data != null) {
        if (data["success"] != null) {
          res.value = data["success"].toString();
          caisseTextController.clear();
          typeTextController.clear();
          montantTextController.clear();
          return res.value;
        } else {
          res.value = data.toString();
          return res.value;
        }
      }
    });
    return res.value;
  }
}
