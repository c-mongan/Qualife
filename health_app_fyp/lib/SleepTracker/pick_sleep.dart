import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/MoodTracker/models.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';

import 'package:health_app_fyp/MoodTracker/original/list_of_moods.dart';
import 'package:health_app_fyp/SleepTracker/list_of_sleep_time.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:health_app_fyp/widgets/nuemorphic_button.dart';
import 'package:intl/intl.dart';

class SleepDurationSelect extends StatefulWidget {
  final String selectedDate;

  const SleepDurationSelect({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  _SleepDurationSelectState createState() => _SleepDurationSelectState();
}

class _SleepDurationSelectState extends State<SleepDurationSelect> {
  String? selectedDate;

  Duration _duration = const Duration(hours: 8, minutes: 0);
  String? datepicked;
  String? timepicked;
  String? datetime;

  int? currentindex;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool _isSaving = false;

  DateTime inputTime = DateTime.now();

  Color colour = Colors.white;
  @override
  void initState() {
    super.initState();
  }

  late String dateonly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Mood'),
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
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.grey,
              Colors.black,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Container(
              child: Column(children: <Widget>[
                // SizedBox(
                //   height: 30,
                // ),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                const Text('How long did you sleep?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                SizedBox(
                  height: 250,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(_duration),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      Slider(
                        value: _duration.inMinutes.toDouble(),
                        min: 30,
                        max: 24 * 60,
                        divisions: 47,
                        label: _formatDuration(_duration),
                        onChanged: (minutes) {
                          setState(() {
                            _duration = Duration(minutes: minutes.round());
                          });
                        },
                      ),
                      const Text(
                        '30 minute increments',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // DurationPicker(
                //   height: 250,
                //   width: 250,
                //   duration: _duration,
                //   onChange: (val) {
                //     setState(() => _duration = val);
                //   },
                //   snapToMins: 5.0,
                // ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _saveSleep,
                  child: Container(
                    height: 38.00,
                    width: 117.00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        Text(
                          'Save ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 21.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.save_alt, size: 20, color: Colors.white)
                      ],
                    ),
                    decoration: BoxDecoration(
                      // color: Color(0xffff3d00),
                      color: Colors.black,
                      border: Border.all(
                        width: 0.00,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(19.00),
                    ),
                  ),
                ),
                const SizedBox(height: 15)
              ]),
            )));
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (!mounted) return;
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  Future<void> _saveSleep() async {
    if (_isSaving) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('Please sign in before saving sleep.');
      return;
    }
    setState(() => _isSaving = true);
    try {
      final formatter = NumberFormat("00");
      final time =
          '${selectedTime.hour}:${formatter.format(selectedTime.minute)}';
      await FirebaseFirestore.instance.collection('SleepTracking').add({
        'userID': user.uid,
        'DateOfSleep': widget.selectedDate,
        'TimeOfSleep': time,
        'SleepDuration':
            double.parse((_duration.inMinutes / 60).toStringAsFixed(1)),
        'SleepTime': DateFormat('yyyy-MM-dd').parseStrict(widget.selectedDate),
      });
      if (mounted) Get.to(const ListSleep());
    } catch (_) {
      _showError('Could not save sleep. Please try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
