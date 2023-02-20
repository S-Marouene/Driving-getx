import 'package:driving_getx/database/models/condidats.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../database/services/Condidat_service.dart';

class AddCondidatController extends GetxController {
  final GlobalKey<FormState> addcondidatFormKey = GlobalKey<FormState>();

  late TextEditingController datenaissance,
      nom,
      prenom,
      cin,
      adresse,
      bureau,
      num_tel;
  var res = "".obs;
  var resDelete = "".obs;

  @override
  void onInit() {
    super.onInit();
    datenaissance = TextEditingController();
    nom = TextEditingController();
    prenom = TextEditingController();
    cin = TextEditingController();
    adresse = TextEditingController();
    bureau = TextEditingController();
    num_tel = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    datenaissance.dispose();
    nom.dispose();
    prenom.dispose();
    cin.dispose();
    adresse.dispose();
  }

  String? validateNom(String value) {
    if (value == "") {
      return "Nom requis";
    }
    return null;
  }

  String? validateCIN(String value) {
    if ((value.length < 8) || (value == "")) {
      return "CIN requis 8 charactère";
    }
    return null;
  }

  void checkValide() {
    final isValid = addcondidatFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    addcondidatFormKey.currentState!.save();
  }

  submitRequest(model) async {
    if (addcondidatFormKey.currentState!.validate()) {
      await ServiceCondidats.AddConidiatServ(model).then((data) {
        if (data != null) {
          if (data["message"] != null) {
            res.value = data["message"].toString();
            datenaissance.clear();
            nom.clear();
            prenom.clear();
            cin.clear();
            adresse.clear();
            return res.value;
          } else {
            res.value = data.toString();
            return res.value;
          }
        }
      });
    } else {
      res.value = "Verifier les informations !";
    }

    return res.value;
  }
}
