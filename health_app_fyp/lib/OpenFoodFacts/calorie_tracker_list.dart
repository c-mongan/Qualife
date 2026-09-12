import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/OpenFoodFacts/track_a_food.dart';
import 'package:health_app_fyp/model/user_data.dart';
import 'package:health_app_fyp/widgets/nuemorphic_button.dart';
import 'package:health_app_fyp/widgets/widgets.dart';
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
    if (FirebaseAuth.instance.currentUser != null) {
      checkDay();
    }
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

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';
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

  Stream<QuerySnapshot> get stream => FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime', isGreaterThanOrEqualTo: start)
      .where('DateTime', isLessThanOrEqualTo: end)
      .where('userID', isEqualTo: uid)
      .snapshots();

//DISPLAYS ALL SCANNED FOODS FROM TODAY
  Stream<QuerySnapshot> get foodStreamToday => FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime',
          isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 0, 0))
      .where('DateTime',
          isLessThanOrEqualTo: DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, 23, 59, 59))
      .where('userID', isEqualTo: uid)
      .snapshots();

  //DISPLAYS ALL SCANNED FOODS FROM THE WEEK
  Stream<QuerySnapshot> get foodStreamWeek => FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime', isGreaterThanOrEqualTo: start)
      .where('DateTime', isLessThanOrEqualTo: pastWeek)
      .where('userID', isEqualTo: uid)
      .snapshots();

  //DISPLAYS ALL SCANNED FOODS FROM THE MONTH
  Stream<QuerySnapshot> get foodStreamMonth => FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .where('DateTime', isGreaterThanOrEqualTo: start)
      .where('DateTime', isLessThanOrEqualTo: pastMonth)
      .where('userID', isEqualTo: uid)
      .snapshots();

//DISPLAYS LATEST TDEE
  Stream<QuerySnapshot> get tdeeStream => FirebaseFirestore.instance
      .collection('TDEE')
      .orderBy("tdeeTime")
      .limitToLast(1)
      .where('userID', isEqualTo: uid)
      .snapshots();

  //DISPLAYS LATEST Calorie Deductions
  Stream<QuerySnapshot> get CalsStream => FirebaseFirestore.instance
      .collection('remainingCalories')
      .orderBy("DateTime")
      .limitToLast(1)
      .where('userID', isEqualTo: uid)
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
    } catch (_) {
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
          .where('userID', isEqualTo: uid)
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
        .where('userID', isEqualTo: uid)
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
                              style: TextStyle(
                                fontSize: 30.0,
                                color: setColorValue(data[('Cals')]),
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
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
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
              child: const Icon(Icons.remove, color: Colors.white),
              backgroundColor: Colors.red,
              onTap: () async {
                await deleteLastFood();
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

  Future<void> checkDay() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final now = DateTime.now();
      final time = await getLastCalsRemainingDay();
      final previous = time.toDate();
      if (!_sameCalendarDate(previous, now)) {
        final tdee = await getTdeeVal();
        final dayKey =
            '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
        await FirebaseFirestore.instance
            .collection('remainingCalories')
            .doc('${user.uid}_$dayKey')
            .set({
          'userID': user.uid,
          'Cals': tdee,
          'DateTime': now,
        }, SetOptions(merge: true));
      }
    } catch (_) {
      _showError('Could not refresh today’s calorie balance.');
    }
  }

  bool _sameCalendarDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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

  Future<void> deleteLastFood() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('Please sign in before deleting food.');
      return;
    }
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final foods = await FirebaseFirestore.instance
          .collection('Food')
          .orderBy('DateTime')
          .where('DateTime', isGreaterThanOrEqualTo: startOfDay)
          .where('DateTime', isLessThan: endOfDay)
          .where('userID', isEqualTo: user.uid)
          .limitToLast(1)
          .get();
      if (foods.docs.isEmpty) {
        _showError('There are no food entries to delete today.');
        return;
      }

      final food = foods.docs.first;
      final tdee = await getTdeeVal();
      final latestBalance = await getLatestNetCalories();
      final dayKey =
          '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentFood = await transaction.get(food.reference);
        if (!currentFood.exists) {
          return;
        }
        final foodData = currentFood.data();
        final caloriesValue = foodData?['TotalCaloriesAdded'];
        if (caloriesValue is! num) {
          throw StateError('Food entry has no calorie total');
        }
        final balanceId =
            foodData?['balanceDocumentId']?.toString() ?? '${user.uid}_$dayKey';
        final balanceRef = FirebaseFirestore.instance
            .collection('remainingCalories')
            .doc(balanceId);
        final balance = await transaction.get(balanceRef);
        final stored = balance.data()?['Cals'];
        final current = stored is num ? stored.toDouble() : latestBalance;
        final restored = (current + caloriesValue.toDouble())
            .clamp(double.negativeInfinity, tdee);
        transaction.delete(food.reference);
        transaction.set(
            balanceRef,
            {
              'userID': user.uid,
              'Cals': restored,
              'DateTime': now,
            },
            SetOptions(merge: true));
      });
    } catch (_) {
      _showError('Could not delete the food entry. Nothing was changed.');
    }
  }
}
