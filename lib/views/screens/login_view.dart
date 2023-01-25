// ignore_for_file: depend_on_referenced_packages

import 'package:driving_getx/logic/controllers/login_controller.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main/utils/SDStyle.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: sdAppBackground,
      body: Center(
        child: Form(
          key: controller.loginformKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Easy to learn \nanywhere and anytime',
                      style: boldTextStyle(size: 25)),
                  SizedBox(height: 25),
                  Text('Sign in to your account',
                      style: secondaryTextStyle(size: 16)),
                  SizedBox(height: 25),
                  Container(
                    width: size.width,
                    decoration: boxDecorations(showShadow: true),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: controller.emailController,
                          validator: (v) {
                            return null;
                          },
                          onSaved: (v) {},
                          cursorColor: sdTextSecondaryColor.withOpacity(0.2),
                          cursorWidth: 1,
                          autocorrect: true,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Username or Mobile number',
                            prefixIcon: const Icon(Icons.email),
                            hintStyle: secondaryTextStyle(
                                color: sdTextSecondaryColor.withOpacity(0.6)),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 16, bottom: 16, top: 16, right: 16),
                          ),
                        ),
                        Divider(height: 1, thickness: 1),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: controller.passwordController,
                                validator: (v) {
                                  return null;
                                },
                                onSaved: (v) {},
                                obscureText: true,
                                cursorColor:
                                    sdTextSecondaryColor.withOpacity(0.2),
                                cursorWidth: 1,
                                decoration: InputDecoration(
                                  hintText: 'Mot de pass',
                                  prefixIcon: const Icon(Icons.password),
                                  hintStyle: secondaryTextStyle(
                                      color: sdTextSecondaryColor
                                          .withOpacity(0.6)),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 16, bottom: 16, top: 16, right: 16),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //SDForgotPwdScreen().launch(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text('Forgot?',
                                    style: boldTextStyle(
                                        size: 14, color: sdPrimaryColor)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 45),
                  Obx(() => controller.isLoading.value == true
                      ? const Center(child: CircularProgressIndicator())
                      : const Text("")),
                  SDButton(
                    textContent: "Se connecter",
                    onPressed: () {
                      controller.doLogin();
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      /*  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
              child: Form(
            key: controller.loginformKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller.emailController,
                  validator: (v) {
                    return null;
                  },
                  onSaved: (v) {},
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "email",
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: controller.passwordController,
                  validator: (v) {
                    return null;
                  },
                  onSaved: (v) {},
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "password",
                    prefixIcon: const Icon(Icons.password),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => controller.isLoading.value == true
                    ? const Center(child: CircularProgressIndicator())
                    : const Text("")),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      controller.doLogin();
                    },
                    child: const Text("Login"))
              ],
            ),
          )),
        ),
      ), */

      persistentFooterButtons: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).copyWith().size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {},
                child: Text('REGISTER'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
