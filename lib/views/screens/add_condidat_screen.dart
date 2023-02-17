import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main/utils/AppConstant.dart';

class AddCondidat extends StatefulWidget {
  static String tag = "/AddCondidat";

  const AddCondidat({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCondidatState createState() => _AddCondidatState();
}

class _AddCondidatState extends State<AddCondidat> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: SizedBox(
          height: 55,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 22, 0, 0),
            child: Text("Ajout condidat",
                style: boldTextStyle(
                    color: db6_white, size: 15, fontFamily: fontBold)),
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.verified_user_outlined, color: Colors.white)),
        ],
        backgroundColor: sdPrimaryColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 16,
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  labelText: 'Username',
                  labelStyle: primaryTextStyle(size: 14),
                  filled: true,
                ),
                cursorColor: appStore.isDarkModeOn ? white : blackColor,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              TextField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  labelText: "E-Mail",
                  labelStyle: primaryTextStyle(size: 14),
                  prefixIcon: Icon(
                    Icons.email,
                    color: appStore.iconColor,
                  ),
                  filled: true,
                ),
                cursorColor: appStore.isDarkModeOn ? white : blackColor,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              TextField(
                style: primaryTextStyle(),
                obscureText: passwordVisible,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: primaryTextStyle(size: 14),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: appStore.iconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )),
                cursorColor: appStore.isDarkModeOn ? white : blackColor,
              ),
              TextField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  labelText: "Phone Number",
                  labelStyle: primaryTextStyle(size: 14),
                  prefixIcon: Icon(Icons.phone, color: Colors.blue),
                  filled: true,
                ),
                cursorColor: appStore.isDarkModeOn ? white : blackColor,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              TextField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)),
                  labelText: "Pincode",
                  labelStyle: primaryTextStyle(size: 14),
                  filled: true,
                  counterStyle: secondaryTextStyle(),
                ),
                maxLength: 6,
                cursorColor: appStore.isDarkModeOn ? white : blackColor,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
