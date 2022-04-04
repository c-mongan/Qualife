import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pie_chart/pie_chart.dart';
import '../model/user_model.dart';
import 'login_screen.dart';
import 'package:duration_picker/duration_picker.dart';

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({Key? key}) : super(key: key);

  static String id = 'chartSlider';

  @override
  _DailyCheckInPageState createState() => _DailyCheckInPageState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  late WeightSliderController _controller;
  double _weight = 30.0;

  Duration _duration = Duration(hours: 0, minutes: 0);

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
        initialWeight: _weight, minWeight: 0, interval: 0.1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int key = 0;

  var today = DateTime.now();

  Future<void> setPage() async {}

  Color activeColor = Colors.white;
  Color inactiveColor = Colors.white;

  final double _max = 100.0;
  double _value = 8.00;

  @override
  Widget build(BuildContext context) //=> Scaffold( {
  {
    late double bmiScore = 20;
    ;
    return VisibilityDetector(
        key: Key(DailyCheckInPage.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          //asyncMethod(isVisible);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Graphs'),
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            bottomNavigationBar: CustomisedNavigationBar(),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.black,
                Colors.grey,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: SingleChildScrollView(
                // <-- wrap this around
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 45,
                                    child: Text(
                                      "Your Daily Check In",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    alignment: Alignment.center,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: Text(
                                      "What is your weight?",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "${_weight.toStringAsFixed(1)} kg",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  weightSlider(),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: Text(
                                      "How much sleep did you get?",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  DurationPicker(
                                    height: 300,
                                    width: 300,
                                    duration: _duration,
                                    onChange: (val) {
                                      setState(() => _duration = val);
                                    },
                                    snapToMins: 5.0,
                                  ),
                                  Text((_duration.inHours).toStringAsFixed(2) +
                                      " hours"),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: Text(
                                      "What is your overall Mood?",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  SfSliderTheme(
                                    data: SfSliderThemeData(
                                      activeLabelStyle: TextStyle(
                                          color: activeColor,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                      inactiveLabelStyle: TextStyle(
                                          color: inactiveColor,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                      thumbColor: Colors.white,
                                      thumbRadius: 15,
                                      thumbStrokeWidth: 2,
                                      thumbStrokeColor: activeColor,
                                      activeTrackColor: activeColor,
                                      inactiveTrackColor: inactiveColor,
                                    ),
                                    child: SfSlider(
                                      min: 0.0,
                                      max: 24.0,
                                      value: _value,
                                      interval: 4,
                                      showTicks: false,
                                      showLabels: false,
                                      enableTooltip: true,
                                      shouldAlwaysShowTooltip: true,
                                      minorTicksPerInterval: 1,
                                      numberFormat:
                                          NumberFormat("\#0.# hour(s)"),
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          _value = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                  ),
                                ])))
                  ],
                ),
              ),
            )));
  }

  VerticalWeightSlider weightSlider() {
    return VerticalWeightSlider(
      isVertical: false,
      controller: _controller,
      decoration: const PointerDecoration(
        width: 70.0,
        height: 2.0,
        largeColor: Color(0xFF898989),
        mediumColor: Color(0xFFC5C5C5),
        smallColor: Color(0xFFF0F0F0),
        gap: 5.0,
      ),
      onChanged: (double value) {
        setState(() {
          _weight = value;
        });
      },
      indicator: Container(
        height: 3.0,
        width: 90.0,
        alignment: Alignment.centerLeft,
        color: Colors.red[300],
      ),
    );
  }

  void callThisMethod(bool isVisible) {
    debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
  }
}
