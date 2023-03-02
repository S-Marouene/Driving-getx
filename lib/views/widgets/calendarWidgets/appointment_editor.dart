import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'model.dart';

class AppointmentEditor extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AppointmentEditor(this.model, this.selectedAppointment, this.targetElement, this.selectedDate,
      this.colorCollection, this.colorNames, this.events,
      [this.selectedResource]);

  final SampleModel model;
  final Appointment? selectedAppointment;
  final CalendarElement targetElement;
  final DateTime selectedDate;
  final List<Color> colorCollection;
  final List<String> colorNames;
  final CalendarDataSource events;
  //final List<String> timeZoneCollection;
  final CalendarResource? selectedResource;
  @override
  // ignore: library_private_types_in_public_api
  _AppointmentEditorState createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';
  int _selectedColorIndex = 0;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  bool _isAllDay = false;
  String _subject = '';
  String _photo = '';
  String? _notes;
  List<Object>? _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> _unSelectedResources = <CalendarResource>[];

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
      _subject = widget.selectedAppointment!.subject == '(No title)' ? '' : widget.selectedAppointment!.subject;

      _photo = widget.selectedAppointment!.photo == '(No photo)' ? '' : widget.selectedAppointment!.photo;

      _notes = widget.selectedAppointment!.notes;
      _resourceIds = widget.selectedAppointment!.resourceIds?.sublist(0);
    } else {
      _isAllDay = widget.targetElement == CalendarElement.allDayPanel;
      _selectedColorIndex = 0;
      _subject = '';
      _notes = '';
      _photo = '';

      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      if (widget.selectedResource != null) {
        _resourceIds = <Object>[widget.selectedResource!.id];
      }
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources = _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources = _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  Widget getAppointmentEditor(BuildContext context, Color backgroundColor, Color defaultColor) {
    return Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  height: 50,
                  //width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage('images/app/loading.gif'),
                      image: Image.network(
                        URLpic + (_photo == '' ? 'unknown_profile.png' : _photo),
                      ).image,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  //height: 50,
                  width: 250,
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    title: TextField(
                      controller: TextEditingController(text: _subject),
                      onChanged: (String value) {
                        _subject = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(fontSize: 15, color: defaultColor, fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Condidat',
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
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
                      child: Text("Date Début : " + DateFormat('dd/MM/yyyy').format(_startDate),
                          textAlign: TextAlign.left),
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
                                    _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day,
                                        _startTime.hour, _startTime.minute);
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
                                    _endDate = DateTime(
                                        _endDate.year, _endDate.month, _endDate.day, _endTime.hour, _endTime.minute);
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
                          _resourceIds = _resourceIds == null
                              ? <Object>[details.resourceId!]
                              : (_resourceIds!.sublist(0)..add(details.resourceId!));
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
                        /* if (widget.selectedAppointment!.appointmentType != AppointmentType.normal) {
                          final Appointment newAppointment = Appointment(
                            startTime: _startDate,
                            endTime: _endDate,
                            color: widget.colorCollection[_selectedColorIndex],
                            notes: _notes,
                            isAllDay: _isAllDay,
                            subject: _subject == '' ? '(No title)' : _subject,
                            resourceIds: _resourceIds,
                            id: widget.selectedAppointment!.id,
                          );
                        } else { */
                        final List<Appointment> appointment = <Appointment>[];
                        if (widget.selectedAppointment != null) {
                          widget.events.appointments!
                              .removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment!]);
                        }
                        appointment.add(Appointment(
                          startTime: _startDate,
                          endTime: _endDate,
                          color: widget.colorCollection[_selectedColorIndex],
                          notes: _notes,
                          isAllDay: _isAllDay,
                          subject: _subject == '' ? '(No title)' : _subject,
                          resourceIds: _resourceIds,
                          id: widget.selectedAppointment!.id,
                        ));
                        widget.events.appointments!.add(appointment[0]);

                        widget.events.notifyListeners(CalendarDataSourceAction.add, appointment);
                        Navigator.pop(context);
                        /* } */
                      } else {
                        final List<Appointment> appointment = <Appointment>[];
                        if (widget.selectedAppointment != null) {
                          widget.events.appointments!
                              .removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                          widget.events.notifyListeners(
                              CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment!]);
                        }
                        appointment.add(Appointment(
                          startTime: _startDate,
                          endTime: _endDate,
                          color: widget.colorCollection[_selectedColorIndex],
                          notes: _notes,
                          isAllDay: _isAllDay,
                          subject: _subject == '' ? '(No title)' : _subject,
                          resourceIds: _resourceIds,
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
                  getAppointmentEditor(
                      context,
                      (Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.grey[850] : Colors.white)!,
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
                              widget.events.appointments!
                                  .removeAt(widget.events.appointments!.indexOf(widget.selectedAppointment));
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment!]);
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
                                          child:
                                              _DeleteDialog(widget.model, widget.selectedAppointment!, widget.events),
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
  // ignore: unused_element
  _PickerChangedDetails({this.index = -1, this.resourceId, this.selectedRule = _SelectRule.doesNotRepeat});

  final int index;

  final Object? resourceId;

  final _SelectRule? selectedRule;
}

class _CalendarColorPicker extends StatefulWidget {
  const _CalendarColorPicker(this.colorCollection, this.selectedColorIndex, this.colorNames, this.model,
      {required this.onChanged});

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
                      leading: Icon(index == _selectedColorIndex ? Icons.lens : Icons.trip_origin,
                          color: widget.colorCollection[index]),
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

ColorScheme _getColorScheme(SampleModel model, bool isDatePicker) {
  return ColorScheme.light(
    primary: model.backgroundColor,
    secondary: model.backgroundColor,
    surface: isDatePicker ? model.backgroundColor : Colors.white,
  );
}

enum _SelectRule { doesNotRepeat }

enum _Delete { event, series }

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

List<CalendarResource> _getUnSelectedResources(
    List<CalendarResource>? selectedResources, List<CalendarResource>? resourceCollection) {
  if (selectedResources == null ||
      selectedResources.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
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
    final Color defaultTextColor =
        Theme.of(context).colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black87;
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
                        final Appointment? parentAppointment =
                            widget.events.getPatternAppointment(widget.selectedAppointment, '') as Appointment?;
                        if (_delete == _Delete.event) {
                          if (widget.selectedAppointment.recurrenceId != null) {
                            widget.events.appointments!.remove(widget.selectedAppointment);
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove, <Appointment>[widget.selectedAppointment]);
                          }
                          widget.events.appointments!.removeAt(widget.events.appointments!.indexOf(parentAppointment));
                          widget.events
                              .notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment!]);
                          parentAppointment.recurrenceExceptionDates != null
                              ? parentAppointment.recurrenceExceptionDates!.add(widget.selectedAppointment.startTime)
                              : parentAppointment.recurrenceExceptionDates = <DateTime>[
                                  widget.selectedAppointment.startTime
                                ];
                          widget.events.appointments!.add(parentAppointment);
                          widget.events.notifyListeners(CalendarDataSourceAction.add, <Appointment>[parentAppointment]);
                        } else {
                          if (parentAppointment!.recurrenceExceptionDates == null) {
                            widget.events.appointments!
                                .removeAt(widget.events.appointments!.indexOf(parentAppointment));
                            widget.events
                                .notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment]);
                          } else {
                            final List<DateTime>? exceptionDates = parentAppointment.recurrenceExceptionDates;
                            for (int i = 0; i < exceptionDates!.length; i++) {
                              final Appointment? changedOccurrence =
                                  widget.events.getOccurrenceAppointment(parentAppointment, exceptionDates[i], '');
                              if (changedOccurrence != null) {
                                widget.events.appointments!.remove(changedOccurrence);
                                widget.events
                                    .notifyListeners(CalendarDataSourceAction.remove, <Appointment>[changedOccurrence]);
                              }
                            }
                            widget.events.appointments!
                                .removeAt(widget.events.appointments!.indexOf(parentAppointment));
                            widget.events
                                .notifyListeners(CalendarDataSourceAction.remove, <Appointment>[parentAppointment]);
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
