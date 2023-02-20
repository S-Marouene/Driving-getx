import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../database/models/bureaux.dart';
import '../../logic/controllers/add_condidat_controller.dart';
import '../../logic/controllers/bureau_controller.dart';
import '../../main/utils/AppConstant.dart';
import '../widgets/tools_widget.dart';

class AddCondidat extends StatefulWidget {
  static String tag = "/AddCondidat";

  const AddCondidat({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCondidatState createState() => _AddCondidatState();
}

class _AddCondidatState extends State<AddCondidat> {
  final AddCondidatController addCondidatController = Get.find();
  final BureauController bureau_controller = Get.put(BureauController());
  late String result = "";

  late List<Bureau> AllBureau = [];
  List<String> listOfCategory = [];
  String? selectedBureau;
  String? ChangedBureau;
  bool selected_bureau = false;

  @override
  void initState() {
    super.initState();
    bureau_controller.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: SizedBox(
          height: 55,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 22, 0, 0),
            child: Text("Ajout condidat",
                style: boldTextStyle(
                    color: db6_white, size: 15, fontFamily: fontBold)),
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.verified_user_outlined, color: Colors.white)),
        ],
        backgroundColor: sdPrimaryColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: addCondidatController.addcondidatFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Wrap(
            runSpacing: 16,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: primaryTextStyle(),
                      controller: addCondidatController.nom,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        labelText: 'Nom',
                        labelStyle: primaryTextStyle(size: 14),
                        filled: true,
                      ),
                      cursorColor: appStore.isDarkModeOn ? white : blackColor,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        return addCondidatController.validateNom(value!);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextFormField(
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        labelText: 'Prénom',
                        labelStyle: primaryTextStyle(size: 14),
                        filled: true,
                      ),
                      cursorColor: appStore.isDarkModeOn ? white : blackColor,
                      controller: addCondidatController.prenom,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        labelText: 'CIN',
                        labelStyle: primaryTextStyle(size: 14),
                        filled: true,
                      ),
                      cursorColor: appStore.isDarkModeOn ? white : blackColor,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      controller: addCondidatController.cin,
                      validator: (value) {
                        return addCondidatController.validateCIN(value!);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectDate(context, setState,
                            addCondidatController.datenaissance);
                      },
                      controller: addCondidatController.datenaissance,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        labelText: 'Date naissance',
                        labelStyle: primaryTextStyle(size: 14),
                        filled: true,
                      ),
                      cursorColor: appStore.isDarkModeOn ? white : blackColor,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: addCondidatController.num_tel,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        labelText: "Telephone",
                        labelStyle: primaryTextStyle(size: 14),
                        prefixIcon: Icon(Icons.phone, color: Colors.blue),
                        filled: true,
                      ),
                      cursorColor: appStore.isDarkModeOn ? white : blackColor,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextField(
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                        labelText: 'Adresse',
                        labelStyle: primaryTextStyle(size: 14),
                        filled: true,
                      ),
                      cursorColor: appStore.isDarkModeOn ? white : blackColor,
                      keyboardType: TextInputType.text,
                      controller: addCondidatController.adresse,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: bureau_controller.obx(
                      (state) {
                        AllBureau = bureau_controller.liste.value;
                        listOfCategory =
                            AllBureau.map((e) => e.nom.toString()).toList();
                        selectedBureau = listOfCategory[0];
                        (!selected_bureau)
                            ? addCondidatController.bureau.text =
                                selectedBureau!
                            : addCondidatController.bureau.text =
                                ChangedBureau!;
                        return Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                dropdownColor: appStore.appBarColor,
                                value: ((!selected_bureau)
                                    ? selectedBureau
                                    : ChangedBureau),
                                style: boldTextStyle(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: appStore.iconColor,
                                ),
                                // underline: 0.height,
                                onChanged: (dynamic newValue) {
                                  setState(() {
                                    selected_bureau = true;
                                    ChangedBureau = newValue;
                                  });
                                },
                                items: listOfCategory.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child:
                                        Text(value, style: primaryTextStyle())
                                            .paddingLeft(8),
                                  );
                                }).toList(),
                              ),
                            ));
                      },
                      onLoading: showLoadingIndicator(),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  addCondidatController.checkValide();
                  AddFormCondidat().then((value) {
                    if (value == "Condidat successfully created") {
                      finish(context);
                      Get.offNamed("/all_condidat");
                      //Get.toNamed();
                      toast("Condidat ajouter avec succée");
                    } else {
                      Get.snackbar(
                        "opération echouée",
                        value,
                        colorText: Colors.black,
                        snackPosition: SnackPosition.BOTTOM,
                        icon: Icon(Icons.error, color: Colors.white),
                        backgroundColor: Color.fromARGB(255, 216, 46, 24),
                        margin: EdgeInsets.all(15),
                        isDismissible: true,
                        forwardAnimationCurve: Curves.easeOutBack,
                      );
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          //topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      color: kPrimaryColor),
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Center(
                    child: Text(
                      "Enregistrer",
                      style: primaryTextStyle(color: white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> AddFormCondidat() async {
    var modleonc = {
      "nom": addCondidatController.nom.text,
      "prenom": addCondidatController.prenom.text,
      "num_tel": addCondidatController.num_tel.text,
      "cin": addCondidatController.cin.text,
      "adresse": addCondidatController.adresse.text,
      "date_naiss": addCondidatController.datenaissance.text,
      "bureau": addCondidatController.bureau.text,
    };

    await addCondidatController.submitRequest(modleonc);

    result = addCondidatController.res.value;

    return result;
  }
}
