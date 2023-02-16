import 'package:driving_getx/database/models/bureaux.dart';
import 'package:driving_getx/database/models/caisses.dart';
import 'package:driving_getx/database/models/centreexams.dart';
import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/database/models/payements.dart';
import 'package:driving_getx/logic/controllers/bureau_controller.dart';
import 'package:driving_getx/logic/controllers/centre_exam_controller.dart';
import 'package:driving_getx/logic/controllers/condidatcontroller.dart';
import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:driving_getx/views/screens/resultat_examen.dart';
import 'package:driving_getx/views/widgets/tools_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../logic/controllers/caisse_controller.dart';
import '../../main/utils/AppColors.dart';
// ignore: depend_on_referenced_packages
import 'package:nb_utils/nb_utils.dart';

class CondidatInfoScreen extends StatefulWidget {
  final Condidat thisCondidat;
  const CondidatInfoScreen({super.key, required this.thisCondidat});
  @override
  State<CondidatInfoScreen> createState() =>
      // ignore: no_logic_in_create_state
      _CondidatInfoScreenState(thisCondidat);
}

class _CondidatInfoScreenState extends State<CondidatInfoScreen> {
  Condidat thisCondidat;
  _CondidatInfoScreenState(this.thisCondidat);
  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';
  final ExamenController cond_exam_controller = Get.put(ExamenController());

  final PayementController cond_payement_controller =
      Get.put(PayementController());

  final CaisseController caisse_controller = Get.put(CaisseController());
  final BureauController bureau_controller = Get.put(BureauController());
  final CentreExamController centr_exam_controller =
      Get.put(CentreExamController());

  late List<Examen> AllExam = [];
  late List<Payement> AllPayement = [];
  late List<Caisse> AllCaisse = [];
  late List<Bureau> AllBureau = [];
  late List<CentreExam> AllCentrExam = [];

  late String result = "";
  TextEditingController datePayementAdd = TextEditingController();
  TextEditingController modePayementAdd = TextEditingController();
  TextEditingController TypePayementAdd = TextEditingController();
  TextEditingController TypeExamAdd = TextEditingController();
  TextEditingController dateExamAdd = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var ModeRadio;
  var TypeRadio;
  var TypeExamRadio;
  var ResultatExamRadio;

  List<String> listOfCategory = [];
  String? selectedCaisse;
  String? ChangedCaisse;
  bool selected_caisse = false;

  String? selectedCentrExam;
  String? ChangedCentrExam;
  bool selected_centrExam = false;

  String? selectedBureau;
  String? ChangedBureau;
  bool selected_bureau = false;

  String? time;

  @override
  void initState() {
    ModeRadio = "Espece";
    TypeRadio = "Paiement";
    TypeExamRadio = "Conduite";
    ResultatExamRadio = "Réussi";

    TypePayementAdd.text = "Paiement";
    modePayementAdd.text = "Espece";
    TypeExamAdd.text = "Conduite";

    cond_payement_controller.datePayementAdd.text =
        DateFormat('yyyy-MM-dd').format(selectedDate);

    cond_exam_controller.date_examenController.text =
        DateFormat('yyyy-MM-dd').format(selectedDate);

    cond_exam_controller.getListExamenByID(thisCondidat.id);
    cond_payement_controller.getListPayementByID(thisCondidat.id);
    caisse_controller.getListCaisse();
    centr_exam_controller.getList();
    bureau_controller.getList();

    time =
        "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"}:${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period != DayPeriod.am ? 'PM' : 'AM'}   ";
    cond_exam_controller.timeExamController.text = time!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 55,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 22, 0, 0),
                child: Text("Fiche Condidat",
                    style: boldTextStyle(
                        color: db6_white, size: 15, fontFamily: fontBold)),
              ),
            ),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.favorite_border, color: Colors.white)),
            ],
            backgroundColor: sdPrimaryColor,
            elevation: 0.0,
          ),
          body: CondidatInfoScreen()),
    );
  }

  Widget CondidatInfoScreen() {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(height: width * 0.33, color: sdPrimaryColor),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage('images/app/loading.gif'),
                          image: Image.network(
                            URLpic +
                                (thisCondidat.photo! == ''
                                    ? 'unknown_profile.png'
                                    : thisCondidat.photo!),
                          ).image,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(thisCondidat.nom! + ' ' + thisCondidat.prenom!,
                            style: primaryTextStyle(
                                size: 16, color: Colors.white)),
                        Text(
                            thisCondidat.num_tel == null
                                ? ''
                                : "+ 216 " + thisCondidat.num_tel!,
                            style: primaryTextStyle(
                                size: 14, color: Colors.white)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CondOption(
                          "N° Total",
                          thisCondidat.nbr_heur_total!.nb_heur_total! +
                              " Hr(s)"),
                      Container(height: 22, color: sdViewColor, width: 1),
                      CondOption(
                          "N° Affecter",
                          thisCondidat.nb_heur_affecter!.nb_heur_affecter! +
                              " Hr(s)"),
                      Container(height: 22, color: sdViewColor, width: 1),
                      CondOption("Examen", thisCondidat.examen!),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.work_history_outlined,
                          size: 18,
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 7.0),
                        child: Text("Examens programmée :",
                            style: secondaryTextStyle(
                                size: 14, color: kTextColor))),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton.small(
                          heroTag: '2',
                          elevation: 5,
                          onPressed: () {
                            FormAddExamen(context);
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                cond_exam_controller.obx(
                  (state) {
                    AllExam = cond_exam_controller.listeExamen.value;
                    return AllExam.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Liste vide"),
                          )
                        : ListView.builder(
                            itemCount: AllExam.isEmpty ? 0 : AllExam.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 16),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ListExamen(AllExam[index]);
                            },
                          );
                  },
                  onLoading: showLoadingIndicator(),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.attach_money,
                          size: 18,
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 2.0),
                        child: Text("Payements :",
                            style: secondaryTextStyle(
                                size: 14, color: kTextColor))),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton.small(
                          elevation: 5,
                          onPressed: () {
                            FormAddpayment(context);
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                cond_payement_controller.obx(
                  (state) {
                    AllPayement = cond_payement_controller.listePayement.value;
                    return AllPayement.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Liste vide"),
                          )
                        : ListView.builder(
                            itemCount:
                                AllPayement.isEmpty ? 0 : AllPayement.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 16),
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ListPayement(AllPayement[index]);
                            },
                          );
                  },
                  onLoading: showLoadingIndicator(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color getColorExam(Examen examen) {
    switch (examen.resultat) {
      case 'Réussi':
        return sdSecondaryColorGreen.withOpacity(0.5);
      case 'Ajourné':
        return sdSecondaryColorYellow.withOpacity(0.5);
      case 'Excusé':
        return sdSecondaryColorRed.withOpacity(0.5);
      default:
        return sdPrimaryColor;
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy HH:mm');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  dateformattt(mydate) {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm").parse(mydate);
    return convertDateTimeDisplay(tempDate.toString());
  }

  Widget ListExamen(Examen examen) {
    return Container(
      decoration: boxDecorations(showShadow: true),
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      margin: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Column(
            children: [
              IconButton(
                color: kPrimaryColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ResultatExamen(
                      IDExamen: examen.id.toString(),
                      CondidatID: thisCondidat.id.toString(),
                    ),
                  );
                },
                icon: Icon(Icons.assignment_turned_in_outlined),
              ),
            ],
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: getColorExam(examen),
            child: Text(examen.resultat!,
                style: boldTextStyle(color: Colors.black, size: 10)),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(examen.typeExamen!, style: boldTextStyle(size: 16)),
              Text(
                  dateformattt(examen.dateExamen!).toString() +
                      " " +
                      examen.centreExamen!,
                  style: secondaryTextStyle(size: 8)),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5 * 1.5, // 30 px padding
                    vertical: 10 / 5, // 5 px padding
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 108, 108),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "N° Conv : " +
                        examen.numConvocation! +
                        " -- N° Liste : " +
                        examen.numListe!,
                    style: secondaryTextStyle(size: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Expanded(child: SizedBox.shrink()),
          Column(
            children: [
              IconButton(
                color: sdSecondaryColorRed,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Alert(
                          context,
                          "Confirmation",
                          "Voulez-vous vraiment supprimer ce paiement ?",
                          examen.id,
                          ConfirmDeleteExamen);
                    },
                  );
                },
                icon: Icon(Icons.delete_forever_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future FormAddExamen(BuildContext aContext) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ajout examen",
                      style: boldTextStyle(color: appStore.textPrimaryColor),
                    ),
                    Divider().paddingOnly(top: 16, bottom: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: editNumericStyle("N° convocation",
                              cond_exam_controller.num_convocationController),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Flexible(
                          child: editNumericStyle("Numéro liste",
                              cond_exam_controller.num_listeController),
                        ),
                      ],
                    ),
                    30.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              selectDate(
                                context,
                                setModalState,
                                cond_exam_controller.date_examenController,
                              );
                            },
                            controller:
                                cond_exam_controller.date_examenController,
                            style: TextStyle(color: blackColor),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(24, 16, 24, 16),
                              hintStyle: primaryTextStyle(
                                  color: appStore.isDarkModeOn
                                      ? white.withOpacity(0.5)
                                      : grey),
                              filled: true,
                              labelText: "Date Examen",
                              fillColor: appStore.appBarColor,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: kSecondaryColor, width: 1.0)),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  selectDate(
                                    context,
                                    setModalState,
                                    cond_exam_controller.date_examenController,
                                  );
                                },
                                child: Icon(Icons.calendar_today,
                                    color: kPrimaryColor, size: 16),
                              ),
                              labelStyle: TextStyle(color: gray, fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Flexible(
                          child: TextFormField(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              selectTime(context, setModalState,
                                  cond_exam_controller.timeExamController);
                            },
                            controller: cond_exam_controller.timeExamController,
                            style: TextStyle(color: blackColor),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(24, 16, 24, 16),
                              hintStyle: primaryTextStyle(
                                  color: appStore.isDarkModeOn
                                      ? white.withOpacity(0.5)
                                      : grey),
                              filled: true,
                              labelText: "Heur Examen",
                              fillColor: appStore.appBarColor,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: kSecondaryColor, width: 1.0)),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  selectDate(
                                    context,
                                    setModalState,
                                    cond_exam_controller.timeExamController,
                                  );
                                },
                                child: Icon(Icons.access_time,
                                    color: kPrimaryColor, size: 16),
                              ),
                              labelStyle: TextStyle(color: gray, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    Text(
                      "Type Examen",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: appStore.textPrimaryColor),
                          child: Radio(
                            value: 'Code',
                            groupValue: TypeExamRadio,
                            onChanged: (dynamic value) {
                              setModalState(() {
                                TypeExamRadio = value;
                                TypeExamAdd.text = TypeExamRadio;
                              });
                            },
                          ),
                        ),
                        Text('Code', style: primaryTextStyle()),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: appStore.textPrimaryColor,
                          ),
                          child: Radio(
                            value: 'Conduite',
                            groupValue: TypeExamRadio,
                            onChanged: (dynamic value) {
                              setModalState(() {
                                TypeExamRadio = value;
                                TypeExamAdd.text = TypeExamRadio;
                              });
                            },
                          ),
                        ),
                        Text('Conduite', style: primaryTextStyle()),
                      ],
                    ),
                    16.height,
                    Text(
                      "Centre d'examen",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    centr_exam_controller.obx(
                      (state) {
                        AllCentrExam = centr_exam_controller.liste.value;
                        listOfCategory =
                            AllCentrExam.map((e) => e.libelle.toString())
                                .toList();
                        selectedCentrExam = listOfCategory[0];
                        (!selected_centrExam)
                            ? cond_exam_controller.centre_examenController
                                .text = selectedCentrExam!
                            : cond_exam_controller.centre_examenController
                                .text = ChangedCentrExam!;
                        return Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                              child: DropdownButton(
                                isExpanded: true,
                                dropdownColor: appStore.appBarColor,
                                value: ((!selected_centrExam)
                                    ? selectedCentrExam
                                    : ChangedCentrExam),
                                style: boldTextStyle(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: appStore.iconColor,
                                ),
                                underline: 0.height,
                                onChanged: (dynamic newValue) {
                                  setModalState(() {
                                    selected_centrExam = true;
                                    ChangedCentrExam = newValue;
                                  });
                                },
                                items: listOfCategory.map((caisse) {
                                  return DropdownMenuItem(
                                    value: caisse,
                                    child:
                                        Text(caisse, style: primaryTextStyle())
                                            .paddingLeft(8),
                                  );
                                }).toList(),
                              ),
                            ));
                      },
                      onLoading: showLoadingIndicator(),
                    ),
                    16.height,
                    Text(
                      "Bureau",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    caisse_controller.obx(
                      (state) {
                        AllBureau = bureau_controller.liste.value;
                        listOfCategory =
                            AllBureau.map((e) => e.nom.toString()).toList();
                        selectedBureau = listOfCategory[0];
                        (!selected_bureau)
                            ? cond_exam_controller.bureauontroller.text =
                                selectedBureau!
                            : cond_exam_controller.bureauontroller.text =
                                ChangedBureau!;
                        return Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                              child: DropdownButton(
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
                                underline: 0.height,
                                onChanged: (dynamic newValue) {
                                  setModalState(() {
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
                    16.height,
                    GestureDetector(
                      onTap: () {
                        addExamModal().then((value) {
                          if (value == "true") {
                            finish(context);
                            cond_exam_controller
                                .getListExamenByID(thisCondidat.id);

                            toast("Examen ajouter avec succée");
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
                    15.height,
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<String> addExamModal() async {
    await cond_exam_controller.addExamen(
        thisCondidat.school_id!,
        thisCondidat.school_name!,
        thisCondidat.id!.toString(),
        cond_exam_controller.num_listeController.text,
        cond_exam_controller.num_convocationController.text,
        cond_exam_controller.date_examenController.text +
            " " +
            cond_exam_controller.timeExamController.text,
        /* cond_exam_controller.date_examenController.text, */
        cond_exam_controller.centre_examenController.text,
        TypeExamAdd.text,
        cond_exam_controller.bureauontroller.text);

    result = cond_exam_controller.res.value;

    return result;
  }

  Future<String> Deleteexamen(id) async {
    await cond_exam_controller.DeleteExamenByID(id);
    result = cond_exam_controller.resDelete.value;
    return result;
  }

  void ConfirmDeleteExamen(id) {
    Deleteexamen(id).then((value) {
      if (value == "true") {
        finish(context);
        cond_exam_controller.getListExamenByID(thisCondidat.id);
        toast("Examen supprimer avec succée");
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
  }

  /// Payement
  Widget ListPayement(Payement payement) {
    return Container(
      decoration: boxDecorations(showShadow: true),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
      margin: EdgeInsets.only(top: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: sdSecondaryColorGreen.withOpacity(0.3),
            child: Text(payement.montant! + " DT",
                style: boldTextStyle(color: db6_colorPrimaryDark, size: 11)),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(payement.caisse!, style: boldTextStyle(size: 16)),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(payement.date_paiement!,
                    style: secondaryTextStyle(size: 12)),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5 * 1.5, // 30 px padding
                          vertical: 10 / 5, // 5 px padding
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 108, 108),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Type : " + payement.type!,
                          style:
                              secondaryTextStyle(size: 10, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5 * 1.5, // 30 px padding
                          vertical: 10 / 5, // 5 px padding
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 206, 92, 92),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Mode : " + payement.mode_paiement!,
                          style:
                              secondaryTextStyle(size: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          Expanded(child: SizedBox.shrink()),
          Column(
            children: [
              IconButton(
                color: sdSecondaryColorRed,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Alert(
                          context,
                          "Confirmation",
                          "Voulez-vous vraiment supprimer ce paiement ?",
                          payement.id,
                          ConfirmDeletepayement);
                    },
                  );
                },
                icon: Icon(Icons.delete_forever_sharp),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future FormAddpayment(BuildContext aContext) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ajout paiement",
                      style: boldTextStyle(color: appStore.textPrimaryColor),
                    ),
                    Divider().paddingOnly(top: 16, bottom: 16),
                    Text(
                      "Caisse",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    caisse_controller.obx(
                      (state) {
                        AllCaisse = caisse_controller.listeCaisse.value;
                        listOfCategory =
                            AllCaisse.map((e) => e.caisse.toString()).toList();
                        selectedCaisse = listOfCategory[0];
                        (!selected_caisse)
                            ? cond_payement_controller
                                .caisseTextController.text = selectedCaisse!
                            : cond_payement_controller
                                .caisseTextController.text = ChangedCaisse!;
                        return Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                              child: DropdownButton(
                                isExpanded: true,
                                dropdownColor: appStore.appBarColor,
                                value: ((!selected_caisse)
                                    ? selectedCaisse
                                    : ChangedCaisse),
                                style: boldTextStyle(),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: appStore.iconColor,
                                ),
                                underline: 0.height,
                                onChanged: (dynamic newValue) {
                                  setModalState(() {
                                    selected_caisse = true;
                                    ChangedCaisse = newValue;
                                  });
                                },
                                items: listOfCategory.map((caisse) {
                                  return DropdownMenuItem(
                                    value: caisse,
                                    child:
                                        Text(caisse, style: primaryTextStyle())
                                            .paddingLeft(8),
                                  );
                                }).toList(),
                              ),
                            ));
                      },
                      onLoading: showLoadingIndicator(),
                    ),
                    16.height,
                    Text(
                      "Mode paiement",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: appStore.textPrimaryColor),
                          child: Radio(
                            value: 'Espece',
                            groupValue: ModeRadio,
                            onChanged: (dynamic value) {
                              setModalState(() {
                                ModeRadio = value;
                                modePayementAdd.text = ModeRadio;
                              });
                            },
                          ),
                        ),
                        Text('Espece', style: primaryTextStyle()),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: appStore.textPrimaryColor,
                          ),
                          child: Radio(
                            value: 'Chèque',
                            groupValue: ModeRadio,
                            onChanged: (dynamic value) {
                              setModalState(() {
                                ModeRadio = value;
                                modePayementAdd.text = ModeRadio;
                              });
                            },
                          ),
                        ),
                        Text('Chèque', style: primaryTextStyle()),
                      ],
                    ),
                    16.height,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextFormField(
                        controller:
                            cond_payement_controller.montantTextController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 16, fontFamily: fontRegular),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                          hintText: "Montant",
                          hintStyle: primaryTextStyle(
                              color: appStore.isDarkModeOn
                                  ? white.withOpacity(0.5)
                                  : grey),
                          filled: true,
                          labelText: "Montant",
                          fillColor: appStore.appBarColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: kSecondaryColor, width: 1.0)),
                        ),
                      ),
                    ),
                    16.height,
                    Text(
                      " Type",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor: appStore.textPrimaryColor),
                          child: Radio(
                            value: 'Paiement',
                            groupValue: TypeRadio,
                            onChanged: (dynamic value) {
                              setModalState(() {
                                TypeRadio = value;
                                TypePayementAdd.text = TypeRadio;
                              });
                            },
                          ),
                        ),
                        Text('Paiement', style: primaryTextStyle()),
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: appStore.textPrimaryColor,
                          ),
                          child: Radio(
                            value: 'Remise',
                            groupValue: TypeRadio,
                            onChanged: (dynamic value) {
                              setModalState(() {
                                TypeRadio = value;
                                TypePayementAdd.text = TypeRadio;
                              });
                            },
                          ),
                        ),
                        Text('Remise', style: primaryTextStyle()),
                      ],
                    ),
                    16.height,
                    Text(
                      "Date Payement",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectDate(context, setModalState,
                            cond_payement_controller.datePayementAdd);
                      },
                      controller: cond_payement_controller.datePayementAdd,
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kBlueColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kDefaultIconDarkColor)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            selectDate(context, setModalState,
                                cond_payement_controller.datePayementAdd);
                          },
                          child: Icon(Icons.calendar_today,
                              color: kPrimaryColor, size: 16),
                        ),
                        labelStyle: TextStyle(color: gray, fontSize: 14),
                      ),
                    ),
                    16.height,
                    40.height,
                    GestureDetector(
                      onTap: () {
                        addPayementModal().then((value) {
                          if (value == "true") {
                            finish(context);
                            cond_payement_controller
                                .getListPayementByID(thisCondidat.id);

                            toast("Payement ajouter avec succée");
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
                    40.height,
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<String> addPayementModal() async {
    await cond_payement_controller.addPayement(
        thisCondidat.school_id!,
        thisCondidat.school_name!,
        thisCondidat.id!.toString(),
        cond_payement_controller.caisseTextController.text,
        TypePayementAdd.text,
        cond_payement_controller.montantTextController.text,
        modePayementAdd.text,
        cond_payement_controller.datePayementAdd.text);

    result = cond_payement_controller.res.value;
    return result;
  }

  Future<String> Deletepayement(id) async {
    await cond_payement_controller.DeletePayementByID(id);
    result = cond_payement_controller.resDelete.value;
    return result;
  }

  void ConfirmDeletepayement(id) {
    Deletepayement(id).then((value) {
      if (value == "true") {
        finish(context);
        cond_payement_controller.getListPayementByID(thisCondidat.id);
        toast("Payement supprimer avec succée");
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
  }

  Widget Alert(context, String title, String msg, id, fnc) {
    AlertDialog mAlertItem = AlertDialog(
      backgroundColor: appStore.scaffoldBackground,
      title:
          Text(title, style: boldTextStyle(color: appStore.textPrimaryColor)),
      content: Text(
        msg,
        style: secondaryTextStyle(color: appStore.textSecondaryColor),
      ),
      actions: [
        TextButton(
          child: Text(
            "Annuler",
            style: primaryTextStyle(color: appColorPrimary),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("ok", style: primaryTextStyle(color: Colors.redAccent)),
          onPressed: () {
            fnc(id);
          },
        ),
      ],
    );
    return mAlertItem;
  }
}
