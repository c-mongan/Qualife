import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/MoodTracker/models.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';

import 'package:health_app_fyp/MoodTracker/original/list_of_moods.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:health_app_fyp/widgets/nuemorphic_button.dart';
import 'package:intl/intl.dart';

import '../moodcard.dart';

class MoodActivitySelect extends StatefulWidget {
  final String selectedDate;

  const MoodActivitySelect({Key? key, required this.selectedDate})
      : super(key: key);

  @override
  _MoodActivitySelectState createState() => _MoodActivitySelectState();
}

class _MoodActivitySelectState extends State<MoodActivitySelect> {
  String? selectedDate;

  MoodCard? moodCard;
  String? mood;
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

    // Mood('assets/smile.png', 'Happy', false),
    // Mood('assets/sad.png', 'Sad', false),
    // Mood('assets/angry.png', 'Angry', false),
    // Mood('assets/surprised.png', 'Surprised', false),
    // Mood('assets/stressed.png', 'Stressed', false),
    // Mood('assets/scared.png', 'Panicked', false)
  ];

  List<Activity> act = [
    Activity('assets/sports.png', 'Playing Sports', false),
    Activity('assets/sleeping.png', 'Sleeping', false),
    Activity('assets/shop.png', 'Shopping', false),
    Activity('assets/relax.png', 'Relaxing', false),
    Activity('assets/reading.png', 'Reading', false),
    Activity('assets/movies.png', ' Watching Movies', false),
    Activity('assets/gaming.png', 'Gaming', false),
    Activity('assets/friends.png', 'Friends', false),
    Activity('assets/family.png', 'Family Time', false),
    Activity('assets/excercise.png', 'Excercise', false),
    Activity('assets/eat.png', 'Eating', false),
    Activity('assets/clean.png', 'Cleaning', false)
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
                // SizedBox(
                //   height: 30,
                // ),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                const Text('What was your mood at the time?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                const Text('(Tap to Select and Tap again to deselect!)',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Expanded(
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
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                const Text('What were you doing that day?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    '(Hold on the activity to select,you can choose multiple)',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: act.length,
                      itemBuilder: (context, index) {
                        return Row(children: <Widget>[
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                              child: ActivityIcon(
                                  act[index].image,
                                  act[index].name,
                                  act[index].selected
                                      ? Colors.white
                                      : Colors.black),
                              onLongPress: () => {
                                    if (act[index].selected)
                                      {
                                        setState(() {
                                          act[index].selected = false;
                                          list.remove(act[index].name);
                                        })
                                      }
                                    else
                                      setState(() {
                                        act[index].selected = true;

                                        print(act[index].name);
                                        print(act[index].selected);

                                        list.add(act[index].name);
                                        // Provider.of<MoodCard>(context,
                                        //         listen: false)
                                        //     .add(act[index]);
                                      }),
                                  }),
                        ]);
                      }),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                const Text('What time was this at?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Center(
                      child: Text(
                        // "               Time selected ${selectedTime.hour}:${selectedTime.minute}",

                        "                          Time selected : ${selectedTime.format(context)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 15,
                      child: CircleAvatar(
                          child:
                              Icon(Icons.timer, color: Colors.black, size: 20),
                          radius: 20,
                          backgroundColor: Colors.white),
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      height: 30,
                      width: 5,
                    ),
                  ],
                ),
                RaisedButton(
                  color: Colors.black,
                  child: Text(
                    "Select Time",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () {
                    _selectTime(context);
                    print(widget.selectedDate);
                  },
                ),
                // SizedBox(height: 20),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      NumberFormat formatter = NumberFormat("00");
                      String formatted = formatter.format(selectedTime.minute);
                      String time =
                          ((selectedTime.hour.toString() + ":") + formatted);

                      if (mood != null && list.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('MoodTracking')
                            .add({
                          'userID': uid,
                          'DateOfMood': widget.selectedDate,
                          'TimeOfMood': time,
                          'Mood': mood,
                          'Activities': list,
                          'DateTime': DateFormat('yyyy-MM-dd')
                              .parse(widget.selectedDate),
                          'Icon': image,
                          'MoodValue': moodValue
                        });

                        for (int i = 0; i < list.length; i++) {
                          FirebaseFirestore.instance
                              .collection('ActivityTracking')
                              .add({
                            'userID': uid,
                            'DateOfActivity': widget.selectedDate,
                            'TimeOfActivity': time,
                            'Mood': mood,
                            'Activity': list[i],
                            'DateTime': DateFormat('yyyy-MM-dd')
                                .parse(widget.selectedDate),
                            'Icon': image
                          });
                        }
                        Get.to(const ListMoods());
                      }
                    }),
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
                          'Save ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 21.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.save_alt, size: 20, color: Colors.white)
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

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
