import 'dart:math';
import 'package:driving_getx/database/models/conduite.dart';
import 'package:driving_getx/logic/controllers/conduite_controller.dart';
import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/views/widgets/calendarWidgets/appointment_editor.dart';
import 'package:driving_getx/views/widgets/tools_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
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
  CalendarView _view = CalendarView.week;

  Appointment? _selectedAppointment;
  final GlobalKey _globalKey = GlobalKey();

  //final AuthController authController = Get.put(AuthController());
  final ConduiteController conduite_controller = Get.put(ConduiteController());
  late List<Conduite> Allconduite = [];
  List<String> listOfCategory = [];

  @override
  void initState() {
    conduite_controller.getAllConduite();
    calendarController.view = _view;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: sdPrimaryColor,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 60,
            actionsIconTheme: IconThemeData(opacity: 0.0),
            title: Row(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Icon(
                    Icons.calendar_month,
                    size: 18,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text("Planification",
                    style: boldTextStyle(
                        color: db6_white, size: 13, fontFamily: fontBold)),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //Get.toNamed('/add_condidat');
                },
              )
            ]),
          ),
          body: Row(children: <Widget>[
            Expanded(
                child: conduite_controller.obx(
              (state) {
                Allconduite = conduite_controller.listeConduite.value;

                _dataSource = _AppointmentDataSource(
                    _getRecursiveAppointments(Allconduite));

                return BuildCalendar(Allconduite);
              },
              onLoading: showLoadingIndicator(),
            )),
          ]),
        ),
      ),
    );
  }

  Widget BuildCalendar(Allconduite) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final Widget calendar = Theme(
        key: _globalKey,
        data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(secondary: myModel.backgroundColor)),
        child: _getRecurrenceCalendar(calendarController, _dataSource,
            _onViewChanged, scheduleViewBuilder, _onCalendarTapped));
    return calendarController.view == CalendarView.month &&
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
        : Container(color: myModel.cardThemeColor, child: calendar);
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

  List<Appointment> _getRecursiveAppointments(Allconduite) {
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
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('E. Africa Standard Time');
    _timeZoneCollection.add('UTC-11');

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

    Allconduite.forEach((subject) {
      final Appointment alternativeDayAppointment0 = Appointment(
        startTime: DateTime.parse(subject.date_deb),
        endTime: DateTime.parse(subject.date_fin),
        color: _colorCollection[random.nextInt(8)],
        subject: subject.condidat.nom + " " + subject.condidat.prenom,
      );

      appointments.add(alternativeDayAppointment0);
    });

    /* final DateTime currentDate0 = DateTime.now();
    final DateTime startTime0 =
        DateTime(currentDate0.year, currentDate0.month, currentDate0.day, 9);
    final DateTime endTime0 =
        DateTime(currentDate0.year, currentDate0.month, currentDate0.day, 11);
    final RecurrenceProperties recurrencePropertiesForAlternativeDay0 =
        RecurrenceProperties(
            startDate: startTime0,
            interval: 1,
            recurrenceRange: RecurrenceRange.count,
            recurrenceCount: 1);
    final Appointment alternativeDayAppointment0 = Appointment(
        startTime: startTime0,
        endTime: endTime0,
        color: _colorCollection[random.nextInt(8)],
        subject: "aaaaaa",
        recurrenceRule: SfCalendar.generateRRule(
            recurrencePropertiesForAlternativeDay0, startTime0, endTime0));

    appointments.add(alternativeDayAppointment0); */

    //Recurrence Appointment 1
    /* final DateTime currentDate = DateTime.now();
    final DateTime startTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 9);
    final DateTime endTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day, 11);
    final RecurrenceProperties recurrencePropertiesForAlternativeDay =
        RecurrenceProperties(
            startDate: startTime,
            interval: 2,
            recurrenceRange: RecurrenceRange.count,
            recurrenceCount: 3);
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

    appointments.add(customYearlyAppointment); */

    return appointments;
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(this.source);
  List<Appointment> source;
  @override
  List<dynamic> get appointments => source;
}
