import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class HomeScreen extends GetView {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("test"),
          leading: IconButton(
            onPressed: () => authController.doLogout(),
            icon: const Icon(Icons.exit_to_app),
          ),
        ),
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: const Text("datttttt")),
            );
          },
        ),
      ),
    );
  }
}
