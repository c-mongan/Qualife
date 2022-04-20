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
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pie_chart/pie_chart.dart';
import '../model/user_model.dart';
import '../widgets/glassmorphic_bottomnavbar.dart';
import 'login_screen.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  static String id = 'chartSlider';

  @override
  _GraphPageState createState() => _GraphPageState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();

class _GraphPageState extends State<GraphPage> {
  int key = 0;

  List<_ChartData> chartData = <_ChartData>[];

  late List<num> _xValues;
  late List<num> _yValues;
  List<double> _xPointValues = <double>[];
  List<double> _yPointValues = <double>[];

  TooltipBehavior? _tooltipBehavior;

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("BMI")
        .orderBy("bmiTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) => _ChartData(
            x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['bmiTime'].millisecondsSinceEpoch),
            y: e.data()['bmiScore']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      if (mounted) {
        // check whether the state object is in tree
        getDataFromFireStore().then((results) {
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            setState(() {});
          });
        });
        setPage();
      }
    });

    void asyncMethod(bool isVisible) async {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());

        if (mounted) {
          getDataFromFireStore().then((results) {
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              setState(() {});
            });
          });
          setPage();
        }
      });
    }
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
        key: Key(GraphPage.id),
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
                          SizedBox(
                            height: 25,
                            child: Text(
                              "Your Personalised Graphs",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                              //height: MediaQuery.of(context).size.height * 0.5,
                              // width: MediaQuery.of(context).size.width * 0.9,
                              height: 550,
                              child: SfCartesianChart(
                                  borderColor: Colors.white,
                                  borderWidth: 2,
                                  // Sets 5 logical pixels as margin for all the 4 sides.
                                  margin: const EdgeInsets.all(5),
                                  plotAreaBackgroundColor: Colors.black,
                                  title: ChartTitle(
                                      text: 'BMI In the Past Week',
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  legend: Legend(
                                      borderColor: Colors.transparent,
                                      borderWidth: 2,
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      isVisible: true,
                                      overflowMode:
                                          LegendItemOverflowMode.wrap),
                                  primaryXAxis: DateTimeAxis(
                                    //autoScrollingDelta: ,
                                    autoScrollingMode: AutoScrollingMode.start,
                                    autoScrollingDeltaType:
                                        DateTimeIntervalType.months,
                                    interval: 1,
                                    intervalType: DateTimeIntervalType.days,
                                    // maximum: today,
                                    // minimum: today.subtract(Duration(days: 7)),
                                    majorGridLines: MajorGridLines(
                                        color: Colors.white, width: 0.5),
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    anchorRangeToVisiblePoints: false,
                                    plotBands: <PlotBand>[
                                      PlotBand(
                                        isVisible: true,
                                        start: 18.5,
                                        end: 25,
                                        color: Colors.green,
                                        text: "Normal",
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      PlotBand(
                                        isVisible: true,
                                        start: 0,
                                        end: 18.5,
                                        color: Colors.red,
                                        text: "Underweight",
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      PlotBand(
                                        isVisible: true,
                                        start: 25.1,
                                        end: 30,
                                        color: Colors.yellow,
                                        text: "Overweight",
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      PlotBand(
                                        isVisible: true,
                                        start: 30.1,
                                        end: 1000,
                                        color: Colors.red,
                                        text: "Obese",
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      )
                                    ],

                                    interval: 10,
                                    //desiredIntervals: 5,
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                    //Hides Gridlines
                                    //majorGridLines: MajorGridLines(width: 0),
                                  ),
                                  series: <ChartSeries<_ChartData, DateTime>>[
                                    LineSeries<_ChartData, DateTime>(
                                        dataSource: chartData,
                                        // color: Color(0xff246EE9),
                                        color: Colors.purple,
                                        width: 2,
                                        name: "BMI",
                                        markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            height: 2,
                                            width: 2,
                                            color: Colors.white,
                                            borderColor: Colors.white,
                                            shape: DataMarkerType.circle),
                                        xValueMapper: (_ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (_ChartData data, _) =>
                                            data.y),
                                  ]))))
                ])))));
  }
}

// Class for chart data source, this can be modified based on the data in Firestore
class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final double? y;
}

class bmiData {
  bmiData(this.bmiTime, this.bmiScore);
  final DateTime bmiTime;
  final double bmiScore;
}

void callThisMethod(bool isVisible) {
  debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
}
