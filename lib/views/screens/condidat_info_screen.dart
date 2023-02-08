import 'package:double_back_to_close/toast.dart';
import 'package:driving_getx/database/models/caisses.dart';
import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/database/models/payements.dart';
import 'package:driving_getx/logic/controllers/condidatcontroller.dart';
import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:driving_getx/views/widgets/tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:nb_utils/nb_utils.dart';

import '../../main/utils/AppColors.dart';

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
  final ExamenController condi_info_controller = Get.put(ExamenController());

  final PayementController cond_payement_controller =
      Get.put(PayementController());

  final CaisseController caisse_controller = Get.put(CaisseController());

  late List<Examen> AllExam = [];
  late List<Payement> AllPayement = [];
  late List<Caisse> AllCaisse = [];

  late String result = "";
  TextEditingController datePayementAdd = TextEditingController();
  TextEditingController modePayementAdd = TextEditingController();
  TextEditingController TypePayementAdd = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var ModeRadio;
  var TypeRadio;

  List<String> listOfCategory = [];
  String? selectedCaisse;
  String? ChangedCaisse;
  bool selected_caisse = false;

  @override
  void initState() {
    ModeRadio = "Espece";
    TypeRadio = "Paiement";
    TypePayementAdd.text = "Paiement";
    modePayementAdd.text = "Espece";
    cond_payement_controller.datePayementAdd.text =
        DateFormat('yyyy-MM-dd').format(selectedDate);
    condi_info_controller.getListExamenByID(thisCondidat.id);
    cond_payement_controller.getListPayementByID(thisCondidat.id);
    caisse_controller.getListCaisse();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

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
        body: SingleChildScrollView(
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
                                toast('Add exam');
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
                    condi_info_controller.obx(
                      (state) {
                        AllExam = condi_info_controller.listeExamen.value;
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
                        AllPayement =
                            cond_payement_controller.listePayement.value;
                        return AllPayement.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Liste vide"),
                              )
                            : ListView.builder(
                                itemCount: AllPayement.isEmpty
                                    ? 0
                                    : AllPayement.length,
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
        ),
      ),
    );
  }

  Widget CondOption(var mHeading, var mSubHeading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(mHeading,
            style: primaryTextStyle(size: 16, color: sdTextPrimaryColor)),
        SizedBox(height: 4),
        Text(mSubHeading,
            style: primaryTextStyle(size: 14, color: sdTextSecondaryColor))
      ],
    );
  }

  Widget ListExamen(Examen examen) {
    return Container(
      decoration: boxDecorations(showShadow: true),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(examen.typeExamen!, style: boldTextStyle(size: 16)),
              Text(examen.dateExamen!, style: secondaryTextStyle(size: 12)),
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
                    "N° Conv : " + examen.numConvocation!,
                    style: secondaryTextStyle(size: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: sdSecondaryColorYellow.withOpacity(0.7),
            // : sdSecondaryColorYellow.withOpacity(0.7),
            child: Text(examen.resultat!,
                style: boldTextStyle(color: db6_colorPrimaryDark, size: 10)),
          )
        ],
      ),
    );
  }

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
              Text(payement.type!, style: boldTextStyle(size: 16)),
              Text(payement.date_paiement!,
                  style: secondaryTextStyle(size: 12)),
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
                    "Caisse : " + payement.caisse!,
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
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return confirmationAlert(context, payement.id);
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

  FormAddpayment(BuildContext aContext) async {
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
                    Text(
                      "Montant",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
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
                        selectDate(
                            context, setModalState, cond_payement_controller);
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
                                cond_payement_controller);
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

  Widget confirmationAlert(context, id) {
    AlertDialog mAlertItem2 = AlertDialog(
      backgroundColor: appStore.scaffoldBackground,
      title: Text("Confirmation",
          style: boldTextStyle(color: appStore.textPrimaryColor)),
      content: Text(
        "Voulez-vous vraiment supprimer ce paiement ?",
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
            //Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("ok", style: primaryTextStyle(color: Colors.red)),
          onPressed: () {
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
          },
        ),
      ],
    );
    return mAlertItem2;
  }
}
