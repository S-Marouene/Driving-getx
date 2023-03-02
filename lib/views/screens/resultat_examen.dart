import 'package:driving_getx/database/models/examinateur.dart';
import 'package:driving_getx/logic/controllers/examen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controllers/examinateur_controller.dart';
import '../../main/utils/AppWidget.dart';
import '../../main/utils/SDStyle.dart';
import '../widgets/tools_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:nb_utils/nb_utils.dart';

class ResultatExamen extends StatefulWidget {
  final String IDExamen;
  final String CondidatID;
  const ResultatExamen({super.key, required this.IDExamen, required this.CondidatID});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _ResultatExamenState createState() =>
      // ignore: no_logic_in_create_state
      _ResultatExamenState(IDExamen, CondidatID);
}

class _ResultatExamenState extends State<ResultatExamen> {
  var ResultatExamRadio;
  String IDExamen;
  String CondidatID;
  _ResultatExamenState(this.IDExamen, this.CondidatID);

  //Condidat MyCondidat=thisCondidat;

  late String result = "";

  late List<Examinateur> AllExaminateur = [];
  List<String> listOfCategory = [];
  String? selectedCentrExam;
  String? ChangedCentrExam;
  bool selected_centrExam = false;

  final ExaminateurController examinateur_controller = Get.put(ExaminateurController());
  final ExamenController cond_exam_controller = Get.find();

  @override
  void initState() {
    ResultatExamRadio = "Réussi";
    examinateur_controller.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: appStore.scaffoldBackground,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Résultat', style: boldTextStyle(color: appStore.textPrimaryColor, size: 20)),
              GestureDetector(
                onTap: () {
                  finish(context);
                },
                child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, color: appStore.textPrimaryColor)),
              ),
            ]),
            16.height,
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(unselectedWidgetColor: appStore.textPrimaryColor),
                      child: Radio(
                        value: 'Réussi',
                        groupValue: ResultatExamRadio,
                        onChanged: (dynamic value) {
                          setState(() {
                            ResultatExamRadio = value;
                            examinateur_controller.ResultatController.text = ResultatExamRadio;
                          });
                        },
                      ),
                    ),
                    Text('Réussi', style: primaryTextStyle()),
                    Theme(
                      data: Theme.of(context).copyWith(unselectedWidgetColor: appStore.textPrimaryColor),
                      child: Radio(
                        value: 'Ajourné',
                        groupValue: ResultatExamRadio,
                        onChanged: (dynamic value) {
                          setState(() {
                            ResultatExamRadio = value;
                            examinateur_controller.ResultatController.text = ResultatExamRadio;
                          });
                        },
                      ),
                    ),
                    Text('Ajourné', style: primaryTextStyle()),
                  ],
                ),
                Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(unselectedWidgetColor: appStore.textPrimaryColor),
                      child: Radio(
                        value: 'En cours',
                        groupValue: ResultatExamRadio,
                        onChanged: (dynamic value) {
                          setState(() {
                            ResultatExamRadio = value;
                            examinateur_controller.ResultatController.text = ResultatExamRadio;
                          });
                        },
                      ),
                    ),
                    Text('En cours', style: primaryTextStyle()),
                    Theme(
                      data: Theme.of(context).copyWith(unselectedWidgetColor: appStore.textPrimaryColor),
                      child: Radio(
                        value: 'Excusé',
                        groupValue: ResultatExamRadio,
                        onChanged: (dynamic value) {
                          setState(() {
                            ResultatExamRadio = value;
                            examinateur_controller.ResultatController.text = ResultatExamRadio;
                          });
                        },
                      ),
                    ),
                    Text('Excusé', style: primaryTextStyle()),
                  ],
                ),
              ],
            ),
            16.height,
            Text(
              "Examinateur",
              style: primaryTextStyle(color: appStore.textPrimaryColor),
            ),
            16.height,
            examinateur_controller.obx(
              (state) {
                AllExaminateur = examinateur_controller.liste.value;
                listOfCategory = AllExaminateur.map((e) => (e.prenom.toString() + " " + e.nom.toString())).toList();

                selectedCentrExam = listOfCategory[0];
                (!selected_centrExam)
                    ? examinateur_controller.examinateur.text = selectedCentrExam!
                    : examinateur_controller.examinateur.text = ChangedCentrExam!;
                return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: appStore.appBarColor,
                        value: ((!selected_centrExam) ? selectedCentrExam : ChangedCentrExam),
                        style: boldTextStyle(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: appStore.iconColor,
                        ),
                        underline: 0.height,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            selected_centrExam = true;
                            ChangedCentrExam = newValue;
                          });
                        },
                        items: listOfCategory.map((caisse) {
                          return DropdownMenuItem(
                            value: caisse,
                            child: Text(caisse, style: primaryTextStyle()).paddingLeft(8),
                          );
                        }).toList(),
                      ),
                    ));
              },
              onLoading: showLoadingIndicator(),
            ),
            30.height,
            GestureDetector(
              onTap: () {
                addRESModal(IDExamen).then((value) {
                  if (value == "true") {
                    finish(context);

                    cond_exam_controller.getListExamenByID(CondidatID);

                    toast("Résultat ajouter avec succée");
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
                decoration: boxDecorations(bgColor: Colors.indigo, radius: 10),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Center(
                  child: Text("Valider", style: boldTextStyle(color: white)),
                ),
              ),
            ),
            16.height,
          ],
        ),
      ),
    );
  }

  Future<String> addRESModal(String IDExamen) async {
    await examinateur_controller.UpdateExamenRes(
      IDExamen,
      examinateur_controller.examinateur.text,
      examinateur_controller.ResultatController.text,
    );

    result = examinateur_controller.res.value;

    return result;
  }
}
