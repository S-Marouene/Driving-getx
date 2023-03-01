import 'dart:math';

import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/views/widgets/calendarWidgets/appointment_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// ignore: depend_on_referenced_packages
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../widgets/calendarWidgets/sample_view.dart';

class DashboardScreen extends SampleView {
  const DashboardScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends SampleViewState {
  final CalendarController calendarController = CalendarController();
  late _AppointmentDataSource _dataSource;
  final List<Color> _colorCollection = <Color>[];
  final List<String> _colorNames = <String>[];
  final List<String> _timeZoneCollection = <String>[];

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];

  final ScrollController controller = ScrollController();
  late List<DateTime> _visibleDates;
  CalendarView _view = CalendarView.week;

  Appointment? _selectedAppointment;
  bool _isAllDay = false;
  String _subject = '';
  int _selectedColorIndex = 0;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    calendarController.view = _view;
    _dataSource = _AppointmentDataSource(_getRecursiveAppointments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = Theme(
        key: _globalKey,
        data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(secondary: myModel.backgroundColor)),
        child: _getRecurrenceCalendar(calendarController, _dataSource,
            _onViewChanged, scheduleViewBuilder, _onCalendarTapped));

    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: sdPrimaryColor,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            actionsIconTheme: IconThemeData(opacity: 0.0),
            title: Row(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                child: Text("Planning",
                    style: boldTextStyle(
                        color: db6_white, size: 13, fontFamily: fontBold)),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  //Get.toNamed('/all_condidat');
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //Get.toNamed('/add_condidat');
                },
              )
            ]),
            bottom: TabBar(
              onTap: (index) {
                //print(index);
              },
              isScrollable: true,
              labelStyle: boldTextStyle(),
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  child: TabList(title: 'Mois  '),
                ),
                Tab(
                  child: TabList(title: 'Semaine  '),
                ),
                Tab(
                  child: TabList(title: 'Jour '),
                ),
                Tab(
                  child: TabList(title: 'Planning  '),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Row(children: <Widget>[
                Expanded(
                  child: calendarController.view == CalendarView.month &&
                          myModel.isWebFullView &&
                          screenHeight < 800
                      ? Scrollbar(
                          thumbVisibility: true,
                          controller: controller,
                          child: ListView(
                            controller: controller,
                            children: <Widget>[
                              Container(
                                color: myModel.cardThemeColor,
                                height: 600,
                                child: calendar,
                              )
                            ],
                          ))
                      : Container(
                          color: myModel.cardThemeColor, child: calendar),
                ),
              ]),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Semaines',
                      style: TextStyle(
                          color: appStore.textPrimaryColor, fontSize: 24),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Joursss',
                      style: TextStyle(
                          color: appStore.textPrimaryColor, fontSize: 24),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Planing',
                      style: TextStyle(
                          color: appStore.textPrimaryColor, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      return;
    }

    _selectedAppointment = null;

    /// Navigates the calendar to day view,
    /// when we tap on month cells in mobile.
    if (!myModel.isWebFullView &&
        calendarController.view == CalendarView.month) {
      calendarController.view = CalendarView.day;
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.targetElement == CalendarElement.appointment) {
        final dynamic appointment = calendarTapDetails.appointments![0];
        if (appointment is Appointment) {
          _selectedAppointment = appointment;
        }
      }

      final DateTime selectedDate = calendarTapDetails.date!;
      final CalendarElement targetElement = calendarTapDetails.targetElement;

      /// To open the appointment editor for web,
      /// when the screen width is greater than 767.
      if (myModel.isWebFullView && !myModel.isMobileResolution) {
        final bool isAppointmentTapped =
            calendarTapDetails.targetElement == CalendarElement.appointment;
        showDialog<Widget>(
            context: context,
            builder: (BuildContext context) {
              final List<Appointment> appointment = <Appointment>[];
              Appointment? newAppointment;

              /// Creates a new appointment, which is displayed on the tapped
              /// calendar element, when the editor is opened.
              if (_selectedAppointment == null) {
                _isAllDay = calendarTapDetails.targetElement ==
                    CalendarElement.allDayPanel;
                _selectedColorIndex = 0;
                _subject = '';
                final DateTime date = calendarTapDetails.date!;

                newAppointment = Appointment(
                  startTime: date,
                  endTime: date.add(const Duration(hours: 1)),
                  color: _colorCollection[_selectedColorIndex],
                  isAllDay: _isAllDay,
                  subject: _subject == '' ? '(No title)' : _subject,
                );
                appointment.add(newAppointment);

                _dataSource.appointments.add(appointment[0]);

                SchedulerBinding.instance
                    .addPostFrameCallback((Duration duration) {
                  _dataSource.notifyListeners(
                      CalendarDataSourceAction.add, appointment);
                });

                _selectedAppointment = newAppointment;
              }

              return WillPopScope(
                onWillPop: () async {
                  if (newAppointment != null) {
                    /// To remove the created appointment when the pop-up closed
                    /// without saving the appointment.
                    _dataSource.appointments.removeAt(
                        _dataSource.appointments.indexOf(newAppointment));
                    _dataSource.notifyListeners(CalendarDataSourceAction.remove,
                        <Appointment>[newAppointment]);
                  }
                  return true;
                },
                child: Center(
                    child: SizedBox(
                        width: isAppointmentTapped ? 400 : 500,
                        height: isAppointmentTapped
                            ? (_selectedAppointment!.location == null ||
                                    _selectedAppointment!.location!.isEmpty
                                ? 150
                                : 200)
                            : 400,
                        child: Theme(
                            data: myModel.themeData,
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: myModel.cardThemeColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: isAppointmentTapped
                                  ? displayAppointmentDetails(
                                      context,
                                      targetElement,
                                      selectedDate,
                                      myModel,
                                      _selectedAppointment!,
                                      _colorCollection,
                                      _colorNames,
                                      _dataSource,
                                      _timeZoneCollection,
                                      _visibleDates)
                                  : PopUpAppointmentEditor(
                                      myModel,
                                      newAppointment,
                                      appointment,
                                      _dataSource,
                                      _colorCollection,
                                      _colorNames,
                                      _selectedAppointment!,
                                      _timeZoneCollection,
                                      _visibleDates),
                            )))),
              );
            });
      } else {
        /// Navigates to the appointment editor page on mobile
        Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => AppointmentEditor(
                  myModel,
                  _selectedAppointment,
                  targetElement,
                  selectedDate,
                  _colorCollection,
                  _colorNames,
                  _dataSource,
                  _timeZoneCollection)),
        );
      }
    }
  }

  Widget TabList({Widget? icon, required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ?? SizedBox(),
        10.width,
        Text(
          title,
          style: TextStyle(color: appStore.textPrimaryColor),
        ),
      ],
    );
  }

  SfCalendar _getRecurrenceCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      dynamic onViewChanged,
      dynamic scheduleViewBuilder,
      dynamic calendarTapCallback]) {
    return SfCalendar(
      showNavigationArrow: myModel.isWebFullView,
      controller: calendarController,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showDatePickerButton: true,
      onViewChanged: onViewChanged,
      dataSource: calendarDataSource,
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      onTap: calendarTapCallback,
    );
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    _visibleDates = visibleDatesChangedDetails.visibleDates;
    if (_view == calendarController.view ||
        !myModel.isWebFullView ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _view = calendarController.view!;

        /// Update the current view when the calendar view changed to
        /// month view or from month view.
      });
    });
  }

  List<Appointment> _getRecursiveAppointments() {
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('Argentina Standard Time');
    _timeZoneCollection.add('Atlantic Standard Time');
    _timeZoneCollection.add('Azerbaijan Standard Time');
    _timeZoneCollection.add('Azores Standard Time');
    _timeZoneCollection.add('Bahia Standard Time');
    _timeZoneCollection.add('Bangladesh Standard Time');
    _timeZoneCollection.add('Belarus Standard Time');
    _timeZoneCollection.add('Canada Central Standard Time');
    _timeZoneCollection.add('Cape Verde Standard Time');
    _timeZoneCollection.add('Caucasus Standard Time');
    _timeZoneCollection.add('Cen. Australia Standard Time');
    _timeZoneCollection.add('Central America Standard Time');
    _timeZoneCollection.add('Central Asia Standard Time');
    _timeZoneCollection.add('Central Brazilian Standard Time');
    _timeZoneCollection.add('Central Europe Standard Time');
    _timeZoneCollection.add('Central European Standard Time');
    _timeZoneCollection.add('Central Pacific Standard Time');
    _timeZoneCollection.add('Central Standard Time');
    _timeZoneCollection.add('China Standard Time');
    _timeZoneCollection.add('Dateline Standard Time');
    _timeZoneCollection.add('E. Africa Standard Time');
    _timeZoneCollection.add('E. Australia Standard Time');
    _timeZoneCollection.add('E. South America Standard Time');
    _timeZoneCollection.add('Eastern Standard Time');
    _timeZoneCollection.add('Egypt Standard Time');
    _timeZoneCollection.add('Ekaterinburg Standard Time');
    _timeZoneCollection.add('FLE Standard Time');
    _timeZoneCollection.add('Fiji Standard Time');
    _timeZoneCollection.add('GMT Standard Time');
    _timeZoneCollection.add('GTB Standard Time');
    _timeZoneCollection.add('Georgian Standard Time');
    _timeZoneCollection.add('Greenland Standard Time');
    _timeZoneCollection.add('Greenwich Standard Time');
    _timeZoneCollection.add('Hawaiian Standard Time');
    _timeZoneCollection.add('India Standard Time');
    _timeZoneCollection.add('Iran Standard Time');
    _timeZoneCollection.add('Israel Standard Time');
    _timeZoneCollection.add('Jordan Standard Time');
    _timeZoneCollection.add('Kaliningrad Standard Time');
    _timeZoneCollection.add('Korea Standard Time');
    _timeZoneCollection.add('Libya Standard Time');
    _timeZoneCollection.add('Line Islands Standard Time');
    _timeZoneCollection.add('Magadan Standard Time');
    _timeZoneCollection.add('Mauritius Standard Time');
    _timeZoneCollection.add('Middle East Standard Time');
    _timeZoneCollection.add('Montevideo Standard Time');
    _timeZoneCollection.add('Morocco Standard Time');
    _timeZoneCollection.add('Mountain Standard Time');
    _timeZoneCollection.add('Mountain Standard Time (Mexico)');
    _timeZoneCollection.add('Myanmar Standard Time');
    _timeZoneCollection.add('N. Central Asia Standard Time');
    _timeZoneCollection.add('Namibia Standard Time');
    _timeZoneCollection.add('Nepal Standard Time');
    _timeZoneCollection.add('New Zealand Standard Time');
    _timeZoneCollection.add('Newfoundland Standard Time');
    _timeZoneCollection.add('North Asia East Standard Time');
    _timeZoneCollection.add('North Asia Standard Time');
    _timeZoneCollection.add('Pacific SA Standard Time');
    _timeZoneCollection.add('Pacific Standard Time');
    _timeZoneCollection.add('Pacific Standard Time (Mexico)');
    _timeZoneCollection.add('Pakistan Standard Time');
    _timeZoneCollection.add('Paraguay Standard Time');
    _timeZoneCollection.add('Romance Standard Time');
    _timeZoneCollection.add('Russia Time Zone 10');
    _timeZoneCollection.add('Russia Time Zone 11');
    _timeZoneCollection.add('Russia Time Zone 3');
    _timeZoneCollection.add('Russian Standard Time');
    _timeZoneCollection.add('SA Eastern Standard Time');
    _timeZoneCollection.add('SA Pacific Standard Time');
    _timeZoneCollection.add('SA Western Standard Time');
    _timeZoneCollection.add('SE Asia Standard Time');
    _timeZoneCollection.add('Samoa Standard Time');
    _timeZoneCollection.add('Singapore Standard Time');
    _timeZoneCollection.add('South Africa Standard Time');
    _timeZoneCollection.add('Sri Lanka Standard Time');
    _timeZoneCollection.add('Syria Standard Time');
    _timeZoneCollection.add('Taipei Standard Time');
    _timeZoneCollection.add('Tasmania Standard Time');
    _timeZoneCollection.add('Tokyo Standard Time');
    _timeZoneCollection.add('Tonga Standard Time');
    _timeZoneCollection.add('Turkey Standard Time');
    _timeZoneCollection.add('US Eastern Standard Time');
    _timeZoneCollection.add('US Mountain Standard Time');
    _timeZoneCollection.add('UTC');
    _timeZoneCollection.add('UTC+12');
    _timeZoneCollection.add('UTC-02');
    _timeZoneCollection.add('UTC-11');
    _timeZoneCollection.add('Ulaanbaatar Standard Time');
    _timeZoneCollection.add('Venezuela Standard Time');
    _timeZoneCollection.add('Vladivostok Standard Time');
    _timeZoneCollection.add('W. Australia Standard Time');
    _timeZoneCollection.add('W. Central Africa Standard Time');
    _timeZoneCollection.add('W. Europe Standard Time');
    _timeZoneCollection.add('West Asia Standard Time');
    _timeZoneCollection.add('West Pacific Standard Time');
    _timeZoneCollection.add('Yakutsk Standard Time');

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    final List<Appointment> appointments = <Appointment>[];
    final Random random = Random();
    //Recurrence Appointment 1
    final DateTime currentDate = DateTime.now();
    final DateTime startTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 9);
    final DateTime endTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 11);
    final RecurrenceProperties recurrencePropertiesForAlternativeDay =
        RecurrenceProperties(
            startDate: startTime,
            interval: 2,
            recurrenceRange: RecurrenceRange.count,
            recurrenceCount: 20);
    final Appointment alternativeDayAppointment = Appointment(
        startTime: startTime,
        endTime: endTime,
        color: _colorCollection[random.nextInt(8)],
        subject: 'maro maro',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForAlternativeDay, startTime, endTime));

    appointments.add(alternativeDayAppointment);

    //Recurrence Appointment 2
    final DateTime startTime1 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 13);
    final DateTime endTime1 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 15);
    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties(
      startDate: startTime1,
      recurrenceType: RecurrenceType.weekly,
      recurrenceRange: RecurrenceRange.count,
      weekDays: <WeekDays>[WeekDays.monday],
      recurrenceCount: 20,
    );

    final Appointment weeklyAppointment = Appointment(
        startTime: startTime1,
        endTime: endTime1,
        color: _colorCollection[random.nextInt(8)],
        subject: 'product development status',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForWeeklyAppointment, startTime1, endTime1));

    appointments.add(weeklyAppointment);

    final DateTime startTime2 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 14);
    final DateTime endTime2 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 15);
    final RecurrenceProperties recurrencePropertiesForMonthlyAppointment =
        RecurrenceProperties(
            startDate: startTime2,
            recurrenceType: RecurrenceType.monthly,
            recurrenceRange: RecurrenceRange.count,
            recurrenceCount: 10);

    final Appointment monthlyAppointment = Appointment(
        startTime: startTime2,
        endTime: endTime2,
        color: _colorCollection[random.nextInt(8)],
        subject: 'Test maro',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForMonthlyAppointment, startTime2, endTime2));

    appointments.add(monthlyAppointment);

    final DateTime startTime3 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 12);
    final DateTime endTime3 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 14);
    final RecurrenceProperties recurrencePropertiesForYearlyAppointment =
        RecurrenceProperties(
            startDate: startTime3,
            recurrenceType: RecurrenceType.yearly,
            dayOfMonth: 5);

    final Appointment yearlyAppointment = Appointment(
        startTime: startTime3,
        endTime: endTime3,
        color: _colorCollection[random.nextInt(8)],
        isAllDay: true,
        subject: 'Stephen birthday',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForYearlyAppointment, startTime3, endTime3));

    appointments.add(yearlyAppointment);

    final DateTime startTime4 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 17);
    final DateTime endTime4 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 18);
    final RecurrenceProperties recurrencePropertiesForCustomDailyAppointment =
        RecurrenceProperties(startDate: startTime4);

    final Appointment customDailyAppointment = Appointment(
      startTime: startTime4,
      endTime: endTime4,
      color: _colorCollection[random.nextInt(8)],
      subject: 'General meeting',
      recurrenceRule: SfCalendar.generateRRule(
          recurrencePropertiesForCustomDailyAppointment, startTime4, endTime4),
    );

    appointments.add(customDailyAppointment);

    final DateTime startTime5 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 12);
    final DateTime endTime5 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 13);
    final RecurrenceProperties recurrencePropertiesForCustomWeeklyAppointment =
        RecurrenceProperties(
            startDate: startTime5,
            recurrenceType: RecurrenceType.weekly,
            recurrenceRange: RecurrenceRange.endDate,
            weekDays: <WeekDays>[WeekDays.monday, WeekDays.friday],
            endDate: DateTime.now().add(const Duration(days: 14)));

    final Appointment customWeeklyAppointment = Appointment(
        startTime: startTime5,
        endTime: endTime5,
        color: _colorCollection[random.nextInt(8)],
        subject: 'performance check',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForCustomWeeklyAppointment,
            startTime5,
            endTime5));

    appointments.add(customWeeklyAppointment);

    final DateTime startTime6 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 16);
    final DateTime endTime6 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 18);

    final RecurrenceProperties recurrencePropertiesForCustomMonthlyAppointment =
        RecurrenceProperties(
            startDate: startTime6,
            recurrenceType: RecurrenceType.monthly,
            recurrenceRange: RecurrenceRange.count,
            dayOfWeek: DateTime.friday,
            week: 4,
            recurrenceCount: 12);

    final Appointment customMonthlyAppointment = Appointment(
        startTime: startTime6,
        endTime: endTime6,
        color: _colorCollection[random.nextInt(8)],
        subject: 'Sprint end meeting',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForCustomMonthlyAppointment,
            startTime6,
            endTime6));

    appointments.add(customMonthlyAppointment);

    final DateTime startTime7 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 14);
    final DateTime endTime7 =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 15);
    final RecurrenceProperties recurrencePropertiesForCustomYearlyAppointment =
        RecurrenceProperties(
            startDate: startTime7,
            recurrenceType: RecurrenceType.yearly,
            recurrenceRange: RecurrenceRange.count,
            interval: 2,
            month: DateTime.february,
            week: 2,
            dayOfWeek: DateTime.sunday,
            recurrenceCount: 10);

    final Appointment customYearlyAppointment = Appointment(
        startTime: startTime7,
        endTime: endTime7,
        color: _colorCollection[random.nextInt(8)],
        subject: 'Alumini meet',
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForCustomYearlyAppointment,
            startTime7,
            endTime7));

    appointments.add(customYearlyAppointment);
    return appointments;
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(this.source);
  List<Appointment> source;
  @override
  List<dynamic> get appointments => source;
}

/// Returns the builder for schedule view.
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
