import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/OpenFoodFacts/track_a_food.dart';
import 'package:health_app_fyp/model/user_data.dart';
import 'package:health_app_fyp/widgets/nuemorphic_button.dart';
import 'package:health_app_fyp/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/customnavbar.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
  static String id = 'myTest';
}

var start;
var pastWeek;
var pastMonth;
var end;

class _BarcodeScannerState extends State<BarcodeScanner> {
  @override
  void initState() {
    super.initState();

    start = DateTime.now();
    pastWeek = DateTime.now().day - 7;
    pastMonth = DateTime.now().day - 30;

    end = DateTime.now().day - 1;
    checkDay();
  }


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

  String uid = FirebaseAuth.instance.currentUser!.uid;
  String dayCals = "";

  String? filter = "";

  User? user = FirebaseAuth.instance.currentUser;
  Measurements loggedInUser = Measurements();

  void asyncMethod(bool isVisible) async {
    //checkDay();
  }

  void callThisMethod(bool isVisible) {
    debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
  }

  final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime', isGreaterThanOrEqualTo: start)
      .where('DateTime', isLessThanOrEqualTo: end)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

//DISPLAYS ALL SCANNED FOODS FROM TODAY
  final Stream<QuerySnapshot> foodStreamToday = FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime',
          isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 0, 0))
      .where('DateTime',
          isLessThanOrEqualTo: DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 23, 59, 59))
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  //DISPLAYS ALL SCANNED FOODS FROM THE WEEK
  final Stream<QuerySnapshot> foodStreamWeek = FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime', isGreaterThanOrEqualTo: start)
      .where('DateTime', isLessThanOrEqualTo: pastWeek)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  //DISPLAYS ALL SCANNED FOODS FROM THE MONTH
  final Stream<QuerySnapshot> foodStreamMonth = FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime', isGreaterThanOrEqualTo: start)
      .where('DateTime', isLessThanOrEqualTo: pastMonth)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

//DISPLAYS LATEST TDEE
  final Stream<QuerySnapshot> tdeeStream = FirebaseFirestore.instance
      .collection('TDEE')
      .orderBy("tdeeTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  //DISPLAYS LATEST Calorie Deductions
  final Stream<QuerySnapshot> CalsStream = FirebaseFirestore.instance
      .collection('remainingCalories')
      .orderBy("DateTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  DateTime dateTimeText = DateTime.now();

  Future<String> getTimeDate() async {
    String Exc = "Error";

    try {
      final datetime = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var date in datetime.docs) {
        dateTimeText = datetime.docs[0].get("DateTime");
      }
      return dateTimeText.toString();
    } catch (Exc) {
      rethrow;
    }
  }

  Future<int> getNumOfFoodsToday() async {
    int Exc = 0;

    try {
      final documents = await FirebaseFirestore.instance
          .collection('Food')
          .orderBy("DateTime")
          .where('DateTime',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 0, 0))
          .where('DateTime',
              isLessThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 23, 59, 59))
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      int count = documents.size;

      return count;
    } catch (Exc) {
      rethrow;
    }
  }

  Future<void> removeLastFood() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('Food')
        .orderBy("DateTime")
        .where('DateTime',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0, 0))
        .where('DateTime',
            isLessThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 23, 59, 59))
        .limitToLast(1)
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[
        0]; // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;
    await docRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(BarcodeScanner.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          asyncMethod(isVisible);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Calorie Tracker"),
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
              child: Column(children: [
                Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                SizedBox(
                    height: 75.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: CalsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        return ListView(
                          // shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return ListTile(
                                title: Text(
                              data[('Cals')].toStringAsFixed(0) +
                                  " kcal remaining today",
                              style:  TextStyle(
                                fontSize: 30.0,
                                color: setColorValue(
                                    data[('Cals')]),
                                fontWeight: FontWeight.w600,
                              ),
                            ));
                          }).toList(),
                        );
                      },
                    )),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 350.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: foodStreamToday,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          //itemExtent: 75,

                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return ListTile(
                                leading: const Icon(Icons.fastfood),
                                isThreeLine: true,
                                title: Text(
                                  data['Food Name'],
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  data['TotalCaloriesAdded']
                                          .toStringAsFixed(2) +
                                      " Calories Per " +
                                      data['NumberOfServings'].toString() +
                                      " Servings(s) of " +
                                      data['ServingSize'].toString() +
                                      "g Added",
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ));
                          }).toList(),
                        );
                      },
                    ))
              ])),
          floatingActionButton: getFloatingActionButton(),
        ));
  }

  bool dialVisible = true;
  Widget getFloatingActionButton() {
    return Theme(
        data: Theme.of(context).copyWith(highlightColor: Colors.black),
        child: SpeedDial(
          overlayColor: Colors.black,
          backgroundColor: Colors.black,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme:
              const IconThemeData(size: 22.0, color: Colors.white),
          visible: dialVisible,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(MdiIcons.barcodeScan, color: Colors.white),
              backgroundColor: Colors.green,
              onTap: () async {
                // // bool a;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BarcodeScanSecond()),
                );
              },
              label: 'Barcode Scan',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.green,
            ),
            SpeedDialChild(
              child: Icon(MdiIcons.minus, color: Colors.white),
              backgroundColor: Colors.red,
              onTap: () async {
                deleteLastFood();
              },
              label: 'Delete Last Entry',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: Colors.red,
            ),
          ],
        ));
  }

  Future<Timestamp> getLastCalsRemainingDay() async {
    String Exc = "Error";

    try {
      final calsdate = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var cals in calsdate.docs) {
        Timestamp time;
        time = calsdate.docs[0].get("DateTime");

        String calsLeftDay = dayCals.toString();

        return time;
      }
      return Timestamp(0, 0);
    } catch (Exc) {
      rethrow;
    }
  }

  Future<double> getTdeeVal() async {
    double Exc = 0;
    double t2 = 0;

    try {
      final tdeevals = await FirebaseFirestore.instance
          .collection('TDEE')
          .orderBy('tdeeTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var tdeeval in tdeevals.docs) {
        double tdee = tdeevals.docs[0].get("tdee");

        return tdee;
      }
      return t2;
    } catch (Exc) {
      rethrow;
    }
  }

  void checkDay() {
    DateTime inputTime = DateTime.now();
    final today = DateTime.now().day;

    getLastCalsRemainingDay().then((time) {
      DateTime tempdate =
          DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);

      if (tempdate.day != today) {
        getTdeeVal().then((tdee) {
          double totalDeducts = tdee - 0;

          FirebaseFirestore.instance.collection('remainingCalories').add({
            'userID': uid,
            'Cals': totalDeducts,
            'DateTime': inputTime,
          });

          //   FirebaseFirestore.instance.collection('endDayOfCalories').add({
          //     'userID': uid,
          //     'Cals': tdee,
          //     'DateTime': time,
          //   });
        });
      }
    });
  }

  Future<double> getLastLoggedFoodCalories() async {
    double Exc = 0;
    double t2 = 0;

    try {
      final lastLoggedFood = await FirebaseFirestore.instance
          .collection('Food')
          .orderBy('DateTime')
          .where('DateTime',
              isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 0, 0))
          .where('DateTime',
              isLessThanOrEqualTo: DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, 23, 59, 59))
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var totalcalsval in lastLoggedFood.docs) {
        double totalcals = lastLoggedFood.docs[0].get("TotalCaloriesAdded");

        return totalcals;
      }
      return t2;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<double> getLatestNetCalories() async {
    double Exc = 0;
    double t2 = 0;

    try {
      final lastLoggedFood = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();

      for (var remainingCalsVal in lastLoggedFood.docs) {
        double latestnetcals = lastLoggedFood.docs[0].get("Cals");

        return latestnetcals;
      }
      return t2;
    } catch (Exc) {
      rethrow;
    }
  }

  void deleteLastFood() {
    DateTime inputTime = DateTime.now();

    getLastLoggedFoodCalories().then((totalcals) {
      print(totalcals.toString() + "result");

      getLatestNetCalories().then((latestnetcals) {
        print(latestnetcals.toString() + "result");

        double removeLastFoodsCalories = totalcals + latestnetcals;

        getNumOfFoodsToday().then((count) {
          if (count > 0) {
            removeLastFood();
          } else {
            print("No Foods Left In List");
          }

          getTdeeVal().then((tdee) {
            if (removeLastFoodsCalories > tdee) {
              FirebaseFirestore.instance.collection('remainingCalories').add({
                'userID': uid,
                'Cals': tdee,
                'DateTime': inputTime,
              });
            } else {
              FirebaseFirestore.instance.collection('remainingCalories').add({
                'userID': uid,
                'Cals': removeLastFoodsCalories,
                'DateTime': inputTime,
              });
            }
          });
        });
      });
    });
  }
}
