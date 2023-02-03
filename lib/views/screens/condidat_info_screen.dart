import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/database/models/payements.dart';
import 'package:driving_getx/logic/controllers/condidatcontroller.dart';
import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  final ExamenController condi_info_controller = Get.put(ExamenController());

  final AddpayementController addpayementController =
      Get.put(AddpayementController());

  final PayementController cond_payement_controller =
      Get.put(PayementController());
  late List<Examen> AllExam = [];
  late List<Payement> AllPayement = [];
  late String result = "test_";

  TextEditingController datePayementAdd = TextEditingController();

  DateTime selectedDate = DateTime.now();
  Future<void> selectDate(
      BuildContext context, StateSetter setModalState) async {
    final DateTime? picked = await showDatePicker(
        helpText: 'Selectionner la date',
        cancelText: 'Annuler',
        confirmText: "Ok",
        fieldLabelText: 'Booking Date',
        fieldHintText: 'Month/Date/Year',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        context: context,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setModalState(() {
        selectedDate = picked;
        datePayementAdd.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    datePayementAdd.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    condi_info_controller.getListExamenByID(thisCondidat.id);
    cond_payement_controller.getListPayementByID(thisCondidat.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              finish(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.favorite_border, color: Colors.white)),
          ],
          backgroundColor: sdPrimaryColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(height: width * 0.3, color: sdPrimaryColor),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
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
                          mOption(
                              "N° Total",
                              thisCondidat.nbr_heur_total!.nb_heur_total! +
                                  " Hr(s)"),
                          Container(height: 22, color: sdViewColor, width: 1),
                          mOption(
                              "N° Affecter",
                              thisCondidat.nb_heur_affecter!.nb_heur_affecter! +
                                  " Hr(s)"),
                          Container(height: 22, color: sdViewColor, width: 1),
                          mOption("Examen", thisCondidat.examen!),
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
                              //heroTag: '1',
                              elevation: 5,
                              onPressed: () {
                                mFormBottomSheet(context);

                                //toast('Add payment');
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

  Widget mOption(var mHeading, var mSubHeading) {
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
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          CircleAvatar(
            radius: 25,
            backgroundColor: sdSecondaryColorGreen.withOpacity(0.3),
            // : sdSecondaryColorYellow.withOpacity(0.7),
            child: Text(payement.montant! + " DT",
                style: boldTextStyle(color: db6_colorPrimaryDark, size: 11)),
          )
        ],
      ),
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: sdPrimaryColor,
      ),
    );
  }

  mFormBottomSheet(BuildContext aContext) async {
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
                    editTextStyle("Caisse",
                        addpayementController.caisseTextEditingController),
                    16.height,
                    Text(
                      "Mode paiement",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    editTextStyle("Mode paiement",
                        addpayementController.mode_paiementtextController),
                    16.height,
                    Text(
                      "Montant",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    editTextStyle(
                        "Montant", addpayementController.montantTextController),
                    16.height,
                    Text(
                      " Type",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    8.height,
                    editTextStyle(" Type",
                        addpayementController.typeTextEditingController),
                    16.height,
                    Text(
                      "Date Payement",
                      style: primaryTextStyle(color: appStore.textPrimaryColor),
                    ),
                    TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectDate(context, setModalState);
                      },
                      controller: datePayementAdd,
                      style: TextStyle(color: blackColor),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kBlueColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kDefaultIconDarkColor)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            selectDate(context, setModalState);
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
                        addPay().then((value) {
                          // print("bbbbbbb" + value);
                          if (value == "true") {
                            finish(context);
                            cond_payement_controller
                                .getListPayementByID(thisCondidat.id);

                            // print("success");
                          } else {
                            Get.snackbar(
                              "opération echouée",
                              value,
                              colorText: Colors.black,
                              snackPosition: SnackPosition.BOTTOM,
                              icon: Icon(Icons.error, color: Colors.white),
                              backgroundColor: Colors.blue,
                              margin: EdgeInsets.all(15),
                              isDismissible: true,
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                            //print("errrooooooor");
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

  Future<String> addPay() async {
    await addpayementController.addEmployee(
        thisCondidat.school_id!,
        thisCondidat.school_name!,
        thisCondidat.id!.toString(),
        addpayementController.caisseTextEditingController.text,
        addpayementController.typeTextEditingController.text,
        addpayementController.montantTextController.text,
        addpayementController.mode_paiementtextController.text,
        datePayementAdd.text);
    result = addpayementController.res.value;
    return result;
  }

  Padding editTextStyle(var hintText, var namefield) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        controller: namefield,
        style: TextStyle(fontSize: 16, fontFamily: fontRegular),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 16),
          hintText: hintText,
          hintStyle: primaryTextStyle(
              color: appStore.isDarkModeOn ? white.withOpacity(0.5) : grey),
          filled: true,
          fillColor: appStore.appBarColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: kPrimaryColor, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: kSecondaryColor, width: 1.0)),
        ),
      ),
    );
  }
}
