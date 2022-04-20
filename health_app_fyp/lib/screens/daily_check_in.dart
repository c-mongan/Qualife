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
                            height: 250,
                            width: 250,
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
                              thumbIcon: const Icon(Icons.arrow_downward_sharp,
                                  color: Colors.black, size: 20.0),
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
                      sleepLinearGaugeOverall(),
                    ],
                  ),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                        DateTime.now().day.toString() +
                            "/" +
                            DateTime.now().month.toString(),
                        style: TextStyle(fontSize: 14)),
                  ),

                  const SizedBox(height: 15),
                  SizedBox(
                    height: 220,
                    child: SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                          showFirstLabel: false,
                          axisLineStyle: AxisLineStyle(
                              thickness: 0.03,
                              thicknessUnit: GaugeSizeUnit.factor,
                              color: Colors.lightBlue[50]),
                          minorTicksPerInterval: 10,
                          majorTickStyle: const MajorTickStyle(length: 10),
                          minimum: 0,
                          maximum: 12,
                          interval: 3,
                          startAngle: 90,
                          endAngle: 90,
                          onLabelCreated: (AxisLabelCreatedArgs args) {
                            if (args.text == '6') {
                              args.text = '12';
                            } else if (args.text == '9') {
                              args.text = '3';
                            } else if (args.text == '12') {
                              args.text = '6';
                            } else if (args.text == '3') {
                              args.text = '9';
                            }
                          },
                          pointers: <GaugePointer>[
                            WidgetPointer(
                                enableDragging: true,
                                value: _wakeupTimeValue,
                                onValueChanged: _handleWakeupTimeValueChanged,
                                onValueChanging: _handleWakeupTimeValueChanging,
                                onValueChangeStart: _handleWakeupTimeValueStart,
                                onValueChangeEnd: _handleWakeupTimeValueEnd,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.2),
                                          offset: Offset.zero,
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.1),
                                        style: BorderStyle.solid,
                                        width: 0.0,
                                      )),
                                  height: _wakeupTimePointerHeight,
                                  width: _wakeupTimePointerWidth,
                                  child: const Center(
                                      child: Icon(
                                    Icons.bedtime,
                                    size: 15,
                                    color: Colors.white,
                                  )),
                                )),
                            WidgetPointer(
                              enableDragging: true,
                              value: _bedTimeValue,
                              onValueChanged: _handleBedTimeValueChanged,
                              onValueChanging: _handleBedTimeValueChanging,
                              onValueChangeStart: _handleBedTimeValueStart,
                              onValueChangeEnd: _handleBedTimeValueEnd,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset.zero,
                                        blurRadius: 4.0,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.1),
                                      style: BorderStyle.solid,
                                      width: 0.0,
                                    )),
                                height: _bedTimePointerHeight,
                                width: _bedTimePointerWidth,
                                child: const Center(
                                    child: Icon(
                                  Icons.wb_sunny,
                                  color: Colors.white,
                                  size: 15,
                                )),
                              ),
                            ),
                          ],
                          ranges: <GaugeRange>[
                            GaugeRange(
                                endValue: _bedTimeValue,
                                sizeUnit: GaugeSizeUnit.factor,
                                startValue: _wakeupTimeValue,
                                color: Colors.blue,
                                startWidth: 0.03,
                                endWidth: 0.03)
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: SizedBox(
                                  width: 300,
                                  height: 200,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      AnimatedPositioned(
                                        right: 80,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.decelerate,
                                        child: AnimatedOpacity(
                                          opacity: _isWakeupTime ? 1.0 : 0.0,
                                          duration:
                                              (_isWakeupTime && _isBedTime)
                                                  ? const Duration(
                                                      milliseconds: 800)
                                                  : const Duration(
                                                      milliseconds: 200),
                                          child: CustomAnimatedBuilder(
                                            value: 1.3,
                                            curve: Curves.decelerate,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            builder: (BuildContext context,
                                                    Widget? child,
                                                    Animation<dynamic>
                                                        animation) =>
                                                Transform.scale(
                                              scale: animation.value,
                                              child: child,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  (DateTime.now().day - 1)
                                                          .toString() +
                                                      '/' +
                                                      DateTime.now()
                                                          .month
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _wakeupTimeAnnotation,
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      AnimatedOpacity(
                                        opacity: (_isBedTime && _isWakeupTime)
                                            ? 1.0
                                            : 0.0,
                                        duration: (_isWakeupTime && _isBedTime)
                                            ? const Duration(milliseconds: 800)
                                            : const Duration(milliseconds: 200),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 16.0),
                                          child: const Text(
                                            '-',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        left: 83,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.decelerate,
                                        child: AnimatedOpacity(
                                          opacity: _isBedTime ? 1.0 : 0.0,
                                          duration:
                                              (_isWakeupTime && _isBedTime)
                                                  ? const Duration(
                                                      milliseconds: 800)
                                                  : const Duration(
                                                      milliseconds: 200),
                                          child: CustomAnimatedBuilder(
                                            value: 1.3,
                                            curve: Curves.decelerate,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            builder: (BuildContext context,
                                                    Widget? child,
                                                    Animation<dynamic>
                                                        animation) =>
                                                Transform.scale(
                                              scale: animation.value,
                                              child: child,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  DateTime.now()
                                                          .day
                                                          .toString() +
                                                      "/" +
                                                      DateTime.now()
                                                          .month
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    // fontSize:

                                                    //  isWebOrDesktop
                                                    //     ? 24
                                                    //     : isCardView
                                                    //         ? 14
                                                    //         : 10,

                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  _bedTimeAnnotation,
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                    // fontSize: isWebOrDesktop
                                                    //     ? 28
                                                    //     : isCardView
                                                    //         ? 20
                                                    //         : 16
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                positionFactor: 0.05,
                                angle: 0),
                          ])
                    ]),
                  ),
                  // if (!isCardView) const SizedBox(height: 15),
                  // if (!isCardView)
                  Text(
                    _sleepMinutes == '00'
                        ? '$_sleepHours hrs'
                        : '$_sleepHours hrs ' '$_sleepMinutes mins',
                    style: TextStyle(
                        // fontSize: isCardView ? 14 : 20,
                        fontWeight: FontWeight.w500),
                  ),
                  // if (!isCardView) const SizedBox(height: 15),
                  Text(
                    'Sleep time',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          )),
    );
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

  /// Dragged pointer new value is updated to range.
  void _handleWakeupTimeValueChanged(double value) {
    setState(() {
      _wakeupTimeValue = value;
      final int _value = _wakeupTimeValue.abs().toInt();
      final int _hourValue = _value;
      final List<String> _minList =
          _wakeupTimeValue.toStringAsFixed(2).split('.');
      double _currentMinutes = double.parse(_minList[1]);
      _currentMinutes = (_currentMinutes * 60) / 100;
      final String _minutesValue = _currentMinutes.toStringAsFixed(0);

      final double hour = (_hourValue >= 0 && _hourValue <= 6)
          ? (_hourValue + 6)
          : (_hourValue >= 6 && _hourValue <= 12)
              ? _hourValue - 6
              : 0;
      final String hourValue = hour.toString().split('.')[0];

      _wakeupTimeAnnotation = ((hour >= 6 && hour < 10)
              ? '0' + hourValue
              : hourValue) +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue) +
          (_hourValue >= 6 ? ' pm' : ' pm');

      _wakeupTime = (_hourValue + 6 < 10
              ? '0' + _hourValue.toString()
              : _hourValue.toString()) +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue);

      final DateFormat dateFormat = DateFormat('HH:mm');
      final DateTime _wakeup = dateFormat.parse(_wakeupTime);
      final DateTime _sleep =
          dateFormat.parse(_bedTime == '09:00 pm' ? '12:00' : _bedTime);
      final String _sleepDuration = _sleep.difference(_wakeup).toString();
      _sleepHours = _sleepDuration.split(':')[0];
      _sleepMinutes = _sleepDuration.split(':')[1];
    });
  }

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleWakeupTimeValueChanging(ValueChangingArgs args) {
    if (args.value >= 6 && args.value < 12) {
      args.cancel = true;
    }

    _wakeupTimePointerWidth = _wakeupTimePointerHeight = 40.0;
  }

  /// Cancelled the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleBedTimeValueChanging(ValueChangingArgs args) {
    if (args.value >= 0 && args.value < 6) {
      args.cancel = true;
    }

    _bedTimePointerWidth = _bedTimePointerHeight = 40.0;
  }

  /// Dragged pointer new value is updated to range.
  void _handleBedTimeValueChanged(double value) {
    setState(() {
      _bedTimeValue = value;
      final int _value = _bedTimeValue.abs().toInt();
      final int _hourValue = _value;

      final List<String> _minList = _bedTimeValue.toStringAsFixed(2).split('.');
      double _currentMinutes = double.parse(_minList[1]);
      _currentMinutes = (_currentMinutes * 60) / 100;
      final String _minutesValue = _currentMinutes.toStringAsFixed(0);

      _bedTimeAnnotation = ((_hourValue >= 0 && _hourValue <= 6)
              ? (_hourValue + 6).toString()
              : (_hourValue >= 6 && _hourValue <= 12)
                  ? '0' + (_hourValue - 6).toString()
                  : '') +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue) +
          (_value >= 6 ? ' am' : ' pm');

      _bedTime = (_hourValue < 10
              ? '0' + _hourValue.toString()
              : _hourValue.toString()) +
          ':' +
          (_minutesValue.length == 1 ? '0' + _minutesValue : _minutesValue);

      final DateFormat dateFormat = DateFormat('HH:mm');
      final DateTime _wakeup =
          dateFormat.parse(_wakeupTime == '06:00 am' ? '03:00' : _wakeupTime);
      final DateTime _sleep = dateFormat.parse(_bedTime);
      final String _sleepDuration = _sleep.difference(_wakeup).toString();
      _sleepHours = _sleepDuration.split(':')[0];
      _sleepMinutes = _sleepDuration.split(':')[1];
    });
  }

  void _handleWakeupTimeValueStart(double value) {
    _isBedTime = false;
  }

  void _handleWakeupTimeValueEnd(double value) {
    setState(() {
      _isBedTime = true;
    });

    _wakeupTimePointerWidth = _wakeupTimePointerHeight = 30.0;
  }

  void _handleBedTimeValueStart(double value) {
    _isWakeupTime = false;
  }

  void _handleBedTimeValueEnd(double value) {
    setState(() {
      _isWakeupTime = true;
    });

    _bedTimePointerWidth = _bedTimePointerHeight = 30.0;
  }

  double _wakeupTimeValue = 3;
  double _bedTimeValue = 12;
  String _wakeupTimeAnnotation = '09:00 pm';
  String _bedTimeAnnotation = '06:00 am';
  bool _isWakeupTime = true;
  bool _isBedTime = true;
  String _sleepHours = '9';
  String _sleepMinutes = '00';
  String _bedTime = '09:00 pm';
  String _wakeupTime = '06:00 am';
  double _bedTimePointerWidth = 30.0;
  double _bedTimePointerHeight = 30.0;
  double _wakeupTimePointerWidth = 30.0;
  double _wakeupTimePointerHeight = 30.0;
}

/// Widget of custom animated builder.
class CustomAnimatedBuilder extends StatefulWidget {
  /// Creates a instance for [CustomAnimatedBuilder].
  const CustomAnimatedBuilder({
    Key? key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.child,
  }) : super(key: key);

  /// Specifies the animation duration.
  final Duration duration;

  /// Specifies the curve of animation.
  final Curve curve;

  /// Specifies the animation controller value.
  final double value;

  /// Specifies the child widget.
  final Widget? child;

  /// Specifies the builder function.
  final Widget Function(
    BuildContext context,
    Widget? child,
    Animation<dynamic> animation,
  ) builder;

  @override
  _CustomAnimatedBuilderState createState() => _CustomAnimatedBuilderState();
}

class _CustomAnimatedBuilderState extends State<CustomAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: widget.value,
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomAnimatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _animationController.animateTo(
        widget.value,
        duration: widget.duration,
        curve: widget.curve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) => widget.builder(
        context,
        widget.child,
        _animationController,
      ),
    );
  }
}
