import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';
import 'package:health_app_fyp/MoodTracker/original/pick_date.dart';
import 'package:health_app_fyp/model/user_data.dart';
import 'package:health_app_fyp/screens/home_page.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../BMR+BMR/colors&fonts.dart';
import '../../widgets/glassmorphic_bottomnavbar.dart';

class ListMoods extends StatefulWidget {
  const ListMoods({Key? key}) : super(key: key);

  @override
  _MyTestState createState() => _MyTestState();
  static String id = 'ListMoods';
}

class _MyTestState extends State<ListMoods> {
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

//DISPLAYS ALL SCANNED FOODS FROM TODAY
  final Stream<QuerySnapshot> moodStream = FirebaseFirestore.instance
      .collection('MoodTracking')
      .orderBy("DateTime", descending: false)
      // Uncomment to show all moods for today

      // .where('DateTime',
      //     isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
      //         DateTime.now().month, DateTime.now().day, 0, 0))
      // .where('DateTime',
      //     isLessThanOrEqualTo: DateTime(DateTime.now().year,
      //         DateTime.now().month, DateTime.now().day, 23, 59, 59))
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
          .collection('MoodTracking')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var date in datetime.docs) {
        print(date.data());

        dateTimeText = datetime.docs[0].get("DateTime");

        print(dateTimeText);
      }
      return dateTimeText.toString();
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<int> getNumOfMoods() async {
    int Exc = 0;

    try {
      final documents = await FirebaseFirestore.instance
          .collection('MoodTracking')
          .orderBy("DateTime")
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

  Future<int> getNumOfActivitiesinLastMood() async {
    int Exc = 0;

    try {
      final documents = await FirebaseFirestore.instance
          .collection('MoodTracking')
          .orderBy("DateTime")
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .limitToLast(1)
          .get();

      int count = documents.docs[0].get("Activities").length;

      print(count.toString() + "Activities length");

      return count;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<void> removeLastMoodActivityEntry() async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('MoodTracking')
        .orderBy("DateTime")
        .limitToLast(1)
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[
        0]; // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;
    await docRef.delete();
  }

  Future<void> removeLastActivityEntry(i) async {
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('ActivityTracking')
        .orderBy("DateTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[
        i]; // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;
    await docRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(ListMoods.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          asyncMethod(isVisible);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Mood Tracker"),
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
                Colors.grey
                // Colors.red,
                // Colors.blue,

                // Colors.orange,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(children: [
                const SizedBox(
                  width: 5,
                ),
                // const Icon(Icons.insert_emoticon,
                //     color: Colors.white, size: 40),
                Expanded(
                    child: Container(
                        height: 400.0,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: moodStream,
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
                                      // "Activities: " +
                                      data['Activities'].toString().substring(
                                              1,
                                              data['Activities']
                                                      .toString()
                                                      .length -
                                                  1) +
                                          "             " +
                                          data['DateOfMood'].toString() +
                                          " " +
                                          //" at Time: " +
                                          data['TimeOfMood'].toString(),
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.line_weight));
                              }).toList(),
                            );
                          },
                        ))),
                // Button(
                //     edges: const EdgeInsets.all(0.0),
                //     color: Colors.blue,
                //     text: const Text(
                //       'Home',
                //       style: textStyle2,
                //       // TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const HomePage(),
                //         ),
                //       );
                //     }

                //     )
              ]
                  // Flexible(
                  //     flex: 1,
                  //     child:

                  )),
          floatingActionButton: getFloatingActionButton(),
        ));
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
            Get.to(PickDateMoodTracker());
          },
          label: 'Add an entry',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: const Icon(MdiIcons.minus, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () async {
            getNumOfMoods().then((count) => count).then((count) {
              if (count > 0) {
                getNumOfActivitiesinLastMood()
                    .then((count) => count)
                    .then((count) {
                  for (int i = 0; i < count; i++) {
                    removeLastActivityEntry(i);
                    print("Called this many times" + i.toString());
                  }
                });
                getNumOfMoods().then((count) => count).then((count) {
                  if (count > 0) {
                    removeLastMoodActivityEntry();
                  }
                });
              }
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
