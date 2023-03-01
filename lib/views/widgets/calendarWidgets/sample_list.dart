import 'package:driving_getx/views/screens/dashboard_screen.dart';
import 'package:flutter/foundation.dart';

Map<String, Function> getSampleWidget() {
  return <String, Function>{
    'recurrence_calendar': (Key key) => DashboardScreen(),
  };
}
