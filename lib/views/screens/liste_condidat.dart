import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/nav-drawer.dart';

class ListeCondidat extends GetView {
  ListeCondidat({Key? key}) : super(key: key);
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste Condidat'),
      ),
      drawer: const NavDrawer(),
      body: const Center(child: Text("Liste Condidat page")),
    );
  }
}
