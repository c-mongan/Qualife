import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';
import 'package:health_app_fyp/MoodTracker/original/pick_date.dart';
import 'package:health_app_fyp/SleepTracker/pick_date_sleep.dart';
import 'package:health_app_fyp/model/user_data.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ListSleep extends StatefulWidget {
  const ListSleep({Key? key}) : super(key: key);

  @override
  _MyTestState createState() => _MyTestState();
  static String id = 'ListSleep';
}

class _MyTestState extends State<ListSleep> {
  @override
  void initState() {
    super.initState();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;
  String dayCals = "";

  User? user = FirebaseAuth.instance.currentUser;
  Measurements loggedInUser = Measurements();

  void asyncMethod(bool isVisible) async {}

  void callThisMethod(bool isVisible) {
    debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
  }

  bool isInteger(num value) => (value % 1) == 0;

//DISPLAYS ALL SCANNED FOODS FROM TODAY
  final Stream<QuerySnapshot> sleepStream = FirebaseFirestore.instance
      .collection('SleepTracking')
      .orderBy("SleepTime", descending: true)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  DateTime dateTimeText = DateTime.now();

  Future<String> getTimeDate() async {
    String Exc = "Error";

    try {
      final datetime = await FirebaseFirestore.instance
          .collection('MoodTracking')
          .orderBy('SleepTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var date in datetime.docs) {
        dateTimeText = datetime.docs[0].get("SleepTime");

        print(dateTimeText);
      }
      return dateTimeText.toString();
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<int> getNumOfSleep() async {
    int Exc = 0;

    try {
      final documents = await FirebaseFirestore.instance
          .collection('SleepTracking')
          .orderBy("SleepTime")
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      int count = documents.size;

      print(count);

      return count;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<void> removeLastSleepEntry() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('SleepTracking')
        .orderBy("SleepTime")
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
        key: Key(ListSleep.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          asyncMethod(isVisible);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Sleep Tracker"),
            elevation: 0,
            backgroundColor: Colors.black,
          ),
          bottomNavigationBar: CustomisedNavigationBar(),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.grey],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Column(children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: SizedBox(
                        height: 400.0,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: sleepStream,
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
                              //itemExtent: 75,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return ListTile(

                               
                                    title: isInteger(data['SleepDuration']) ==
                                            true
                                        ? Text(
                                            data['SleepDuration']
                                                    .toStringAsFixed(0) +
                                                "hrs",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: setColorValue(
                                                  data['SleepDuration']),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : Text(
                                            data['SleepDuration'].toString() +
                                                "hrs",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: setColorValue(
                                                  data['SleepDuration']),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                    subtitle: Text(
                                      data['DateOfSleep'].toString() +
                                          " " +
                                          //" at Time: " +
                                          data['TimeOfSleep'].toString(),
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.line_weight));
                              }).toList(),
                            );
                          },
                        ))),
              ])),
          floatingActionButton: getFloatingActionButton(),
        ));
  }

  Color setColorValue(double result) {
    if (result < 7) {
      return Colors.red;
    } else if (result >= 7 && result < 9) {
      return Colors.green;
    } else if (result >= 9) {
      return Colors.yellow;
    }

    return Colors.transparent;
  }

  bool dialVisible = true;
  Widget getFloatingActionButton() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.black,
      overlayColor: Colors.black,
      animatedIconTheme: const IconThemeData(size: 22.0),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: const Icon(MdiIcons.plus, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () async {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PickDateMoodTracker()),
            Get.to(const PickDateSleepTracker());
          },
          label: 'Add an entry',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.minus, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () async {
            getNumOfSleep().then((count) => count).then((count) {
              getNumOfSleep().then((count) => count).then((count) {
                if (count > 0) {
                  removeLastSleepEntry();
                }
              });
            });
          },
          label: 'Delete Last Entry',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.red,
        ),
      ],
    );
  }
}
