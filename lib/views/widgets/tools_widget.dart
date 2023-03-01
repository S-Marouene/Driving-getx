import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../main/utils/AppConstant.dart';
import '../../main/utils/SDColors.dart';

DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

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
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    });
  }
}

Future<void> selectTime(
    BuildContext context, StateSetter setModalState, controller) async {
  final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return CustomTheme(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      });

  if (picked != null) {
    setModalState(() {
      selectedTime = picked;
      controller.text =
          "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"}:${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period != DayPeriod.am ? 'PM' : 'AM'}   ";
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
        labelText: hintText,
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

Padding editNumericStyle(var hintText, var namefield) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: TextFormField(
      controller: namefield,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16, fontFamily: fontRegular),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 16),
        hintText: hintText,
        hintStyle: primaryTextStyle(
            color: appStore.isDarkModeOn ? white.withOpacity(0.5) : grey),
        filled: true,
        labelText: hintText,
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

Widget CondOption(var mHeading, var mSubHeading) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(mHeading,
          style: primaryTextStyle(size: 15, color: sdTextPrimaryColor)),
      SizedBox(height: 4),
      Text(mSubHeading,
          style: primaryTextStyle(size: 11, color: sdTextSecondaryColor))
    ],
  );
}

Widget scheduleViewBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: <Widget>[
      Image(
          image: ExactAssetImage('images/' + monthName + '.png'),
          fit: BoxFit.cover,
          width: details.bounds.width,
          height: details.bounds.height),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          monthName + ' ' + details.date.year.toString(),
          style: const TextStyle(fontSize: 18),
        ),
      )
    ],
  );
}

String _getMonthDate(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}
