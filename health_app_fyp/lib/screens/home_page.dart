import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';
import 'package:health_app_fyp/screens/daily_check_in.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:health_app_fyp/widgets/logout_button.dart';
import 'package:health_app_fyp/widgets/nuemorphic_button.dart';
// Removed unused imports (intl, charts, datadog) to fix lint warnings.
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pie_chart/pie_chart.dart';
import '../model/user_model.dart';
import '../widgets/neumorphic_indicater.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static String id = 'chartSlider';

  @override
  _HomePageState createState() => _HomePageState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();

bool? showCheckIn;

class _HomePageState extends State<HomePage> {
  int key = 0;

  Future<Timestamp> getLastDailyCheckInDay() async {
    try {
      final calsdate = await FirebaseFirestore.instance
          .collection('DailyCheckIn')
          .orderBy('DateTime')
          .limit(1)
          .where("userID", isEqualTo: uid)
          .where(
            'DateTime',
            isGreaterThanOrEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              0,
              0,
            ),
          )
          .where(
            'DateTime',
            isLessThanOrEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              23,
              59,
              59,
            ),
          )
          .get();
      if (calsdate.docs.isNotEmpty) {
        return calsdate.docs.first.get('DateTime') as Timestamp;
      }
      return Timestamp(0, 0);
    } catch (e) {
      debugPrint('getLastDailyCheckInDay error: $e');
      return Timestamp(0, 0);
    }
  }

  double lastWeight = 0;

  double _weight = 0;

  void setLastWeight() async {
    getLastWeight().then((firestoreLastWeightText) {
      lastWeight = firestoreLastWeightText;
    });
  }

  String dayCals = "";

  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<Timestamp> getLastCalsRemainingDay() async {
    try {
      final calsdate = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      if (calsdate.docs.isNotEmpty) {
        return calsdate.docs.first.get('DateTime') as Timestamp;
      }
      return Timestamp(0, 0);
    } catch (e) {
      debugPrint('getLastCalsRemainingDay error: $e');
      return Timestamp(0, 0);
    }
  }

  Future<double> getTdeeVal() async {
    try {
      final tdeevals = await FirebaseFirestore.instance
          .collection('TDEE')
          .orderBy('tdeeTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      if (tdeevals.docs.isNotEmpty) {
        return (tdeevals.docs.first.get('tdee') as num).toDouble();
      }
      return 0;
    } catch (e) {
      debugPrint('getTdeeVal error: $e');
      return 0;
    }
  }

  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool isAfterToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }

  void checkDay(showCheckIn) {
    // getLastCalsRemainingDay().then((time) {
    //   isAfterToday(time);

    //   if (isAfterToday(time)) {
    //     getTdeeVal().then((tdee) {
    //       print("Its before today");

    //       FirebaseFirestore.instance.collection('endDayOfCalories').add({
    //         'userID': uid,
    //         'Cals': tdee,
    //         'DateTime': time,
    //       });

    //   showCheckInButton(tempdate);
    // });
  }

  // Future<String> showCheckInButton() async {
  //   getLastDailyCheckInDay().then((time) {
  //     DateTime lastdate =
  //         DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);

  //     print(lastdate.day.toString());

  //     final today = DateTime.now();

  //     print(today.day.toString());

  //     if (lastdate.day == today.day) {
  //       return "false";
  //     } else if (lastdate.day != today.day) {
  //       return "true";
  //     }
  //   });

  //   print("error ");
  //   return "error";
  // }

  Future<double> getLastWeight() async {
  // Retrieve latest weight difference entry.

    try {
      final latestDailyCheckInDoc = await FirebaseFirestore.instance
          .collection('DailyCheckIn')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      for (var _ in latestDailyCheckInDoc.docs) {
        lastWeight = latestDailyCheckInDoc.docs[0].get("WeightDifference");

        double firestoreLastWeight = lastWeight;

        setLastWeight();

        // print(lastWeight);
        return firestoreLastWeight;
      }
      return lastWeight;
    } catch (Exc) {
      rethrow;
    }
  }

  ListTile getWeightChanges() {
    return ListTile(
        title: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: <TextSpan>[
        const TextSpan(
            text: "Your weight has fluctuated by: ",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        TextSpan(
            text: _weight.toStringAsFixed(2) + "kg",
            style: TextStyle(
                color: setColorValue(_weight),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const TextSpan(
            text: " since your last check-in.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ]),
    ));
  }

  @override
  void initState() {
    super.initState();

    // bool showCheckIn = false;

    // showCheckInButton();

    //checkDay(showCheckIn);

    getRecentDailyCheckIn();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

// final myLogger = DatadogSdk.instance.createLogger(
//   LoggingConfiguration({
//     loggerName: 'Additional logger'
//   })
// );

// myLogger.info('Info from my additional logger.');

//    ddLogger = DdLogs(loggerName: 'orders');
// // optionally set a value for HOST
// // ddLogger.addAttribute('hostname', <DEVICE IDENTIFIER>);

// ddLogger.addTag('restaurant_type', 'pizza');
// ddLogger.removeTag('restaurant_type');

// // add attribute to every log
// ddLogger.addAttribute('toppings', 'extra_cheese');

// // add atttributes to some logs
// ddLogger.log('time to cook pizza', Level.FINE, attributes: {
//   'durationInMilliseconds': timer.elapsedMilliseconds,
// });

      getLastWeight().then((value) => setState(() => _weight = value));
      setColorValue(_weight);

      if (mounted) {
        // check whether the state object is in tree
        getDataFromFireStore().then((results) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {});
          });
        });
        setPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(HomePage.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          asyncMethod(isVisible);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
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
                          SizedBox(
                            height: 25,
                            child: Text(
                              "Welcome ${loggedInUser.firstName}!",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                              "Your Name: ${loggedInUser.firstName} ${loggedInUser.secondName}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                          Text("Your E-mail: ${loggedInUser.email}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                          const SizedBox(
                            height: 25,
                          ),
                          // if (showCheckInButton() == "true") ...[

                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('DailyCheckIn')
                                  .where('DateTime',
                                      isGreaterThanOrEqualTo: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          0,
                                          0))
                                  .where('DateTime',
                                      isLessThanOrEqualTo: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          23,
                                          59,
                                          59))
                                  .where("userID", isEqualTo: uid)
                                  // .where("DateTime", isGreaterThan: dateToday)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.docs.length == 1) {
                                  // return const Text(
                                  //   ("Daily Check-in completed!"),
                                  //   style: TextStyle(
                                  //     //  fontSize: 15.0,
                                  //     color: Colors.white,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // );

                                  return Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.transparent,
                                    ),
                                  );
                                } else if (snapshot.hasData ||
                                    snapshot.data?.docs.length == 0) {
                                  return NeumorphicButton(
                                    child: const Text('Check In',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    onPressed: () {
                                      Get.to(const DailyCheckInPage());
                                    },
                                  );
                                } else if (snapshot.data?.docs.isEmpty ??
                                    true) {
                                  return NeumorphicButton(
                                    child: const Text('Check In',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    onPressed: () {
                                      Get.to(const DailyCheckInPage());
                                    },
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              })

                          // NeumorphicButton(
                          //   child: const Text('Check In',
                          //       style: TextStyle(
                          //           color: Colors.white, fontSize: 15)),
                          //   onPressed: () {
                          //     Get.to(const DailyCheckInPage());
                          //   },

                          //     //   ] else if (showCheckInButton() == "false") ...[
                          //     //     const SizedBox(
                          //     //       height: 25,
                          //     //       child: Text("You have checked In"),
                          //     //     ),
                          //     //   ],
                          //   )
                          // )
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
                          child: Column(children: [
                            SizedBox(
                                height: 80.0, child: caloriesRemainingTile()),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            bmiResultIndication(),
                            SizedBox(height: 100, child: bmiSlider()),
                            const SizedBox(height: 20),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),

                            // getWeightDifference(),

                            // const Divider(
                            //   color: Colors.grey,
                            //   thickness: 2,
                            // ),
                            SizedBox(
                              height: 40,
                              child: ListTile(
                                  title: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Mood Tracker",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ]),
                              )),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Center(
                                  child: moodPieChart(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            ),
                            // SizedBox(
                            //   height: 40,
                            //   child: ListTile(
                            //       title: RichText(
                            //     textAlign: TextAlign.center,
                            //     text: const TextSpan(children: <TextSpan>[
                            //       TextSpan(
                            //           text:
                            //               "Activities Logged in the last 7 days",
                            //           style: TextStyle(
                            //               color: Colors.white, fontSize: 20)),
                            //     ]),
                            //   )),
                            // ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Center(
                                    //  child: activityPieChart(),
                                    ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(
                              height: 20,
                            ),

                            LogOutButton(
                              onPressed: () {
                                logout(context);
                              },
                              child: const Text(
                                "Log Out",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )
                          ])))
                ])))));
  }

  SizedBox getWeightDifference() {
    return SizedBox(
        height: 60.0,
        child: StreamBuilder<QuerySnapshot>(
          stream: weightStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Error loading weight changes: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Loading last check-in...",
                style: TextStyle(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                'No check-ins yet. Tap Check In to create your first entry.',
                style: TextStyle(color: Colors.white),
              );
            }

            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final raw = document.data();
                if (raw == null) {
                  return const ListTile(
                    title: Text(
                      'Missing weight data.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                Map<String, dynamic> data = raw as Map<String, dynamic>;
                final num diff = data['WeightDifference'] ?? 0;
                final bool diffIsInt = isInteger(diff);
                return ListTile(
                  title: const Text("Your weight has fluctuated by:",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing: Text(
                    diffIsInt
                        ? "${diff.toInt()} kg"
                        : "${(diff is double ? diff : diff.toDouble()).toStringAsFixed(2)} kg",
                    style: TextStyle(
                        color: setColorValue(_weight),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }

  // SfCartesianChart bmiOverTimeGraph() {
  //   return SfCartesianChart(
  //       title: ChartTitle(
  //           text: 'BMI over time',
  //           textStyle: const TextStyle(color: Colors.white, fontSize: 20)),
  //       legend:
  //           Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
  //       primaryXAxis: DateTimeAxis(
  //         edgeLabelPlacement: EdgeLabelPlacement.shift,
  //         dateFormat: DateFormat('dd/MM'),
  //         intervalType: DateTimeIntervalType.days,
  //         interval: 14,
  //       ),
  //       primaryYAxis: NumericAxis(),
  //       series: <ChartSeries<_ChartData, DateTime>>[
  //         LineSeries<_ChartData, DateTime>(
  //             dataSource: chartData,
  //             width: 2,
  //             name: "BMI",
  //             markerSettings: const MarkerSettings(isVisible: true),
  //             xValueMapper: (_ChartData data, _) => data.x,
  //             yValueMapper: (_ChartData data, _) => data.y),
  //       ]);
  // }

  StreamBuilder<Object> moodPieChart() {
    return StreamBuilder<Object>(
        stream: moodPieChartStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Error loading mood data: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Text(
              "No mood data found. Log a mood in Daily Check In to see stats.",
              style: TextStyle(color: Colors.white),
            );
          }
          final docs = (snapshot.data as dynamic)?.docs;
          if (docs == null || docs.isEmpty) {
            return const Text(
              "No moods logged yet. Use the Check In button to add your first mood.",
              style: TextStyle(fontSize: 15, color: Colors.white),
            );
          }
          final data = snapshot.requireData;
          getMoodsListfromSnapshot(data);
          getLatestMood();
          if (moodNameText.isNotEmpty) {
            return pieChartMood();
          }
          return const Text(
            "No moods logged yet. Use the Check In button to add your first mood.",
            style: TextStyle(fontSize: 15, color: Colors.white),
          );
        });
  }

  SfSliderTheme bmiSlider() {
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeLabelStyle: TextStyle(
            color: activeColor, fontSize: 12, fontStyle: FontStyle.italic),
        inactiveLabelStyle: TextStyle(
            color: inactiveColor, fontSize: 12, fontStyle: FontStyle.italic),
        thumbColor: Colors.white,
        thumbRadius: 15,
        thumbStrokeWidth: 2,
        thumbStrokeColor: activeColor,
        activeTrackColor: activeColor,
        inactiveTrackColor: inactiveColor,
      ),
      child: SfSlider(
        thumbIcon: Icon(Icons.keyboard_arrow_right_outlined,
            color: activeColor, size: 20.0),
        min: 0,
        max: 50,
        value: bmiScore,
        interval: 5,
        showLabels: true,
        showTicks: true,
        onChanged: (bmiScore) {
          setState(() {
            bmiScore = bmiScore;
          });
        },
      ),
    );
  }

  ListTile bmiResultIndication() {
    return ListTile(
        title: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: <TextSpan>[
        const TextSpan(
            text: "Your BMI Score of ",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        TextSpan(
            text: bmiScore.toStringAsFixed(1),
            style: TextStyle(
                color: activeColor, fontSize: 20, fontWeight: FontWeight.bold)),
        const TextSpan(
            text: " indicates that you are ",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
        TextSpan(
            text: bmiResultText,
            style: TextStyle(
              color: activeColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ]),
    ));
  }

  StreamBuilder<QuerySnapshot<Object?>> caloriesRemainingTile() {
    return StreamBuilder<QuerySnapshot>(
      stream: calsRemainingStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Error loading calories: ${snapshot.error}',
            style: const TextStyle(color: Colors.white),
          );
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
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            'No calorie data yet. Complete the TDEE setup to initialize your daily allowance.',
            style: TextStyle(color: Colors.white),
          );
        }
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            final raw = document.data();
            if (raw == null) {
              return const ListTile(
                title: Text(
                  'Calorie entry missing data.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            Map<String, dynamic> data = raw as Map<String, dynamic>;
            final num calsNum = data['Cals'] ?? 0;
            return ListTile(
                title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                const TextSpan(
                    text: "You have ",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                TextSpan(
                    text: (calsNum is double ? calsNum : calsNum.toDouble())
                        .toStringAsFixed(0),
                    style: TextStyle(
                        color: setColorValue(calsNum.toDouble()),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const TextSpan(
                    text: " calories remaining for today ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ]),
            ));
          }).toList(),
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> lastMoodCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: moodCardStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return NeumorphicProgressIndicator(
          //     indicatorColor: Colors.indigo);
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

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
                leading: DisplayMoodIcon(
                  image: data['Icon'],
                ),
                isThreeLine: true,
                title: Text(
                  data['Mood'],
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  data['Activities'].toString().substring(
                          1, data['Activities'].toString().length - 1) +
                      "             " +
                      data['DateOfMood'] +
                      " " +
                      data['TimeOfMood'],
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ));
          }).toList(),
        );
      },
    );
  }

  void asyncMethod(bool isVisible) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      // showCheckInButton();

      // checkDay(showCheckIn);

      if (mounted) {
        getLastWeight().then((value) => setState(() => _weight = value));
        setColorValue(_weight);
        //getWeightChanges();
        getDataFromFireStore().then((results) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {});
          });
        });
      }
    });
  }

  var today = DateTime.now();

  List<Mood> _moods = [];

  List<_ChartData> chartData = <_ChartData>[];

  Map<String, double> getMoodData() {
    Map<String, double> catMap = {};

    for (var item in _moods) {
      if (catMap.containsKey(item.mood) == false) {
        catMap[item.mood] = 1;
      } else {
        catMap.update(item.mood, (int) => catMap[item.mood]! + 1);
      }
    }
    return catMap;
  }

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  List<Color> colorList = [
    const Color.fromRGBO(82, 98, 255, 1),
    const Color.fromARGB(255, 77, 46, 255),
    const Color.fromRGBO(123, 201, 82, 1),
    const Color.fromRGBO(255, 171, 67, 1),
    const Color.fromRGBO(252, 91, 57, 1),
    const Color.fromRGBO(139, 135, 130, 1),
  ];

  Widget pieChartMood() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getMoodData(),
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
      centerText: 'Moods',
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
    if (mounted) {
      setState(() {
        chartData = list;
      });
    }
    setState(() {
      chartData = list;
    });
  }

  final Stream<QuerySnapshot> moodCardStream = FirebaseFirestore.instance
      .collection('MoodTracking')
      .orderBy("DateTime", descending: true)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  final Stream<QuerySnapshot> weightStream = FirebaseFirestore.instance
      .collection('DailyCheckIn')
      .orderBy("DateTime", descending: true)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  final Stream<QuerySnapshot> moodPieChartStream = FirebaseFirestore.instance
      .collection('MoodTracking')
      .orderBy("DateTime")
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  Future<QuerySnapshot<Map<String, dynamic>>> getRecentDocs() async {
    final Timestamp now = Timestamp.fromDate(DateTime.now());
    final Timestamp yesterday = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    final query = FirebaseFirestore.instance
        .collection('ActivityTracking')
        .orderBy("DateTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('createdAt', isLessThan: now, isGreaterThan: yesterday);

    return query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRecentDailyCheckIn() async {
    final Timestamp now = Timestamp.fromDate(DateTime.now());
    final Timestamp yesterday = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    final query = FirebaseFirestore.instance
        .collection('DailyCheckIn')
        .orderBy("DateTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where('DateTime', isLessThan: now, isGreaterThan: yesterday);

    print(query.get());
    return query.get();
  }

  final Stream<QuerySnapshot> bmiStream = FirebaseFirestore.instance
      .collection('BMI')
      .orderBy("bmiTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  void getMoodsListfromSnapshot(snapshot) {
    if (snapshot.docs.isNotEmpty) {
      _moods = [];
      for (int i = 0; i < snapshot.docs.length; i++) {
        var a = snapshot.docs[i];

        Mood emotion = Mood.fromJson(a.data());
        _moods.add(emotion);
      }
    }
  }

  Future<void> setPage() async {
    await getbmiScore();
    await getBMITextResult();
    await getLatestMood();
    lastMoodCard();
  }

  double gotbmiScore = 0;
  double bmiScore = 0;
  Color activeColor = Colors.white;
  Color inactiveColor = Colors.white;
  String bmiResultText = "";
  String moodNameText = "";
  String activityNameText = "";

  Future<double> getbmiScore() async {
    try {
      final bmiData = await FirebaseFirestore.instance
          .collection('BMI')
          .orderBy("bmiTime")
          .limitToLast(1)
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      for (var _ in bmiData.docs) {
        bmiScore = bmiData.docs[0].get("bmiScore");

        double gotbmiScore = bmiScore;

        setState(() {
          gotbmiScore = bmiScore;
        });
        return gotbmiScore;
      }

      return bmiScore;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //DISPLAYS LATEST TDEE
  final Stream<QuerySnapshot> bmiResultStream = FirebaseFirestore.instance
      .collection('BMI')
      .orderBy("bmiTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  //DISPLAYS LATEST Calorie Deductions
  final Stream<QuerySnapshot> calsRemainingStream = FirebaseFirestore.instance
      .collection('remainingCalories')
      .orderBy("DateTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  Future<String> getBMITextResult() async {
    try {
      final latestBmiResult = await FirebaseFirestore.instance
          .collection('BMI')
          .orderBy('bmiTime')
          .limitToLast(1)
          .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      for (var _ in latestBmiResult.docs) {
        bmiResultText = latestBmiResult.docs[0].get("result");

        String FirestoreBmiTxtResult = bmiResultText;

        setBMIResult();

        setColorSlider(FirestoreBmiTxtResult);

        return FirestoreBmiTxtResult;
      }
      return bmiResultText;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getLatestMood() async {
    try {
      final latestMoodName = await FirebaseFirestore.instance
          .collection('MoodTracking')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      for (var _ in latestMoodName.docs) {
        moodNameText = latestMoodName.docs[0].get("Mood");

        String firestoreMoodText = moodNameText;

        setMoodResult();

        return firestoreMoodText;
      }

      return moodNameText;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void setMoodResult() async {
    getLatestMood().then((firestoreMoodText) {
      moodNameText = firestoreMoodText;
    });
  }

  void setBMIResult() async {
    getBMITextResult().then((firestoreBmiTxtResult) {
      bmiResultText = firestoreBmiTxtResult;
    });
  }

  bool isInteger(num value) => (value % 1) == 0;

  Color setColorValue(double result) {
    if (result < 0) {
      return Colors.red;
    } else if (result > 0) {
      return Colors.green;
    } else if (result == 0) {
      return Colors.yellow;
    }
    return Colors.transparent;
  }

  void setColorSlider(String result) {
    if (result == "Overweight") {
      activeColor = Colors.yellow;
      inactiveColor = Colors.yellow;
      result = "Overweight";
    } else if (result == "Underweight") {
      activeColor = Color(0xffFF2400);
      inactiveColor = Color(0xffFF2400);
      result = "Underweight";
    } else if (result == "Healthy") {
      activeColor = Colors.green;
      inactiveColor = Colors.green;
      result = "Healthy";
    } else if (result == "Obese") {
      activeColor = const Color(0xffFF2400);
      inactiveColor = const Color(0xffFF2400);

      result = "Obese";
    }
  }

  isMoodsEmpty(Stream<QuerySnapshot> moodstream) {
    // ignore: unrelated_type_equality_checks
    if (moodCardStream.isEmpty == true) {
      return true;
    } else {
      return false;
    }
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

class Mood {
  late String mood;

  Mood({
    required this.mood,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    //urlToImage: json['urlToImage'] as String, -> urlToImage: json['urlToImage'] ?? "",
    return Mood(
      mood: json['Mood'] ?? "",
    );
  }
}

void callThisMethod(bool isVisible) {
  debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Get.to(const LoginScreen());
  Fluttertoast.showToast(msg: "Logout Successful! ");
}

class CustomListTile extends StatelessWidget {
  final String text;
  final Widget leadingIcon;
  final Widget trailingIcon;
  final Function() onTap;
  final Color color;
  const CustomListTile(
      {required this.text,
      required this.leadingIcon,
      required this.trailingIcon,
      required this.onTap,
      this.color = const Color(0xFF4338CA),
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: ListTile(
        leading: leadingIcon,
        title: Text(
          text,
          textScaleFactor: 1,
        ),
        trailing: trailingIcon,
        selected: false,
        onTap: onTap,
      ),
      textColor: color,
      iconColor: color,
    );
  }
}



// ListTileTheme(
//       child: ListTile(
//         leading: Icon(Icons.monetization_on),
//         title: Text(
//           'My Cards',
//           textScaleFactor: 1,
//         ),
//         trailing: Icon(Icons.chevron_right),
//         selected: false,
//         onTap: () {},
//       ),
//       textColor: Color(0xFF4338CA),
//       iconColor: Color(0xFF4338CA),
//     )
