import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../model/user_model.dart';
import 'package:duration_picker/duration_picker.dart';

import '../widgets/nuemorphic_button.dart';

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
  double _weight = 60.0;

  Duration _duration = Duration(hours: 8, minutes: 0);

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

  double startMood = 2;

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
              title: const Text(''),
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
                                    "${_weight.toStringAsFixed(1)} kg",
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
                                  Text((_duration.inHours).toStringAsFixed(2) +
                                      " hours"),
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
                                      numberFormat: NumberFormat("\#0"),
                                      labelFormatterCallback:
                                          (dynamic moodRating,
                                              String formattedText) {
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
                                      print(startMood.toString() + " Mood");
                                      print(_duration.toString() + " Sleep");
                                      print(_weight.toString() + " Weight");
                                    },
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
