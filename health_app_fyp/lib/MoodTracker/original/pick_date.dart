import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'package:health_app_fyp/MoodTracker/original/pick_date.dart';
import 'package:health_app_fyp/MoodTracker/original/pick_mood.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../widgets/customnavbar.dart';
import 'pick_date.dart';

/// My app class to display the date range picker
class PickDateMoodTracker extends StatefulWidget {
  const PickDateMoodTracker({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

/// State for MoodHome
class MyAppState extends State<PickDateMoodTracker> {
  String selectedDate = DateTime.now()
      .toString()
      .substring(0, DateTime.now().toString().length - 15);
  DateTime now = DateTime.now();

  DateTime picked = DateTime.now();
  var newString = '';

  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        selectedDate = args.value.toString();

        if (selectedDate != null && selectedDate.length >= 13) {
          selectedDate = selectedDate.substring(0, selectedDate.length - 13);
        }

        //  newString = selectedDate.substring(selectedDate.length - 15);
        picked = args.value;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Select Date'),
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      bottomNavigationBar: CustomisedNavigationBar(),
      //bottomNavigationBar: HomeScreen(),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    child: Center(
                        child: Text(
                  'Selected date: $selectedDate',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ))),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 80,
            right: 0,
            bottom: 0,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionColor: Colors.black,
              selectionMode: DateRangePickerSelectionMode.single,
              maxDate: DateTime.now(),
              backgroundColor: Colors.white,
              // showTodayButton: true,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
          )
        ],
      ),
      floatingActionButton: getFloatingActionButton(),
    ));
  }

  bool dialVisible = true;
  Widget getFloatingActionButton() {
    return SpeedDial(
        overlayColor: Colors.black,
        backgroundColor: Colors.black,
        animatedIcon: AnimatedIcons.add_event,
        animatedIconTheme: const IconThemeData(size: 22.0),
        visible: dialVisible,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(MdiIcons.calendar, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () {
              Get.to(MoodActivitySelect(selectedDate: selectedDate));
            },
            label: 'Select Date',
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.green,
          )
        ]);
  }
}
