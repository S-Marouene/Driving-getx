import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/logic/controllers/listecondidatcontroller.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:driving_getx/routes/routes.dart';
import 'package:driving_getx/views/screens/condidat_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ListeAllCondidat extends GetView<ListeCondidatController> {
  ListeAllCondidat(this.size, {Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final size;
  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';

  @override
  Widget build(BuildContext context) {
    return controller.obx((condidat) => Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 25, left: 16, bottom: 16),
              width: size!.width,
              color: sdPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Liste des condidats',
                    style: boldTextStyle(
                        size: 18, color: Colors.white, letterSpacing: 0.5),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      'Liste de tous les condidats en cours',
                      style: secondaryTextStyle(
                        size: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
        ));
  }
}
