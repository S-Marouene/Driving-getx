// ignore_for_file: depend_on_referenced_packages

import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SDSettingScreen extends StatefulWidget {
  const SDSettingScreen({super.key});

  @override
  SDSettingScreenState createState() => SDSettingScreenState();
}

class SDSettingScreenState extends State<SDSettingScreen> {
  AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    changeStatusColor(sdAppBackground);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              finish(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Text('Settings', style: boldTextStyle(size: 20)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            mOption(Icons.language, "Preferences", () {
              DoNothingAction();
            }),
            mDivider(),
            mOption(Icons.lock_outline, "Privacy and Security", () {
              DoNothingAction();
            }),
            mDivider(),
            mOption(Icons.notifications_none, "Notification Settings", () {
              DoNothingAction();
            }),
            mDivider(),
            mOption(Icons.launch, "Logout", () {
              authController.doLogout();
            }),
            mDivider(),
            mAbout()
          ],
        ),
      ),
    );
  }

  Widget mAbout() {
    return const AboutListTile(
      icon: Icon(
        Icons.info,
      ),
      applicationIcon: Icon(
        Icons.local_play,
      ),
      applicationName: 'Driving app',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2022 Sm-Dev Company',
      aboutBoxChildren: [
        ///Content goes here...
      ],
      child: Text('About app'),
    );
  }

  Widget mOption(var icon, var heading, Function doSomthing) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: sdIconColor, size: 18),
              SizedBox(width: 16),
              Text(heading,
                  style: primaryTextStyle(size: 16, color: sdTextPrimaryColor)),
            ],
          ),
          Icon(Icons.keyboard_arrow_right, color: sdIconColor),
        ],
      ),
    ).onTap(doSomthing);
  }

  Widget mDivider() {
    return Container(color: sdViewColor, height: 1);
  }
}
