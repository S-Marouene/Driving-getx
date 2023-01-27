// ignore_for_file: depend_on_referenced_packages
import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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
    Widget mLeaderList(Condidat thisCondidat) {
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
              child: Text(thisCondidat.id!.toInt().toString(),
                  style: boldTextStyle(color: Colors.white, size: 16)),
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
                        Container(
                          decoration: boxDecorations(
                              bgColor:
                                  Colors.deepOrangeAccent.withOpacity(0.8)),
                          padding: EdgeInsets.all(16),
                          child: Text(thisCondidat.id.toString(),
                              style: primaryTextStyle(
                                  size: 18, color: Colors.white)),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(thisCondidat.nom! + ' ' + thisCondidat.prenom!,
                                style: primaryTextStyle(
                                    size: 16, color: Colors.white)),
                            Text("Your progress",
                                style: primaryTextStyle(
                                    size: 16, color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16),
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
                          mOption("Exam", "75"),
                          Container(height: 22, color: sdViewColor, width: 1),
                          mOption("Lessons", "80"),
                          Container(height: 22, color: sdViewColor, width: 1),
                          mOption("Pass", "75"),
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

                        // return mLeaderList(mScoreList[index]);
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
}
