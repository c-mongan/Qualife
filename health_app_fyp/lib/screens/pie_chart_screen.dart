import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/MoodTracker/models.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';

import 'package:health_app_fyp/MoodTracker/original/list_of_moods.dart';
import 'package:health_app_fyp/screens/display_mood_pie_chart.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:health_app_fyp/widgets/nuemorphic_button.dart';
import 'package:intl/intl.dart';

import 'package:health_app_fyp/SleepTracker/list_of_sleep_time.dart';

import '../MoodTracker/moodcard.dart';

class PieChartSelect extends StatefulWidget {
  const PieChartSelect({
    Key? key,
  }) : super(key: key);

  @override
  _PieChartSelectState createState() => _PieChartSelectState();
}

class _PieChartSelectState extends State<PieChartSelect> {
  String? selectedDate;

  MoodCard? moodCard;
  String mood = "";
  String? image;
  String? datepicked;
  String? timepicked;
  String? datetime;
  num? moodValue;
  int? currentindex;
  TimeOfDay selectedTime = TimeOfDay.now();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int servings = 1;
  DateTime inputTime = DateTime.now();

  int ontapcount = 0;
  List list = [];
  List<Mood> moods = [
    Mood("assets/ANGRY3.png", "Angry", false, 1),
    Mood("assets/UPSET2.png", "Upset", false, 2),
    Mood("assets/NUETRAL.png", "Nuetral", false, 3),
    Mood("assets/CONTENT2.png", "Content", false, 4),
    Mood("assets/OPTIMISTIC2.png", "Optimistic", false, 5),
  ];

  Color colour = Colors.white;
  @override
  void initState() {
    super.initState();
  }

  late String dateonly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Mood'),
          backgroundColor: Colors.grey,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.grey,
              Colors.black,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Container(
              child: Column(children: <Widget>[
                SizedBox(height: 100),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                const Text('Select a mood',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                const Text('(Tap to Select and Tap again to deselect)',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: moods.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            const SizedBox(width: 15),
                            GestureDetector(
                                child: MoodIcon(
                                    image: moods[index].moodimage,
                                    name: moods[index].name,
                                    colour: moods[index].iselected
                                        ? Colors.white
                                        : Colors.black),
                                onTap: () => {
                                      if (ontapcount == 0)
                                        {
                                          setState(() {
                                            mood = moods[index].name;
                                            image = moods[index].moodimage;
                                            moods[index].iselected = true;
                                            ontapcount = ontapcount + 1;
                                            moodValue = moods[index].moodValue;
                                            print(mood);
                                          }),
                                        }
                                      else if (moods[index].iselected)
                                        {
                                          setState(() {
                                            moods[index].iselected = false;
                                            ontapcount = 0;
                                          })
                                        }
                                    }),
                          ],
                        );
                      }),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                SizedBox(height: 100),
                GestureDetector(
                  onTap: () => {
                    if (mood != "") {Get.to(DisplayPieChart(mood: mood))},
                  },
                  child: Container(
                    height: 38.00,
                    width: 117.00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        Text(
                          'View Pie Chart',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 12.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Icon(Icons.arrow_forward, size: 20, color: Colors.white)
                      ],
                    ),
                    decoration: BoxDecoration(
                      // color: Color(0xffff3d00),
                      color: Colors.black,
                      border: Border.all(
                        width: 0.00,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(19.00),
                    ),
                  ),
                ),
                const SizedBox(height: 15)
              ]),
            )));
  }
}
