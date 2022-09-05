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
import '../MoodTracker/activity.dart';
import '../model/user_model.dart';
import '../widgets/glassmorphic_bottomnavbar.dart';
import '../widgets/neumorphic_indicater.dart';
import 'graphs_land_page.dart';
import 'login_screen.dart';

class DisplayPieChart extends StatefulWidget {
  final String mood;
  DisplayPieChart({Key? key, required this.mood}) : super(key: key);

  static String id = 'chartSlider';

  @override
  _DisplayPieChartState createState() => _DisplayPieChartState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();
List<Activity> _activities = [];

class _DisplayPieChartState extends State<DisplayPieChart> {
  int key = 0;
  String? mood;

  String activityNameText = " ";

  Future<String> getLatestActivity() async {
    String Exc = "Error";

    DateTime todaysDate = DateTime.now();
    DateTime weekAgoDate =
        DateTime.utc(todaysDate.year, todaysDate.month, todaysDate.day - 7);

    try {
      final latestActivityName = await FirebaseFirestore.instance
          .collection('ActivityTracking')
          .orderBy('DateTime')
          .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('Mood', isEqualTo: widget.mood)
          .get();

      for (var actName in latestActivityName.docs) {
        activityNameText = latestActivityName.docs[0].get("Activity");

        String firestoreActivityText = activityNameText;

        return firestoreActivityText;
      }

      return activityNameText;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  void setActivityResult() async {
    getLatestActivity().then((firestoreActivityText) {
      activityNameText = firestoreActivityText;
    });
  }

  @override
  void initState() {
    super.initState();

    DateTime todaysDate = DateTime.now();

    DateTime.utc(todaysDate.year, todaysDate.month, todaysDate.day - 1);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      if (mounted) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            setState(() {
              key = 1;
            });
          }
          setState(() {});
        });
        getLatestActivity();
        getActivityData();
        pieChartActivity();
      }
    });
  }

  Widget pieChartActivity() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getActivityData(),
      initialAngleInDegree: 0,
      animationDuration: const Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      chartLegendSpacing: 32,
      chartValuesOptions: const ChartValuesOptions(
          decimalPlaces: 0,
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      centerText: 'Activities',
      legendOptions: const LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  void asyncMethod(bool isVisible) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      if (mounted) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            setState(() {
              key = 1;
            });
          }
          setState(() {});
        });
        getLatestActivity();
        pieChartActivity();
      }
    });
  }

  @override
  Widget build(BuildContext context) //=> Scaffold( {
  {
    return VisibilityDetector(
        key: Key(GraphsHome.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          asyncMethod(isVisible);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.mood),
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
                              children: <Widget>[
                                Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                                Text(
                                    "Below are your activities associated with the mood : ${widget.mood}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 100),
                                activityPieChart(),
                                SizedBox(height: 100),
                              ])))
                ])))));
  }

  StreamBuilder<Object> activityPieChart() {
    Stream<QuerySnapshot<Map<String, dynamic>>> activityStream;

    DateTime todaysDate = DateTime.now();

    activityStream = FirebaseFirestore.instance
        .collection('ActivityTracking')
        .orderBy("DateTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('Mood', isEqualTo: widget.mood)
        .snapshots();

    return StreamBuilder<Object>(
        stream: activityStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                height: 45,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: NeumorphicProgressIndicator(
                        indicatorColor: Colors.indigo,
                      ),
                    ),
                  ],
                ));
          }

          if (snapshot.data == null) {
            return const Text("Empty List Error");
          } else {
            final data = snapshot.requireData;

            getActivityListfromSnapshot(data);

            getLatestActivity();

            if (activityNameText != " ") {
              return pieChartActivity();
            } else {
              return const Text("No activities logged yet",
                  style: TextStyle(fontSize: 15, color: Colors.white));
            }
          }
        });
  }

  void getActivityListfromSnapshot(snapshot) {
    if (snapshot.docs.isNotEmpty) {
      _activities = [];
      for (int i = 0; i < snapshot.docs.length; i++) {
        var a = snapshot.docs[i];

        Activity activity = Activity.fromJson(a.data());
        _activities.add(activity);
      }
    }
  }

  Map<String, double> getActivityData() {
    Map<String, double> actMap = {};

    for (var act in _activities) {
      if (actMap.containsKey(act.activity) == false) {
        actMap[act.activity] = 1;
      } else {
        actMap.update(act.activity, (int) => actMap[act.activity]! + 1);
      }
    }
    return actMap;
  }
}

class Activity {
  late String activity;

  Activity({
    required this.activity,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activity: json['Activity'] ?? "",
    );
  }
}
