import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'model.dart';

class AppointmentEditor extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AppointmentEditor(this.model, this.selectedAppointment, this.targetElement, this.selectedDate, this.colorCollection, this.colorNames,
      this.events, this.timeZoneCollection,
      [this.selectedResource]);

  /// Current sample model
  final SampleModel model;

  /// Selected appointment
  final Appointment? selectedAppointment;

  /// Calendar element
  final CalendarElement targetElement;

  /// Seelcted date value
  final DateTime selectedDate;

  /// Collection of colors
  final List<Color> colorCollection;

  /// List of colors name
  final List<String> colorNames;

  /// Holds the events value
  final CalendarDataSource events;

  /// Collection of time zone values
  final List<String> timeZoneCollection;

  /// Selected calendar resource
  final CalendarResource? selectedResource;

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentEditorState createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  int _selectedColorIndex = 0;
  int _selectedTimeZoneIndex = 0;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  bool _isAllDay = false;
  String _subject = '';
  String? _notes;
  String? _location;
  List<Object>? _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> _unSelectedResources = <CalendarResource>[];

  RecurrenceProperties? _recurrenceProperties;
  late RecurrenceType _recurrenceType;
  RecurrenceRange? _recurrenceRange;
  late int _interval;

  _SelectRule? _rule = _SelectRule.doesNotRepeat;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(AppointmentEditor oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the required editor's default field
  void _updateAppointmentProperties() {
    if (widget.selectedAppointment != null) {
      _startDate = widget.selectedAppointment!.startTime;
      _endDate = widget.selectedAppointment!.endTime;
      _isAllDay = widget.selectedAppointment!.isAllDay;
      _selectedColorIndex = widget.colorCollection.indexOf(widget.selectedAppointment!.color);
      _selectedTimeZoneIndex = widget.selectedAppointment!.startTimeZone == null || widget.selectedAppointment!.startTimeZone == ''
          ? 0
          : widget.timeZoneCollection.indexOf(widget.selectedAppointment!.startTimeZone!);
      _subject = widget.selectedAppointment!.subject == '(No title)' ? '' : widget.selectedAppointment!.subject;
      _notes = widget.selectedAppointment!.notes;
      _location = widget.selectedAppointment!.location;
      _resourceIds = widget.selectedAppointment!.resourceIds?.sublist(0);
      _recurrenceProperties = widget.selectedAppointment!.recurrenceRule != null && widget.selectedAppointment!.recurrenceRule!.isNotEmpty
          ? SfCalendar.parseRRule(widget.selectedAppointment!.recurrenceRule!, _startDate)
          : null;
      if (_recurrenceProperties == null) {
        _rule = _SelectRule.doesNotRepeat;
      } else {
        _updateMobileRecurrenceProperties();
      }
    } else {
      _isAllDay = widget.targetElement == CalendarElement.allDayPanel;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      _location = '';

      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      if (widget.selectedResource != null) {
        _resourceIds = <Object>[widget.selectedResource!.id];
      }
      _rule = _SelectRule.doesNotRepeat;
      _recurrenceProperties = null;
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources = _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources = _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  void _updateMobileRecurrenceProperties() {
    _recurrenceType = _recurrenceProperties!.recurrenceType;
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    _interval = _recurrenceProperties!.interval;
    if (_interval == 1 && _recurrenceRange == RecurrenceRange.noEndDate) {
      switch (_recurrenceType) {
        case RecurrenceType.daily:
          _rule = _SelectRule.everyDay;
          break;
        case RecurrenceType.weekly:
          if (_recurrenceProperties!.weekDays.length == 1) {
            _rule = _SelectRule.everyWeek;
          } else {
            _rule = _SelectRule.custom;
          }
          break;
        case RecurrenceType.monthly:
          _rule = _SelectRule.everyMonth;
          break;
        case RecurrenceType.yearly:
          _rule = _SelectRule.everyYear;
          break;
      }
    } else {
      _rule = _SelectRule.custom;
    }
  }

  Widget getAppointmentEditor(BuildContext context, Color backgroundColor, Color defaultColor) {
    return Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: TextEditingController(text: _subject),
                onChanged: (String value) {
                  _subject = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(fontSize: 25, color: defaultColor, fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Condidat',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.access_time,
                  color: defaultColor,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('Toute la journée'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData(
                                  brightness: Theme.of(context).colorScheme.brightness,
                                  colorScheme: _getColorScheme(widget.model, true),
                                  primaryColor: widget.model.backgroundColor,
                                ),
                                child: child!,
                              );
                            });

                        if (date != null && date != _startDate) {
                          setState(() {
                            final Duration difference = _endDate.difference(_startDate);
                            _startDate = DateTime(date.year, date.month, date.day, _startTime.hour, _startTime.minute);
                            _endDate = _startDate.add(difference);
                            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
                          });
                        }
                      },
                      child: Text("Date Début : " + DateFormat('dd/MM/yyyy').format(_startDate), textAlign: TextAlign.left),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: _isAllDay
                          ? const Text('')
                          : GestureDetector(
                              onTap: () async {
                                final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
                                    builder: (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData(
                                          brightness: Theme.of(context).colorScheme.brightness,
                                          colorScheme: _getColorScheme(widget.model, false),
                                          primaryColor: widget.model.backgroundColor,
                                        ),
                                        child: child!,
                                      );
                                    });

                                if (time != null && time != _startTime) {
                                  setState(() {
                                    _startTime = time;
                                    final Duration difference = _endDate.difference(_startDate);
                                    _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day, _startTime.hour, _startTime.minute);
                                    _endDate = _startDate.add(difference);
                                    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('hh:mm a').format(_startDate),
                                textAlign: TextAlign.right,
                              ),
                            )),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData(
                                  brightness: Theme.of(context).colorScheme.brightness,
                                  colorScheme: _getColorScheme(widget.model, true),
                                  primaryColor: widget.model.backgroundColor,
                                ),
                                child: child!,
                              );
                            });

                        if (date != null && date != _endDate) {
                          setState(() {
                            final Duration difference = _endDate.difference(_startDate);
                            _endDate = DateTime(date.year, date.month, date.day, _endTime.hour, _endTime.minute);
                            if (_endDate.isBefore(_startDate)) {
                              _startDate = _endDate.subtract(difference);
                              _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
                            }
                          });
                        }
                      },
                      child: Text(
                        "Date fin : " + DateFormat('dd/MM/yyyy').format(_endDate),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: _isAllDay
                          ? const Text('')
                          : GestureDetector(
                              onTap: () async {
                                final TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                                    builder: (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData(
                                          brightness: Theme.of(context).colorScheme.brightness,
                                          colorScheme: _getColorScheme(widget.model, false),
                                          primaryColor: widget.model.backgroundColor,
                                        ),
                                        child: child!,
                                      );
                                    });

                                if (time != null && time != _endTime) {
                                  setState(() {
                                    _endTime = time;
                                    final Duration difference = _endDate.difference(_startDate);
                                    _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, _endTime.hour, _endTime.minute);
                                    if (_endDate.isBefore(_startDate)) {
                                      _startDate = _endDate.subtract(difference);
                                      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
                                    }
                                  });
                                }
                              },
                              child: Text(
                                DateFormat('hh:mm a').format(_endDate),
                                textAlign: TextAlign.right,
                              ),
                            )),
                ])),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.public,
                color: defaultColor,
              ),
              title: Text(widget.timeZoneCollection[_selectedTimeZoneIndex]),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return _CalendarTimeZonePicker(
                      widget.model.backgroundColor,
                      widget.timeZoneCollection,
                      _selectedTimeZoneIndex,
                      widget.model,
                      onChanged: (_PickerChangedDetails details) {
                        _selectedTimeZoneIndex = details.index;
                      },
                    );
                  },
                ).then((dynamic value) => setState(() {
                      /// update the time zone changes
                    }));
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(
                Icons.refresh,
                color: defaultColor,
              ),
              title: Text(_rule == _SelectRule.doesNotRepeat
                  ? 'Does not repeat'
                  : _rule == _SelectRule.everyDay
                      ? 'Every day'
                      : _rule == _SelectRule.everyWeek
                          ? 'Every week'
                          : _rule == _SelectRule.everyMonth
                              ? 'Every month'
                              : _rule == _SelectRule.everyYear
                                  ? 'Every year'
                                  : 'Custom'),
              onTap: () async {
                final dynamic properties = await showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                          onWillPop: () async {
                            return true;
                          },
                          child: Theme(
                            data: Theme.of(context),
                            // ignore: prefer_const_literals_to_create_immutables
                            child: _SelectRuleDialog(
                              widget.model,
                              _recurrenceProperties,
                              widget.colorCollection[_selectedColorIndex],
                              widget.events,
                              selectedAppointment: widget.selectedAppointment ??
                                  Appointment(
                                    startTime: _startDate,
                                    endTime: _endDate,
                                    isAllDay: _isAllDay,
                                    subject: _subject == '' ? '(No title)' : _subject,
                                  ),
                              onChanged: (_PickerChangedDetails details) {
                                setState(() {
                                  _rule = details.selectedRule;
                                });
                              },
                            ),
                          ));
                    });
                _recurrenceProperties = properties as RecurrenceProperties?;
              },
            ),
            if (widget.events.resources == null || widget.events.resources!.isEmpty)
              Container()
            else
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(Icons.people, color: defaultColor),
                title: _getResourceEditor(TextStyle(fontSize: 18, color: defaultColor, fontWeight: FontWeight.w300)),
                onTap: () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return _ResourcePicker(
                        _unSelectedResources,
                        widget.model,
                        onChanged: (_PickerChangedDetails details) {
                          _resourceIds = _resourceIds == null ? <Object>[details.resourceId!] : (_resourceIds!.sublist(0)..add(details.resourceId!));
                          _selectedResources = _getSelectedResources(_resourceIds, widget.events.resources);
                          _unSelectedResources = _getUnSelectedResources(_selectedResources, widget.events.resources);
                        },
                      );
                    },
                  ).then((dynamic value) => setState(() {
                        /// update the color picker changes
                      }));
                },
              ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens, color: widget.colorCollection[_selectedColorIndex]),
              title: Text(
                widget.colorNames[_selectedColorIndex],
              ),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return _CalendarColorPicker(
                      widget.colorCollection,
                      _selectedColorIndex,
                      widget.colorNames,
                      widget.model,
                      onChanged: (_PickerChangedDetails details) {
                        _selectedColorIndex = details.index;
                      },
                    );
                  },
                ).then((dynamic value) => setState(() {
                      /// update the color picker changes
                    }));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            if (widget.model.isWebFullView)
              ListTile(
                contentPadding: const EdgeInsets.all(5),
                leading: Icon(
                  Icons.location_on,
                  color: defaultColor,
                ),
                title: TextField(
                  controller: TextEditingController(text: _location),
                  onChanged: (String value) {
                    _location = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(fontSize: 18, color: defaultColor, fontWeight: FontWeight.w300),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add location',
                  ),
                ),
              )
            else
              Container(),
            if (widget.model.isWebFullView)
              const Divider(
                height: 1.0,
                thickness: 1,
              )
            else
              Container(),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: Icon(
                Icons.subject,
                color: defaultColor,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                cursorColor: widget.model.backgroundColor,
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: widget.model.isWebFullView ? 1 : null,
                style: TextStyle(fontSize: 18, color: defaultColor, fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Déscription',
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context),
        child: Scaffold(
            backgroundColor:
                // ignore: unrelated_type_equality_checks
                Theme.of(context).colorScheme == Brightness.dark ? Colors.grey[850] : Colors.white,
            appBar: AppBar(
              backgroundColor: widget.colorCollection[_selectedColorIndex],
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Color.fromARGB(255, 241, 240, 240),
                    ),
                    onPressed: () {
                      if (widget.selectedAppointment != null) {
                        if (widget.selectedAppointment!.appointmentType != AppointmentType.normal) {
                          final Appointment newAppointment = Appointment(
                            startTime: _startDate,
                            endTime: _endDate,
                            color: widget.colorCollection[_selectedColorIndex],
                            startTimeZone: _selectedTimeZoneIndex == 0 ? '' : widget.timeZoneCollection[_selectedTimeZoneIndex],
                            endTimeZone: _selectedTimeZoneIndex == 0 ? '' : widget.timeZoneCollection[_selectedTimeZoneIndex],
                            notes: _notes,
                            isAllDay: _isAllDay,
                            subject: _subject == '' ? '(No title)' : _subject,
                            recurrenceExceptionDates: widget.selectedAppointment!.recurrenceExceptionDates,
                            resourceIds: _resourceIds,
                            id: widget.selectedAppointment!.id,
                            recurrenceId: widget.selectedAppointment!.recurrenceId,
                            recurrenceRule:
                                _recurrenceProperties == null ? null : SfCalendar.generateRRule(_recurrenceProperties!, _startDate, _endDate),
                          );
                          showDialog<Widget>(
                              context: context,
                              builder: (BuildContext context) {
                                return WillPopScope(
                                    onWillPop: () async {
                                      return true;
                                    },
                                    child: Theme(
                                      data: Theme.of(context),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      child: _EditDialog(
                                          widget.model, newAppointment, widget.selectedAppointment!, _recurrenceProperties, widget.events),
                                    ));
                              });
                        } else {
                          final List<Appointment> appointment = <Appointment>[];
                          if (widget.selectedAppointment != null) {
                            widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment!]);
                          }
                          appointment.add(Appointment(
                            startTime: _startDate,
                            endTime: _endDate,
                            color: widget.colorCollection[_selectedColorIndex],
                            startTimeZone: _selectedTimeZoneIndex == 0 ? '' : widget.timeZoneCollection[_selectedTimeZoneIndex],
                            endTimeZone: _selectedTimeZoneIndex == 0 ? '' : widget.timeZoneCollection[_selectedTimeZoneIndex],
                            notes: _notes,
                            isAllDay: _isAllDay,
                            subject: _subject == '' ? '(No title)' : _subject,
                            resourceIds: _resourceIds,
                            id: widget.selectedAppointment!.id,
                            recurrenceRule:
                                _recurrenceProperties == null ? null : SfCalendar.generateRRule(_recurrenceProperties!, _startDate, _endDate),
                          ));
                          widget.events.appointments!.add(appointment[0]);

                          widget.events.notifyListeners(CalendarDataSourceAction.add, appointment);
                          Navigator.pop(context);
                        }
                      } else {
                        final List<Appointment> appointment = <Appointment>[];
                        if (widget.selectedAppointment != null) {
                          widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                          widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment!]);
                        }
                        appointment.add(Appointment(
                          startTime: _startDate,
                          endTime: _endDate,
                          color: widget.colorCollection[_selectedColorIndex],
                          startTimeZone: _selectedTimeZoneIndex == 0 ? '' : widget.timeZoneCollection[_selectedTimeZoneIndex],
                          endTimeZone: _selectedTimeZoneIndex == 0 ? '' : widget.timeZoneCollection[_selectedTimeZoneIndex],
                          notes: _notes,
                          isAllDay: _isAllDay,
                          subject: _subject == '' ? '(No title)' : _subject,
                          resourceIds: _resourceIds,
                          recurrenceRule: _rule == _SelectRule.doesNotRepeat || _recurrenceProperties == null
                              ? null
                              : SfCalendar.generateRRule(_recurrenceProperties!, _startDate, _endDate),
                        ));

                        widget.events.appointments!.add(appointment[0]);

                        widget.events.notifyListeners(CalendarDataSourceAction.add, appointment);
                        Navigator.pop(context);
                      }
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[
                  getAppointmentEditor(context, (Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.grey[850] : Colors.white)!,
                      Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black87)
                ],
              ),
            ),
            floatingActionButton: widget.model.isWebFullView
                ? null
                : widget.selectedAppointment == null
                    ? const Text('')
                    : FloatingActionButton(
                        onPressed: () {
                          if (widget.selectedAppointment != null) {
                            if (widget.selectedAppointment!.appointmentType == AppointmentType.normal) {
                              widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                              widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment!]);
                              Navigator.pop(context);
                            } else {
                              showDialog<Widget>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                        onWillPop: () async {
                                          return true;
                                        },
                                        child: Theme(
                                          data: Theme.of(context),
                                          // ignore: prefer_const_literals_to_create_immutables
                                          child: _DeleteDialog(widget.model, widget.selectedAppointment!, widget.events),
                                        ));
                                  });
                            }
                          }
                        },
                        backgroundColor: widget.model.backgroundColor,
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      )));
  }

  /// Return the resource editor to edit the resource collection for an
  /// appointment
  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }

    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          backgroundColor: widget.model.backgroundColor,
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null ? Text(selectedResource.displayName[0]) : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds?.removeAt(i);
          _unSelectedResources = _getUnSelectedResources(_selectedResources, widget.events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }
}

/// Signature for callback which reports the picker value changed
typedef _PickerChanged = void Function(_PickerChangedDetails pickerChangedDetails);

/// Details for the [_PickerChanged].
class _PickerChangedDetails {
  _PickerChangedDetails({this.index = -1, this.resourceId, this.selectedRule = _SelectRule.doesNotRepeat});

  final int index;

  final Object? resourceId;

  final _SelectRule? selectedRule;
}

class _CalendarColorPicker extends StatefulWidget {
  const _CalendarColorPicker(this.colorCollection, this.selectedColorIndex, this.colorNames, this.model, {required this.onChanged});

  final List<Color> colorCollection;

  final int selectedColorIndex;

  final List<String> colorNames;

  final SampleModel model;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() => _CalendarColorPickerState();
}

class _CalendarColorPickerState extends State<_CalendarColorPicker> {
  int _selectedColorIndex = -1;

  @override
  void initState() {
    _selectedColorIndex = widget.selectedColorIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarColorPicker oldWidget) {
    _selectedColorIndex = widget.selectedColorIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: AlertDialog(
        content: SizedBox(
            width: kIsWeb || widget.model.isWindows || widget.model.isMacOS ? 500 : double.maxFinite,
            height: (widget.colorCollection.length * 50).toDouble(),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.colorCollection.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 50,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      leading: Icon(index == _selectedColorIndex ? Icons.lens : Icons.trip_origin, color: widget.colorCollection[index]),
                      title: Text(widget.colorNames[index]),
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                          widget.onChanged(_PickerChangedDetails(index: index));
                        });

                        // ignore: always_specify_types
                        Future.delayed(const Duration(milliseconds: 200), () {
                          // When task is over, close the dialog
                          Navigator.pop(context);
                        });
                      },
                    ));
              },
            )),
      ),
    );
  }
}

/// Picker to display the available resource collection, and returns the
/// selected resource id.
class _ResourcePicker extends StatefulWidget {
  const _ResourcePicker(this.resourceCollection, this.model, {required this.onChanged});

  final List<CalendarResource> resourceCollection;

  final _PickerChanged onChanged;

  final SampleModel model;

  @override
  State<StatefulWidget> createState() => _ResourcePickerState();
}

class _ResourcePickerState extends State<_ResourcePicker> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context),
        child: AlertDialog(
          content: SizedBox(
              width: kIsWeb ? 500 : double.maxFinite,
              height: (widget.resourceCollection.length * 50).toDouble(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.resourceCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  final CalendarResource resource = widget.resourceCollection[index];
                  return SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        leading: CircleAvatar(
                          backgroundColor: widget.model.backgroundColor,
                          backgroundImage: resource.image,
                          child: resource.image == null ? Text(resource.displayName[0]) : null,
                        ),
                        title: Text(resource.displayName),
                        onTap: () {
                          setState(() {
                            widget.onChanged(_PickerChangedDetails(resourceId: resource.id));
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // When task is over, close the dialog
                            Navigator.pop(context);
                          });
                        },
                      ));
                },
              )),
        ));
  }
}

///  The time zone picker element for the appointment editor with the available
///  time zone collection, and returns the selection time zone index
class _CalendarTimeZonePicker extends StatefulWidget {
  const _CalendarTimeZonePicker(this.backgroundColor, this.timeZoneCollection, this.selectedTimeZoneIndex, this.model, {required this.onChanged});

  final Color backgroundColor;

  final List<String> timeZoneCollection;

  final int selectedTimeZoneIndex;

  final SampleModel model;

  final _PickerChanged onChanged;

  @override
  State<StatefulWidget> createState() {
    return _CalendarTimeZonePickerState();
  }
}

class _CalendarTimeZonePickerState extends State<_CalendarTimeZonePicker> {
  int _selectedTimeZoneIndex = -1;

  @override
  void initState() {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;

    super.initState();
  }

  @override
  void didUpdateWidget(_CalendarTimeZonePicker oldWidget) {
    _selectedTimeZoneIndex = widget.selectedTimeZoneIndex;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context),
        child: AlertDialog(
          content: SizedBox(
              width: kIsWeb ? 500 : double.maxFinite,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.timeZoneCollection.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                      height: 50,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        leading: Icon(
                          index == _selectedTimeZoneIndex ? Icons.check_box : Icons.check_box_outline_blank,
                          color: widget.backgroundColor,
                        ),
                        title: Text(widget.timeZoneCollection[index]),
                        onTap: () {
                          setState(() {
                            _selectedTimeZoneIndex = index;
                            widget.onChanged(_PickerChangedDetails(index: index));
                          });

                          // ignore: always_specify_types
                          Future.delayed(const Duration(milliseconds: 200), () {
                            // When task is over, close the dialog
                            Navigator.pop(context);
                          });
                        },
                      ));
                },
              )),
        ));
  }
}

ColorScheme _getColorScheme(SampleModel model, bool isDatePicker) {
  return ColorScheme.light(
    primary: model.backgroundColor,
    secondary: model.backgroundColor,
    surface: isDatePicker ? model.backgroundColor : Colors.white,
  );
}

enum _SelectRule { doesNotRepeat, everyDay, everyWeek, everyMonth, everyYear, custom }

enum _Edit { event, series }

enum _Delete { event, series }

/// Builds the appointment editor with all the required elements based on the
/// tapped calendar element for mobile.

/// Returns the resource from the id passed.
CalendarResource _getResourceFromId(Object resourceId, List<CalendarResource> resourceCollection) {
  return resourceCollection.firstWhere((CalendarResource resource) => resource.id == resourceId);
}

/// Returns the selected resources based on the id collection passed
List<CalendarResource> _getSelectedResources(List<Object>? resourceIds, List<CalendarResource>? resourceCollection) {
  final List<CalendarResource> selectedResources = <CalendarResource>[];
  if (resourceIds == null || resourceIds.isEmpty || resourceCollection == null || resourceCollection.isEmpty) {
    return selectedResources;
  }

  for (int i = 0; i < resourceIds.length; i++) {
    final CalendarResource resourceName = _getResourceFromId(resourceIds[i], resourceCollection);
    selectedResources.add(resourceName);
  }

  return selectedResources;
}

/// Returns the available resource, by filtering the resource collection from
/// the selected resource collection.
List<CalendarResource> _getUnSelectedResources(List<CalendarResource>? selectedResources, List<CalendarResource>? resourceCollection) {
  if (selectedResources == null || selectedResources.isEmpty || resourceCollection == null || resourceCollection.isEmpty) {
    return resourceCollection ?? <CalendarResource>[];
  }

  final List<CalendarResource> collection = resourceCollection.sublist(0);
  for (int i = 0; i < resourceCollection.length; i++) {
    final CalendarResource resource = resourceCollection[i];
    for (int j = 0; j < selectedResources.length; j++) {
      final CalendarResource selectedResource = selectedResources[j];
      if (resource.id == selectedResource.id) {
        collection.remove(resource);
      }
    }
  }

  return collection;
}

// ignore: must_be_immutable
class _SelectRuleDialog extends StatefulWidget {
  _SelectRuleDialog(this.model, this.recurrenceProperties, this.appointmentColor, this.events, {required this.onChanged, this.selectedAppointment});

  final SampleModel model;

  final Appointment? selectedAppointment;

  RecurrenceProperties? recurrenceProperties;

  final Color appointmentColor;

  final CalendarDataSource events;

  final _PickerChanged onChanged;

  @override
  _SelectRuleDialogState createState() => _SelectRuleDialogState();
}

class _SelectRuleDialogState extends State<_SelectRuleDialog> {
  late DateTime _startDate;
  RecurrenceProperties? _recurrenceProperties;
  late RecurrenceType _recurrenceType;
  late RecurrenceRange _recurrenceRange;
  late int _interval;

  _SelectRule? _rule;

  @override
  void initState() {
    _updateAppointmentProperties();
    super.initState();
  }

  @override
  void didUpdateWidget(_SelectRuleDialog oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the required editor's default field
  void _updateAppointmentProperties() {
    _startDate = widget.selectedAppointment!.startTime;
    _recurrenceProperties = widget.recurrenceProperties;
    if (widget.recurrenceProperties == null) {
      _rule = _SelectRule.doesNotRepeat;
    } else {
      _updateRecurrenceType();
    }
  }

  void _updateRecurrenceType() {
    _recurrenceType = widget.recurrenceProperties!.recurrenceType;
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    _interval = _recurrenceProperties!.interval;
    if (_interval == 1 && _recurrenceRange == RecurrenceRange.noEndDate) {
      switch (_recurrenceType) {
        case RecurrenceType.daily:
          _rule = _SelectRule.everyDay;
          break;
        case RecurrenceType.weekly:
          if (_recurrenceProperties!.weekDays.length == 1) {
            _rule = _SelectRule.everyWeek;
          } else {
            _rule = _SelectRule.custom;
          }
          break;
        case RecurrenceType.monthly:
          _rule = _SelectRule.everyMonth;
          break;
        case RecurrenceType.yearly:
          _rule = _SelectRule.everyYear;
          break;
      }
    } else {
      _rule = _SelectRule.custom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 360,
        padding: const EdgeInsets.only(left: 20, top: 10),
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Container(
            width: 360,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                RadioListTile<_SelectRule>(
                  title: const Text('Does not repeat'),
                  value: _SelectRule.doesNotRepeat,
                  groupValue: _rule,
                  toggleable: true,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties = null;
                        widget.onChanged(_PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every day'),
                  value: _SelectRule.everyDay,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType = RecurrenceType.daily;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
                        widget.onChanged(_PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every week'),
                  value: _SelectRule.everyWeek,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType = RecurrenceType.weekly;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
                        widget.recurrenceProperties!.weekDays = _startDate.weekday == 1
                            ? <WeekDays>[WeekDays.monday]
                            : _startDate.weekday == 2
                                ? <WeekDays>[WeekDays.tuesday]
                                : _startDate.weekday == 3
                                    ? <WeekDays>[WeekDays.wednesday]
                                    : _startDate.weekday == 4
                                        ? <WeekDays>[WeekDays.thursday]
                                        : _startDate.weekday == 5
                                            ? <WeekDays>[WeekDays.friday]
                                            : _startDate.weekday == 6
                                                ? <WeekDays>[WeekDays.saturday]
                                                : <WeekDays>[WeekDays.sunday];
                        widget.onChanged(_PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every month'),
                  value: _SelectRule.everyMonth,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType = RecurrenceType.monthly;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
                        widget.recurrenceProperties!.dayOfMonth = widget.selectedAppointment!.startTime.day;
                        widget.onChanged(_PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Every year'),
                  value: _SelectRule.everyYear,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) {
                    setState(() {
                      if (value != null) {
                        _rule = value;
                        widget.recurrenceProperties = RecurrenceProperties(startDate: _startDate);
                        widget.recurrenceProperties!.recurrenceType = RecurrenceType.yearly;
                        widget.recurrenceProperties!.interval = 1;
                        widget.recurrenceProperties!.recurrenceRange = RecurrenceRange.noEndDate;
                        widget.recurrenceProperties!.month = widget.selectedAppointment!.startTime.month;
                        widget.recurrenceProperties!.dayOfMonth = widget.selectedAppointment!.startTime.day;
                        widget.onChanged(_PickerChangedDetails(selectedRule: _rule));
                      }
                    });
                    Navigator.pop(context, widget.recurrenceProperties);
                  },
                ),
                RadioListTile<_SelectRule>(
                  title: const Text('Custom'),
                  value: _SelectRule.custom,
                  toggleable: true,
                  groupValue: _rule,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_SelectRule? value) async {},
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog(this.model, this.selectedAppointment, this.events);

  final SampleModel model;
  final Appointment selectedAppointment;
  final CalendarDataSource events;

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  _Delete _delete = _Delete.event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultTextColor = Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black87;
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: 380,
          height: 210,
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 370,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 25, top: 5),
                  child: Text(
                    'Delete recurring event',
                    style: TextStyle(color: defaultTextColor, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 20,
                ),
                RadioListTile<_Delete>(
                  title: const Text('This event'),
                  value: _Delete.event,
                  groupValue: _delete,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Delete? value) {
                    setState(() {
                      _delete = value!;
                    });
                  },
                ),
                RadioListTile<_Delete>(
                  title: const Text('All events'),
                  value: _Delete.series,
                  groupValue: _delete,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Delete? value) {
                    setState(() {
                      _delete = value!;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: widget.model.backgroundColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        final Appointment? parentAppointment = widget.events.getPatternAppointment(widget.selectedAppointment, '') as Appointment?;
                        if (_delete == _Delete.event) {
                          if (widget.selectedAppointment.recurrenceId != null) {
                            widget.events.appointments!.remove(widget.selectedAppointment);
                            widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(parentAppointment));
                          widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment!]);
                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!.add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates = <DateTime>[widget.selectedAppointment.startTime];
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(CalendarDataSourceAction.add, <Appointment>[parentAppointment]);
                        } else {
                          if (parentAppointment!.recurrenceExceptionDates == null) {
                            widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(parentAppointment));
                            widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment]);
                          } else {
                            final List<DateTime>? exceptionDates = parentAppointment.recurrenceExceptionDates;
                            for (int i = 0; i < exceptionDates!.length; i++) {
                              final Appointment? changedOccurrence = widget.events.getOccurrenceAppointment(parentAppointment, exceptionDates[i], '');
                              if (changedOccurrence != null) {
                                widget.events.appointments!.remove(changedOccurrence);
                                widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[changedOccurrence]);
                              }
                            }
                            widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(parentAppointment));
                            widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment]);
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.w500, color: widget.model.backgroundColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditDialog extends StatefulWidget {
  const _EditDialog(this.model, this.newAppointment, this.selectedAppointment, this.recurrenceProperties, this.events);

  final SampleModel model;
  final Appointment newAppointment, selectedAppointment;
  final RecurrenceProperties? recurrenceProperties;
  final CalendarDataSource events;

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  _Edit _edit = _Edit.event;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultTextColor = Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black87;
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: 380,
          height: 210,
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 370,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 25, top: 5),
                  child: Text(
                    'Save recurring event',
                    style: TextStyle(color: defaultTextColor, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 20,
                ),
                RadioListTile<_Edit>(
                  title: const Text('This event'),
                  value: _Edit.event,
                  groupValue: _edit,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Edit? value) {
                    setState(() {
                      _edit = value!;
                    });
                  },
                ),
                RadioListTile<_Edit>(
                  title: const Text('All events'),
                  value: _Edit.series,
                  groupValue: _edit,
                  activeColor: widget.model.backgroundColor,
                  onChanged: (_Edit? value) {
                    setState(() {
                      _edit = value!;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: widget.model.backgroundColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                    RawMaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      onPressed: () {
                        if (_edit == _Edit.event) {
                          final Appointment? parentAppointment = widget.events.getPatternAppointment(widget.selectedAppointment, '') as Appointment?;

                          final Appointment newAppointment = Appointment(
                              startTime: widget.newAppointment.startTime,
                              endTime: widget.newAppointment.endTime,
                              color: widget.newAppointment.color,
                              notes: widget.newAppointment.notes,
                              isAllDay: widget.newAppointment.isAllDay,
                              location: widget.newAppointment.location,
                              subject: widget.newAppointment.subject,
                              resourceIds: widget.newAppointment.resourceIds,
                              id: widget.selectedAppointment.appointmentType == AppointmentType.changedOccurrence
                                  ? widget.selectedAppointment.id
                                  : null,
                              recurrenceId: parentAppointment!.id,
                              startTimeZone: widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone);

                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!.add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates = <DateTime>[widget.selectedAppointment.startTime];
                          widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(parentAppointment));
                          widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment]);
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(CalendarDataSourceAction.add, <Appointment>[parentAppointment]);
                          if (widget.selectedAppointment.appointmentType == AppointmentType.changedOccurrence) {
                            widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.add(newAppointment);
                          widget.events.notifyListeners(CalendarDataSourceAction.add, <Appointment>[newAppointment]);
                        } else {
                          Appointment? parentAppointment = widget.events.getPatternAppointment(widget.selectedAppointment, '') as Appointment?;
                          final List<DateTime>? exceptionDates = parentAppointment!.recurrenceExceptionDates;
                          if (exceptionDates != null && exceptionDates.isNotEmpty) {
                            for (int i = 0; i < exceptionDates.length; i++) {
                              final Appointment? changedOccurrence = widget.events.getOccurrenceAppointment(parentAppointment, exceptionDates[i], '');
                              if (changedOccurrence != null) {
                                widget.events.appointments!.remove(changedOccurrence);
                                widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[changedOccurrence]);
                              }
                            }
                          }

                          widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(parentAppointment));
                          widget.events.notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment]);
                          DateTime startDate, endDate;
                          if ((widget.newAppointment.startTime).isBefore(parentAppointment.startTime)) {
                            startDate = widget.newAppointment.startTime;
                            endDate = widget.newAppointment.endTime;
                          } else {
                            startDate = DateTime(parentAppointment.startTime.year, parentAppointment.startTime.month, parentAppointment.startTime.day,
                                widget.newAppointment.startTime.hour, widget.newAppointment.startTime.minute);
                            endDate = DateTime(parentAppointment.endTime.year, parentAppointment.endTime.month, parentAppointment.endTime.day,
                                widget.newAppointment.endTime.hour, widget.newAppointment.endTime.minute);
                          }
                          parentAppointment = Appointment(
                              startTime: startDate,
                              endTime: endDate,
                              color: widget.newAppointment.color,
                              notes: widget.newAppointment.notes,
                              isAllDay: widget.newAppointment.isAllDay,
                              location: widget.newAppointment.location,
                              subject: widget.newAppointment.subject,
                              resourceIds: widget.newAppointment.resourceIds,
                              id: parentAppointment.id,
                              recurrenceRule: widget.recurrenceProperties == null
                                  ? null
                                  : SfCalendar.generateRRule(widget.recurrenceProperties!, startDate, endDate),
                              startTimeZone: widget.newAppointment.startTimeZone,
                              endTimeZone: widget.newAppointment.endTimeZone);
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(CalendarDataSourceAction.add, <Appointment>[parentAppointment]);
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.w500, color: widget.model.backgroundColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
