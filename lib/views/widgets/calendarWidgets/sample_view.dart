import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'model.dart';

abstract class SampleView extends StatefulWidget {
  const SampleView({Key? key}) : super(key: key);
}

abstract class SampleViewState<T extends SampleView> extends State<T> {
  late SampleModel myModel;
  late bool isCardView;
  @override
  void initState() {
    myModel = SampleModel.instance;
    isCardView = myModel.isCardView && !myModel.isWebFullView;
    super.initState();
  }

  @override
  void dispose() {
    myModel.isCardView = true;
    super.dispose();
  }

  Widget? buildSettings(BuildContext context) {
    return null;
  }
}

class LocalizationSampleView extends SampleView {
  const LocalizationSampleView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LocalizationSampleViewState();
}

/// Base class of the localization sample's state class
class LocalizationSampleViewState<T extends LocalizationSampleView>
    extends SampleViewState<T> {
  late List<Locale> _supportedLocales;

  @override
  void initState() {
    if (this is! DirectionalitySampleViewState) {
      _supportedLocales = <Locale>[
        const Locale('ar', 'AE'),
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
        const Locale('fr', 'FR'),
        const Locale('zh', 'CN')
      ];
    } else {
      _supportedLocales = <Locale>[
        const Locale('ar', 'AE'),
        const Locale('en', 'US'),
      ];
    }

    super.initState();
  }

  /// Add the localization selection widget.
  Widget localizationSelectorWidget(BuildContext context) {
    final double screenWidth =
        myModel.isWebFullView ? 250 : MediaQuery.of(context).size.width;
    final double dropDownWidth = 0.6 * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text(this is DirectionalitySampleViewState ? 'Language' : 'Locale',
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
                color: myModel.textColor,
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              width: dropDownWidth,
              child: DropdownButton<Locale>(
                  focusColor: Colors.transparent,
                  isExpanded: true,
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: myModel.locale,
                  items: _supportedLocales.map((Locale value) {
                    String localeString = value.toString();
                    if (this is DirectionalitySampleViewState) {
                      localeString =
                          (localeString == 'ar_AE') ? 'Arabic' : 'English';
                    } else {
                      localeString = localeString.substring(0, 2) +
                          '-' +
                          localeString.substring(3, 5);
                    }

                    return DropdownMenuItem<Locale>(
                        value: value,
                        child: Text(localeString,
                            style: TextStyle(color: myModel.textColor)));
                  }).toList(),
                  onChanged: (Locale? value) {
                    if (myModel.locale != value) {
                      setState(() {
                        stateSetter(() {
                          myModel.isInitialRender = false;
                          myModel.locale = value;
                          if (this is! DirectionalitySampleViewState) {
                            if (myModel.locale == const Locale('ar', 'AE')) {
                              myModel.textDirection = TextDirection.rtl;
                            } else {
                              myModel.textDirection = TextDirection.ltr;
                            }
                          }
                        });
                      });
                    }
                  })),
        ],
      );
    });
  }

  Widget _buildDirectionalityWidget() {
    return Localizations(
        locale: myModel.locale!,
        delegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          SfGlobalLocalizations.delegate
        ],
        child: Directionality(
            textDirection: myModel.textDirection,
            child: buildSample(context) ?? Container()));
  }

  /// Method to get the widget's color based on the widget state
  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return myModel.backgroundColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDirectionalityWidget();
  }

  /// Get the settings panel content.
  Widget? buildSample(BuildContext context) {
    return null;
  }

  /// Must call super.
  @override
  void dispose() {
    super.dispose();
  }
}

/// Base class of the directionality sample's stateful widget class
class DirectionalitySampleView extends LocalizationSampleView {
  /// base class constructor of sample's stateful widget class
  const DirectionalitySampleView({Key? key}) : super(key: key);
}

/// Base class of the directionality sample's state class
class DirectionalitySampleViewState<T extends DirectionalitySampleView>
    extends LocalizationSampleViewState<T> {
  final List<TextDirection> _supportedTextDirection = <TextDirection>[
    TextDirection.ltr,
    TextDirection.rtl,
  ];

  /// Must call super.
  @override
  void dispose() {
    super.dispose();
  }

  /// Close all overlay when property panel is opened. Implemented for PdfViewer
  /// RTL sample.
  void closeAllOverlay() {}

  /// Add the localization selection widget.
  Widget textDirectionSelectorWidget(BuildContext context) {
    final double screenWidth =
        myModel.isWebFullView ? 250 : MediaQuery.of(context).size.width;
    closeAllOverlay();
    final double dropDownWidth = 0.6 * screenWidth;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
        children: <Widget>[
          Text('Rendering\nDirection',
              maxLines: 2,
              textAlign: TextAlign.left,
              softWrap: false,
              style: TextStyle(
                fontSize: 16,
                color: myModel.textColor,
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              width: dropDownWidth,
              child: DropdownButton<TextDirection>(
                  focusColor: Colors.transparent,
                  isExpanded: true,
                  underline:
                      Container(color: const Color(0xFFBDBDBD), height: 1),
                  value: myModel.textDirection,
                  items: _supportedTextDirection.map((TextDirection value) {
                    return DropdownMenuItem<TextDirection>(
                        value: value,
                        child: Text(
                            value.toString().split('.')[1].toUpperCase(),
                            style: TextStyle(color: myModel.textColor)));
                  }).toList(),
                  onChanged: (TextDirection? value) {
                    if (myModel.textDirection != value) {
                      setState(() {
                        stateSetter(() {
                          myModel.isInitialRender = false;
                          myModel.textDirection = value!;
                        });
                      });
                    }
                  })),
        ],
      );
    });
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}
