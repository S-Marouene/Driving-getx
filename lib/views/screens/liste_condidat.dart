import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/logic/controllers/listecondidatcontroller.dart';
import 'package:driving_getx/views/screens/condidat_card_screen.dart';
import 'package:driving_getx/views/screens/details_condidat/details_condidat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/nav-drawer.dart';

class ListeCondidat extends GetView<ListeCondidatController> {
  ListeCondidat({Key? key}) : super(key: key);
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste Condidat'),
      ),
      drawer: const NavDrawer(),
      body: controller.obx((data) => Center(
          child: ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) => CondidatCard(
                    itemIndex: index,
                    condidat: data[index],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            condidat: data[index],
                          ),
                        ),
                      );
                    },
                  )))),
    );
  }
}
