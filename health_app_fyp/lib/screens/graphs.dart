import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/colors&fonts.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pie_chart/pie_chart.dart';
import '../model/user_model.dart';
import '../widgets/glassmorphic_bottomnavbar.dart';
import 'login_screen.dart';

class CheckInGraph extends StatefulWidget {
  const CheckInGraph({Key? key}) : super(key: key);

  static String id = 'chartSlider';

  @override
  _GraphPageState createState() => _GraphPageState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();

class _GraphPageState extends State<CheckInGraph> {
  int key = 0;

  List<_DailyCheckIn_ChartData> moodChartData = <_DailyCheckIn_ChartData>[];

  TooltipBehavior? _tooltipBehavior;

  Future<void> getBMIDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("DailyCheckIn")
        .orderBy("DateTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    List<_DailyCheckIn_ChartData> list = snapShotsValue.docs
        .map((e) => _DailyCheckIn_ChartData(
            x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['DateTime'].millisecondsSinceEpoch),
            y: e.data()['Mood'],
            y2: e.data()['Weight'],
            y3: e.data()['Sleep']))
        .toList();
    if (mounted) {
      setState(() {
        moodChartData = list;
      });
    }
  }

  late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    super.initState();

    _zoomPanBehavior = ZoomPanBehavior(
        // Enables pinch zooming
        enablePinching: true,
        enableDoubleTapZooming: true,
        maximumZoomLevel: 0.8);

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      borderColor: Colors.grey,
      borderWidth: 5,
      color: Colors.black,
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      // check whether the state object is in tree
      getBMIDataFromFireStore().then((results) {
        SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
          if (mounted) {
            setState(() {
              key = 1;
            });
          }
          setState(() {});
        });
      });
      setPage();
    });
  }

  var today = DateTime.now();

  Future<void> setPage() async {}

  Color activeColor = Colors.white;
  Color inactiveColor = Colors.white;

  final double _max = 100.0;
  double _value = 60.0;

  @override
  Widget build(BuildContext context) //=> Scaffold( {
  {
    return VisibilityDetector(
        key: Key(CheckInGraph.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          //asyncMethod(isVisible);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Daily Check In Graph'),
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
                    child: Column(children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          // SizedBox(
                          //   height: 25,
                          //   child: Text(
                          //     "Your Personalised Graphs",
                          //     style: TextStyle(
                          //         fontSize: 25,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.grey),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // SizedBox(
                          //   height: 25,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // const Divider(
                  //   color: Colors.grey,
                  //   thickness: 2,
                  // ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                              height: 550,
                              child: SfCartesianChart(
                                  zoomPanBehavior: _zoomPanBehavior,
                                  tooltipBehavior: _tooltipBehavior,
                                  plotAreaBorderWidth: 0,
                                  title: ChartTitle(
                                      text: 'Daily Check In Graph',
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  legend: Legend(
                                      borderColor: Colors.white,
                                      borderWidth: 2,
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      isVisible: true,
                                      overflowMode:
                                          LegendItemOverflowMode.wrap),
                                  primaryXAxis: DateTimeAxis(
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift,
                                    majorGridLines:
                                        const MajorGridLines(width: 0),

                                    interval: 1,
                                    intervalType: DateTimeIntervalType.days,
                                    maximum: today,
                                    minimum: today.subtract(Duration(days: 7)),
                                    // majorGridLines: const MajorGridLines(
                                    //   color: Colors.grey,
                                    //   width: 0.1,
                                    // ),
                                    // isVisible: true,
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    majorTickLines: const MajorTickLines(
                                        color: Colors.transparent),
                                    isVisible: false,
                                    anchorRangeToVisiblePoints: false,
                                    labelStyle: const TextStyle(
                                      fontSize: 0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  series: <CartesianSeries>[
                                    StackedLineSeries<_DailyCheckIn_ChartData,
                                            DateTime>(
                                        dataSource: moodChartData,
                                        enableTooltip: false,
                                        color: BrightBlue,
                                        width: 2,
                                        name: "Mood",
                                        markerSettings: const MarkerSettings(
                                          isVisible: false,
                                          height: 0,
                                          width: 0,
                                          color: Colors.white,
                                          borderColor: Colors.white,
                                        ),
                                        xValueMapper:
                                            (_DailyCheckIn_ChartData data, _) =>
                                                data.x,
                                        yValueMapper:
                                            (_DailyCheckIn_ChartData data, _) =>
                                                data.y),
                                    StackedLineSeries<_DailyCheckIn_ChartData,
                                            DateTime>(
                                        dataSource: moodChartData,
                                        enableTooltip: true,

                                        // color: Color(0xff246EE9),
                                        color: BrightGreen,
                                        width: 2,
                                        name: "Weight (kg)",
                                        markerSettings: const MarkerSettings(
                                            isVisible: false,
                                            height: 2,
                                            width: 2,
                                            color: Colors.white,
                                            borderColor: Colors.white,
                                            shape: DataMarkerType.circle),
                                        xValueMapper:
                                            (_DailyCheckIn_ChartData data, _) =>
                                                data.x,
                                        yValueMapper:
                                            (_DailyCheckIn_ChartData data, _) =>
                                                data.y2),
                                    StackedLineSeries<_DailyCheckIn_ChartData,
                                            DateTime>(
                                        dataSource: moodChartData,
                                        enableTooltip: true,

                                        // color: Color(0xff246EE9),
                                        color: ScarletRed,
                                        width: 2,
                                        name: "Time Asleep (hours)",
                                        markerSettings: const MarkerSettings(
                                            isVisible: false,
                                            height: 2,
                                            width: 2,
                                            color: Colors.white,
                                            borderColor: Colors.white,
                                            shape: DataMarkerType.circle),
                                        xValueMapper:
                                            (_DailyCheckIn_ChartData data, _) =>
                                                data.x,
                                        yValueMapper:
                                            (_DailyCheckIn_ChartData data, _) =>
                                                data.y3),
                                  ]))))
                ])))));
  }
}

// Class for chart data source, this can be modified based on the data in Firestore
class _DailyCheckIn_ChartData {
  _DailyCheckIn_ChartData({this.x, this.y, this.y2, this.y3});
  final DateTime? x;
  final int? y;
  final num? y2;
  final num? y3;
}

void callThisMethod(bool isVisible) {
  debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
}
