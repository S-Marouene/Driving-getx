// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

BoxDecoration boxDecorations(
    {double radius = 8,
    Color color = Colors.transparent,
    Color bgColor = Colors.white,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: sdShadowColor, blurRadius: 10, spreadRadius: 2)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

BoxDecoration boxDecoration(
    {double radius = 80.0,
    Color backGroundColor = sdPrimaryColor,
    double blurRadius = 8.0,
    double spreadRadius = 8.0,
    Color radiusColor = Colors.black12,
    Gradient? gradient}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: radiusColor,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ],
    color: backGroundColor,
    gradient: gradient,
  );
}

class SDButton extends StatefulWidget {
  static String tag = '/T4Button';
  var textContent;
  VoidCallback onPressed;
  var isStroked = false;
  var height = 40.0;

  SDButton(
      {Key? key,
      required this.textContent,
      required this.onPressed,
      this.isStroked = false,
      this.height = 45.0})
      : super(key: key);

  @override
  SDButtonState createState() => SDButtonState();
}

class SDButtonState extends State<SDButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        alignment: Alignment.center,
        decoration: widget.isStroked
            ? boxDecorations(bgColor: Colors.transparent, color: sdPrimaryColor)
            : boxDecorations(bgColor: sdPrimaryColor, radius: 6),
        child: Text(
          widget.textContent,
          textAlign: TextAlign.center,
          style: boldTextStyle(size: 16, color: Colors.white, letterSpacing: 2),
        ),
      ),
    );
  }
}
