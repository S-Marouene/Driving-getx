// ignore_for_file: depend_on_referenced_packages
import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/logic/controllers/condidatcontroller.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late List<Examen> AllExam = [];

  @override
  void initState() {
    condi_info_controller.getListExamenByID(thisCondidat.id);
    //AllExam = condi_info_controller.listeExamen.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                Text(examen.centreExamen!, style: secondaryTextStyle(size: 10)),
              ],
            ),
            /*  CircleAvatar(
              radius: 15,
              backgroundColor: (thisCondidat.id! > 70)
                  ? sdSecondaryColorGreen.withOpacity(0.7)
                  : sdSecondaryColorYellow.withOpacity(0.7),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('images/app/loading.gif'),
                image: Image.network(
                        URLpic +
                            (thisCondidat.photo! == ''
                                ? 'unknown_profile.png'
                                : thisCondidat.photo!),
                        height: 36,
                        width: 10)
                    .image,
              ),
              /* child: Text(thisCondidat.id!.toInt().toString(),
                  style: boldTextStyle(color: Colors.white, size: 16)), */
            ) */
          ],
        ),
      );
    }

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
                      decoration: boxDecoration(
                          radius: 8,
                          backGroundColor: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 10),
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
                    SizedBox(height: 16),
                    Text("List of exams",
                        style: secondaryTextStyle(
                            size: 14, color: sdTextSecondaryColor)),
                    condi_info_controller.obx(
                      (state) {
                        /*  condi_info_controller
                            .getListExamenByID(thisCondidat.id);
                        */
                        AllExam = condi_info_controller.listeExamen.value;

                        return ListView.builder(
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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
}

 















/*
class CondidatInfoScreen extends StatelessWidget {
  final Condidat thisCondidat;

  const CondidatInfoScreen({Key? key, required this.thisCondidat})
      : super(key: key);

  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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

    // ignore: unused_element
    Widget ListExamen(Condidat thisCondidat) {
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
                Text(thisCondidat.nom!, style: boldTextStyle(size: 16)),
                Text(thisCondidat.prenom!, style: secondaryTextStyle(size: 10)),
              ],
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: (thisCondidat.id! > 70)
                  ? sdSecondaryColorGreen.withOpacity(0.7)
                  : sdSecondaryColorYellow.withOpacity(0.7),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('images/app/loading.gif'),
                image: Image.network(
                        URLpic +
                            (thisCondidat.photo! == ''
                                ? 'unknown_profile.png'
                                : thisCondidat.photo!),
                        height: 36,
                        width: 10)
                    .image,
              ),
              /* child: Text(thisCondidat.id!.toInt().toString(),
                  style: boldTextStyle(color: Colors.white, size: 16)), */
            )
          ],
        ),
      );
    }

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
                      decoration: boxDecoration(
                          radius: 8,
                          backGroundColor: Colors.white,
                          spreadRadius: 2,
                          blurRadius: 10),
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
                    SizedBox(height: 16),
                    Text("List of exams",
                        style: secondaryTextStyle(
                            size: 14, color: sdTextSecondaryColor)),
                    ListView.builder(
                      //itemCount: mScoreList.length,
                      itemCount: 5,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return null;

                        // return ListExamen(mScoreList[index]);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
