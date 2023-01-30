import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/AppWidget.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MWTabBarScreen4 extends StatefulWidget {
  static String tag = "/MWTabBarScreen4";

  const MWTabBarScreen4({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MWTabBarScreen4State createState() => _MWTabBarScreen4State();
}

class _MWTabBarScreen4State extends State<MWTabBarScreen4> {
  @override
  void initState() {
    super.initState();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: db6_colorPrimary,
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: Text("Hello,Maro 2",
                    style: boldTextStyle(
                        color: db6_white, size: 24, fontFamily: fontBold)),
              ),
            ),
            bottom: TabBar(
              onTap: (index) {
                print(index);
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
                  child: TabList(title: 'Années '),
                ),
                Tab(
                  child: TabList(title: 'Autres  '),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SfCalendar(
                      view: CalendarView.month,
                      dataSource: MeetingDataSource(_getDataSource()),
                      // by default the month appointment display mode set as Indicator, we can
                      // change the display mode as appointment using the appointment display
                      // mode property
                      monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment),
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
                      'MarketPlace',
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
                      'Group',
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
                      'Watch',
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

  // ignore: non_constant_identifier_names
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

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Code', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting('Conduite', startTime, endTime,
        Color.fromARGB(255, 46, 59, 170), false));
    meetings.add(Meeting(
        'other', startTime, endTime, Color.fromARGB(255, 199, 79, 153), false));

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
