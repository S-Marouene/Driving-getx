import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double expandHeight = 200;

    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: expandHeight,
            floating: true,
            automaticallyImplyLeading: false,
            forceElevated: innerBoxIsScrolled,
            pinned: true,
            titleSpacing: 0,
            backgroundColor:
                innerBoxIsScrolled ? db6_colorPrimary : db6_colorPrimary,
            actionsIconTheme: IconThemeData(opacity: 0.0),
            /* leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  //finish(context);
                }), */
            title: SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: Text("Hello,Maro",
                    style: boldTextStyle(
                        color: db6_white, size: 24, fontFamily: fontBold)),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: 200,
                margin: EdgeInsets.only(top: 70),
                color: db6_colorPrimary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.location_on,
                                        color: db6_white, size: 16),
                                  ),
                                ),
                                TextSpan(
                                    text: "Tunis",
                                    style: primaryTextStyle(
                                        size: 18, color: db6_white)),
                              ],
                            ),
                          ),
                          Text("Change",
                              style:
                                  primaryTextStyle(color: db6_white, size: 18)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: white),
                        alignment: Alignment.center,
                        child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              fillColor: db6_white,
                              hintText: "Recherche",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.only(
                                  left: 26.0,
                                  bottom: 8.0,
                                  top: 8.0,
                                  right: 50.0),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ];
      },
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(_getDataSource()),
        // by default the month appointment display mode set as Indicator, we can
        // change the display mode as appointment using the appointment display
        // mode property
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      ),
    ));
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
