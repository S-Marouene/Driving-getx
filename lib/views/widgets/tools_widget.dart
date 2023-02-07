import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main/utils/AppConstant.dart';
import '../../main/utils/SDColors.dart';

DateTime selectedDate = DateTime.now();

Future<void> selectDate(
    BuildContext context, StateSetter setModalState, controller) async {
  final DateTime? picked = await showDatePicker(
      helpText: 'Selectionner la date',
      cancelText: 'Annuler',
      confirmText: "Ok",
      fieldLabelText: 'Booking Date',
      fieldHintText: 'Month/Date/Year',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      context: context,
      builder: (BuildContext context, Widget? child) {
        return CustomTheme(
          child: child,
        );
      },
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  if (picked != null && picked != selectedDate) {
    setModalState(() {
      selectedDate = picked;
      controller.datePayementAdd.text =
          DateFormat('yyyy-MM-dd').format(selectedDate);
    });
  }
}

Padding editTextStyle(var hintText, var namefield) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: TextFormField(
      controller: namefield,
      style: TextStyle(fontSize: 16, fontFamily: fontRegular),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 16),
        hintText: hintText,
        hintStyle: primaryTextStyle(
            color: appStore.isDarkModeOn ? white.withOpacity(0.5) : grey),
        filled: true,
        fillColor: appStore.appBarColor,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: kPrimaryColor, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: kSecondaryColor, width: 1.0)),
      ),
    ),
  );
}

Widget showLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: sdPrimaryColor,
    ),
  );
}
