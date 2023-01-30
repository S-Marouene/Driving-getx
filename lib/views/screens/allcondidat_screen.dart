// ignore_for_file: depend_on_referenced_packages
import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/logic/controllers/listecondidatcontroller.dart';
import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:driving_getx/views/screens/condidat_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ListeAllCondidat extends GetView<ListeCondidatController> {
  ListeAllCondidat(this.size, {Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final size;
  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';
  double expandHeight = 200;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: expandHeight,
            floating: true,
            automaticallyImplyLeading: false,
            forceElevated: innerBoxIsScrolled,
            pinned: true,
            titleSpacing: 0,
            backgroundColor:
                innerBoxIsScrolled ? db6_colorPrimary : sdPrimaryColor,
            actionsIconTheme: IconThemeData(opacity: 0.0),
            title: SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: Text("Sm-Dev",
                    style: boldTextStyle(
                        color: db6_white, size: 24, fontFamily: fontBold)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: 200,
                margin: EdgeInsets.only(top: 70),
                color: sdPrimaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.article_outlined,
                                        color: db6_white, size: 16),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Liste des condidats',
                                  style: boldTextStyle(
                                      size: 17,
                                      color: Colors.white,
                                      letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: white),
                        alignment: Alignment.center,
                        child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              fillColor: db6_white,
                              hintText: "Recherche",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.only(
                                  left: 26.0,
                                  bottom: 8.0,
                                  top: 8.0,
                                  right: 50.0),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ];
      },
      body: controller.obx((condidat) => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 16),
                  scrollDirection: Axis.vertical,
                  itemCount: condidat == null ? 0 : condidat.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CondidatInfoScreen(
                              thisCondidat: condidat[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 16, bottom: 16),
                        width: size.width,
                        decoration: boxDecorations(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: (index + 1) == 1
                                  ? Color(0xFFFFD700)
                                  : (index + 1) == 2
                                      ? Colors.grey.withOpacity(0.5)
                                      : (index + 1) == 3
                                          ? Colors.red.withOpacity(0.5)
                                          : Colors.transparent,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: (index + 1) == 1
                                    ? Color(0xFFD4AF37)
                                    : (index + 1) == 2
                                        ? Colors.grey.withOpacity(0.5)
                                        : (index + 1) == 3
                                            ? Colors.red.withOpacity(0.5)
                                            : Colors.transparent,
                                child: Text(
                                  (index + 1).toString(),
                                  style: secondaryTextStyle(
                                      size: 14,
                                      color: (index + 1) == 1 ||
                                              (index + 1) == 2 ||
                                              (index + 1) == 3
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              height: 45,
                              width: 45,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder:
                                      AssetImage('images/app/loading.gif'),
                                  image: Image.network(
                                          URLpic +
                                              (condidat![index].photo! == ''
                                                  ? 'unknown_profile.png'
                                                  : condidat[index].photo!),
                                          height: 35,
                                          width: 10)
                                      .image,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      condidat[index].nom! +
                                          ' ' +
                                          condidat[index].prenom!,
                                      style: boldTextStyle(size: 16)),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(condidat[index].num_tel ?? "",
                                        style: secondaryTextStyle(size: 12)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5 * 1.5, // 30 px padding
                                vertical: 5 / 5, // 5 px padding
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 233, 108, 108),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                condidat[index].examen!,
                                style: secondaryTextStyle(
                                    size: 12, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    ));
  }
}
