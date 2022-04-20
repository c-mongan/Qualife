import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../model/user_model.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../widgets/nuemorphic_button.dart';
import 'home_page.dart';

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({Key? key}) : super(key: key);

  static String id = 'check_in_page';

  @override
  _DailyCheckInPageState createState() => _DailyCheckInPageState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  late WeightSliderController _controller;
  double _weight = 60.0;

  Duration _duration = const Duration(hours: 8, minutes: 0);

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    _controller = WeightSliderController(
        initialWeight: _weight, minWeight: 0, interval: 0.1);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      setState(() {});
    });
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

  double _todayValue = 280;
  double _overallValue = 3;

  double startMood = 2;

  @override
  Widget build(BuildContext context) //=> Scaffold( {
  {
    return VisibilityDetector(
        key: Key(DailyCheckInPage.id),
        onVisibilityChanged: (VisibilityInfo info) {},
        child: Scaffold(
            appBar: AppBar(
              title: const Text(''),
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            bottomNavigationBar: CustomisedNavigationBar(),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
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
                            const SizedBox(
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
                              "${_weight.toStringAsFixed(2)} kg",
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            weightSlider(),
                            const SizedBox(
                              height: 50,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            const SizedBox(
                              height: 55,
                              child: Text(
                                "How long did you sleep?",
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
                            const SizedBox(
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
                            // Text((_duration.inHours).toStringAsFixed(2) +
                            //     " hours"),
                            const SizedBox(
                              height: 45,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            const SizedBox(
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
                            const SizedBox(
                              height: 45,
                            ),
                            SfSliderTheme(
                              data: SfSliderThemeData(
                                  thumbColor: Colors.white,
                                  thumbRadius: 15,
                                  thumbStrokeWidth: 2,
                                  thumbStrokeColor: activeColor,
                                  activeTrackColor: Colors.green,
                                  inactiveTrackColor: Colors.red,
                                  trackCornerRadius: 13),
                              child: SfSlider(
                                thumbIcon: const Icon(
                                    Icons.arrow_downward_sharp,
                                    color: Colors.black,
                                    size: 20.0),
                                min: 0.0,
                                max: 4.0,
                                value: startMood,
                                interval: 1,
                                stepSize: 1,
                                showTicks: true,
                                showLabels: true,
                                minorTicksPerInterval: 0,
                                numberFormat: NumberFormat("#0"),
                                labelFormatterCallback:
                                    (dynamic moodRating, String formattedText) {
                                  switch (moodRating) {
                                    case 0:
                                      return 'Angry';
                                    case 1:
                                      return 'Upset';
                                    case 2:
                                      return 'Nuetral ';
                                    case 3:
                                      return 'Content';
                                    case 4:
                                      return 'Optimistic';
                                  }
                                  return moodRating.toString();
                                },
                                onChanged: (dynamic val) {
                                  setState(() {
                                    startMood = val;
                                  });
                                },
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            NeumorphicButton(
                              child: const Text('Check In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                              onPressed: () {
                                // print(startMood.toString() + " Mood");
                                // print(_duration.toString() + " Sleep");
                                // print(_weight.toString() + " Weight");

                                FirebaseFirestore.instance
                                    .collection('DailyCheckIn')
                                    .add({
                                  'userID': loggedInUser.uid,
                                  'DateTime': DateTime.now(),
                                  'Mood': startMood,
                                  'Sleep': _duration.inMinutes / 60,
                                  'Weight': _weight,
                                });

                                Get.to(const HomePage());
                              },
                            ),

                            const SizedBox(
                              height: 150,
                            ),

                            // const Text(
                            //   'TODAY',
                            //   style: TextStyle(
                            //       fontSize: 10, fontWeight: FontWeight.w500),
                            // ),
                            // Text(
                            //   _todayValue.toStringAsFixed(0),
                            //   style: TextStyle(
                            //       fontSize: 26,
                            //       color: _todayValue < 200
                            //           ? Colors.red
                            //           : _todayValue < 300
                            //               ? Colors.amber
                            //               : _todayValue < 400
                            //                   ? const Color(0xffFB7D55)
                            //                   : const Color(0xff0DC9AB),
                            //       fontWeight: FontWeight.bold),
                            // )
                          ],
                        ),
                      ),
                    ),
                    // sleepLinearGaugeToday(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'OVERALL',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              _overallValue.toStringAsFixed(0),
                              style: TextStyle(
                                  fontSize: 26,
                                  color: _overallValue < 2
                                      ? Colors.red
                                      : _overallValue < 3
                                          ? Colors.amber
                                          : _overallValue < 4
                                              ? const Color(0xffFB7D55)
                                              : const Color(0xff0DC9AB),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                        sleepLinearGaugeOverall()
                      ],
                    ),
                  ],
                )))));
  }

  SfLinearGauge sleepLinearGaugeToday() {
    return SfLinearGauge(
        orientation: LinearGaugeOrientation.horizontal,
        minimum: 100.0,
        maximum: 500.0,
        interval: 50.0,
        animateAxis: true,
        animateRange: true,
        showLabels: false,
        showTicks: false,
        minorTicksPerInterval: 0,
        axisTrackStyle: const LinearAxisTrackStyle(
            thickness: 15, color: Colors.transparent),
        markerPointers: <LinearMarkerPointer>[
          LinearShapePointer(
              value: _todayValue,
              onChanged: (dynamic value) {
                setState(() {
                  _todayValue = value as double;
                });
              },
              height: 20,
              width: 20,
              color: _todayValue < 200
                  ? Colors.red
                  : _todayValue < 300
                      ? Colors.amber
                      : _todayValue < 400
                          ? const Color(0xffFB7D55)
                          : const Color(0xff0DC9AB),
              position: LinearElementPosition.cross,
              shapeType: LinearShapePointerType.circle),
          const LinearWidgetPointer(
            value: 150,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Poor',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const LinearWidgetPointer(
            value: 250,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Fair',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const LinearWidgetPointer(
            value: 350,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Good',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const LinearWidgetPointer(
            value: 450,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Excellent',
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
        ranges: const <LinearGaugeRange>[
          LinearGaugeRange(
            startValue: 100.0,
            endValue: 200,
            startWidth: 8,
            midWidth: 8,
            endWidth: 8,
            position: LinearElementPosition.cross,
            color: Colors.red,
          ),
          LinearGaugeRange(
            startValue: 200.0,
            endValue: 300,
            startWidth: 8,
            position: LinearElementPosition.cross,
            midWidth: 8,
            endWidth: 8,
            color: Colors.amber,
          ),
          LinearGaugeRange(
            startValue: 300.0,
            endValue: 400,
            position: LinearElementPosition.cross,
            startWidth: 8,
            midWidth: 8,
            endWidth: 8,
            color: Color(0xffFB7D55),
          ),
          LinearGaugeRange(
            startValue: 400.0,
            endValue: 500,
            position: LinearElementPosition.cross,
            startWidth: 8,
            midWidth: 8,
            endWidth: 8,
            color: Color(0xff0DC9AB),
          ),
        ]);
  }

  SizedBox sleepLinearGaugeOverall() {
    return SizedBox(
        child: SfLinearGauge(
            orientation: LinearGaugeOrientation.horizontal,
            minimum: 1,
            maximum: 5,
            interval: 1.0,
            animateAxis: true,
            animateRange: true,
            showTicks: false,
            showLabels: false,
            minorTicksPerInterval: 0,
            axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 15,
                edgeStyle: LinearEdgeStyle.bothFlat,
                color: Colors.transparent),
            markerPointers: <LinearMarkerPointer>[
          LinearShapePointer(
              value: _overallValue,
              onChanged: (dynamic value) {
                setState(() {
                  _overallValue = value as double;
                });
              },
              height: 20,
              width: 20,

              // color: _todayValue < 200
              //     ? Colors.red
              //     : _todayValue < 300
              //         ? Colors.amber
              //         : _todayValue < 400
              //             ? const Color(0xffFB7D55)
              //             : const Color(0xff0DC9AB),
              color: _overallValue < 2
                  ? Colors.red
                  : _overallValue <= 3
                      ? Colors.amber
                      : _overallValue <= 4
                          ? const Color(0xffFB7D55)
                          : const Color(0xff0DC9AB),
              position: LinearElementPosition.cross,
              shapeType: LinearShapePointerType.circle),
          const LinearWidgetPointer(
            value: 1.5,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Poor',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const LinearWidgetPointer(
            value: 2.50,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Fair',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const LinearWidgetPointer(
            value: 3.50,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Good',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const LinearWidgetPointer(
            value: 4.50,
            enableAnimation: false,
            position: LinearElementPosition.outside,
            offset: 4,
            child: Text(
              'Excellent',
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
            ranges: const <LinearGaugeRange>[
          LinearGaugeRange(
            startValue: 1.0,
            endValue: 2,
            startWidth: 8,
            midWidth: 8,
            position: LinearElementPosition.cross,
            endWidth: 8,
            color: Colors.red,
          ),
          LinearGaugeRange(
            startValue: 2.0,
            endValue: 3,
            startWidth: 8,
            midWidth: 8,
            endWidth: 8,
            position: LinearElementPosition.cross,
            color: Colors.amber,
          ),
          LinearGaugeRange(
            startValue: 3.0,
            endValue: 4,
            startWidth: 8,
            midWidth: 8,
            endWidth: 8,
            position: LinearElementPosition.cross,
            color: Color(0xffFB7D55),
          ),
          LinearGaugeRange(
            startValue: 4.0,
            endValue: 5,
            startWidth: 8,
            midWidth: 8,
            endWidth: 8,
            position: LinearElementPosition.cross,
            color: Color(0xff0DC9AB),
          ),
        ]));
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
