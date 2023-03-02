import 'dart:math';
import 'package:driving_getx/database/models/conduite.dart';
import 'package:driving_getx/database/models/examens.dart';
import 'package:driving_getx/logic/controllers/conduite_controller.dart';
import 'package:driving_getx/logic/controllers/examen_controller.dart';
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

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];

  final ScrollController controller = ScrollController();
  CalendarView _view = CalendarView.schedule;
  Appointment? _selectedAppointment;
  final GlobalKey _globalKey = GlobalKey();

  final ConduiteController conduite_controller = Get.put(ConduiteController());
  late List<Conduite> Allconduite = [];

  final ExamenController examens_controller = Get.put(ExamenController());
  late List<Examen> Allexamen = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conduite_controller.getAllConduite();
      await examens_controller.getallExmCalndr();

      setState(() {});
    });

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
                child: Text("Planification", style: boldTextStyle(color: db6_white, size: 13, fontFamily: fontBold)),
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
                Allexamen = examens_controller.ListExamClrd.value;
                _dataSource = _AppointmentDataSource(_getRecursiveAppointments(Allconduite, Allexamen));
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
        data: Theme.of(context)
            .copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(secondary: myModel.backgroundColor)),
        child: _getRecurrenceCalendar(
            calendarController, _dataSource, _onViewChanged, scheduleViewBuilder, _onCalendarTapped));
    return calendarController.view == CalendarView.month && myModel.isWebFullView && screenHeight < 800
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
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      return;
    }
    _selectedAppointment = null;

    if (!myModel.isWebFullView && calendarController.view == CalendarView.month) {
      calendarController.view = CalendarView.day;
    } else {
      if (calendarTapDetails.appointments != null && calendarTapDetails.targetElement == CalendarElement.appointment) {
        final dynamic appointment = calendarTapDetails.appointments![0];
        if (appointment is Appointment) {
          _selectedAppointment = appointment;
        }
      }

      final DateTime selectedDate = calendarTapDetails.date!;
      final CalendarElement targetElement = calendarTapDetails.targetElement;

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
                )),
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
      monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      onTap: calendarTapCallback,
    );
  }

  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == calendarController.view ||
        !myModel.isWebFullView ||
        (_view != CalendarView.month && calendarController.view != CalendarView.month)) {
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        _view = calendarController.view!;
      });
    });
  }

  List<Appointment> _getRecursiveAppointments(Allconduite, Allexamen) {
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Light Green');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

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

    Allexamen.forEach((subject) {
      final Appointment alternativeDayAppointment0 = Appointment(
        startTime: DateTime.parse(subject.dateExamen),
        endTime: DateTime.parse(subject.dateExamen).add(const Duration(hours: 2)),
        color: _colorCollection[1],
        subject: subject.condidat.nom + " " + subject.condidat.prenom + " Exam Conduite",
        photo: subject.condidat.photo,
      );

      appointments.add(alternativeDayAppointment0);
    });

    Allconduite.forEach((subject) {
      final Appointment alternativeDayAppointment0 = Appointment(
        startTime: DateTime.parse(subject.date_deb),
        endTime: DateTime.parse(subject.date_fin),
        color: _colorCollection[random.nextInt(8)],
        subject: subject.condidat.nom + " " + subject.condidat.prenom,
        //photo: subject.condidat.photo,
      );

      appointments.add(alternativeDayAppointment0);
    });

    return appointments;
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(this.source);
  List<Appointment> source;
  @override
  List<dynamic> get appointments => source;
}
