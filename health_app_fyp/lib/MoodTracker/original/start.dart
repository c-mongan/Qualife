import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/ExampleMood/models/activity.dart';
import 'package:health_app_fyp/ExampleMood/models/mood.dart';
import 'package:health_app_fyp/ExampleMood/models/moodcard.dart';
import 'package:health_app_fyp/ExampleMood/widgets/activity.dart';
import 'package:health_app_fyp/ExampleMood/widgets/moodicon.dart';
import 'package:health_app_fyp/MoodTracker/original/ListOfMoods.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';

class StartPage extends StatefulWidget {
  final String selectedDate;

  //String? selectedDate;
  const StartPage({Key? key, required this.selectedDate}) : super(key: key);
  //final String date;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String? selectedDate;
  //_StartPageState(this.selectedDate);
  MoodCard? moodCard;
  String? mood;
  String? image;
  String? datepicked;
  String? timepicked;
  String? datetime;
  int? currentindex;
  // late MoodCard moodCard;
  // late String mood;
  // late String image;
  // late String datepicked;
  // late String timepicked;
  // late String datetime;
  // late int currentindex;
  TimeOfDay selectedTime = TimeOfDay.now();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int servings = 1;
  DateTime inputTime = DateTime.now();

  int ontapcount = 0;
  List list = [];
  List<Mood> moods = [
    Mood('assets/smile.png', 'Happy', false),
    Mood('assets/sad.png', 'Sad', false),
    Mood('assets/angry.png', 'Angry', false),
    Mood('assets/surprised.png', 'Surprised', false),
    // Mood('assets/loving.png', 'Loving', false),
    Mood('assets/stressed.png', 'Stressed', false),
    Mood('assets/scared.png', 'Panicked', false)
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
    //Activity('assets/date.png', 'Date', false),
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
        // appBar: AppBar(
        //     elevation: 0,
        //     title: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text('Mood Tracker',
        //             style: TextStyle(
        //                 fontSize: 30,
        //                 fontStyle: FontStyle.normal,
        //                 fontWeight: FontWeight.bold)),
        //         SizedBox(
        //           width: 5,
        //         ),
        //         Icon(Icons.insert_emoticon, color: Colors.white, size: 35)
        //       ],
        //     ),
        //     backgroundColor: Colors.red),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    // colors: [Colors.red, Colors.white, Colors.red],
                    colors: [
                  Colors.red,
                  Colors.blue,
                  // Colors.red,
                  //Colors.blue,

                  // Colors.orange,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Container(
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                    print(widget.selectedDate);
                    // print();
                  },
                  child: Text("Choose Time"),
                ),
                SizedBox(
                  height: 20,
                  width: 5,
                ),
                Row(
                  children: [
                    Text(
                      "               Time selected ${selectedTime.hour}:${selectedTime.minute}",
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    CircleAvatar(
                      radius: 25,
                      child: CircleAvatar(
                          child: Icon(Icons.timer, color: Colors.red, size: 25),
                          radius: 20,
                          backgroundColor: Colors.white),
                      backgroundColor: Colors.red,
                    ),

                    //  Icon(Icons.timer_outlined, color: Colors.white, size: 25),

                    SizedBox(
                      height: 30,
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                  width: 5,
                ),

                //         ],
                //       ),
                //     ),
                //   );
                // }

                // Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                //     Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           // Navigator.of(context).pushNamed('/home_screen');
                //         },
                //         child: Column(
                //           children: [
                //             CircleAvatar(
                //               radius: 27,
                //               child: CircleAvatar(
                //                   child: Icon(Icons.dashboard,
                //                       color: Colors.green, size: 30),
                //                   radius: 25,
                //                   backgroundColor: Colors.white),
                //               backgroundColor: Colors.green,
                //             ),
                //             SizedBox(height: 2.5),
                //             Text('Dashboard',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     color: Colors.green,
                //                     fontSize: 15))
                //           ],
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           showDatePicker(
                //                   context: context,
                //                   initialDate: DateTime.now(),
                //                   firstDate: DateTime(2001),
                //                   lastDate: DateTime(2022))
                //               .then((date) => {
                //                     setState(() {
                //                       datepicked = date!.day.toString() +
                //                           '-' +
                //                           date.month.toString() +
                //                           '-' +
                //                           date.year.toString();
                //                       dateonly = date.day.toString() +
                //                           '/' +
                //                           date.month.toString();
                //                     }),
                //                   });
                //         },
                //         child: Column(
                //           children: [
                //             CircleAvatar(
                //               radius: 27,
                //               child: CircleAvatar(
                //                   child: Icon(Icons.calendar_today,
                //                       color: Colors.blue, size: 30),
                //                   radius: 25,
                //                   backgroundColor: Colors.white),
                //               backgroundColor: Colors.blue,
                //             ),
                //             SizedBox(
                //               height: 2.5,
                //             ),
                //             Text('Pick a date',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     color: Colors.blue,
                //                     fontSize: 15))
                //           ],
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           // showTimePicker(context: context, initialTime: TimeOfDay.now())
                //           //     .then((time) => {
                //           //           setState(() {
                //           //             timepicked = time!.format(context).toString();
                //           //   })
                //           // });
                //         },
                //         child: Column(
                //           children: [
                //             CircleAvatar(
                //               radius: 27,
                //               child: CircleAvatar(
                //                   child: Icon(Icons.timer,
                //                       color: Colors.red, size: 30),
                //                   radius: 25,
                //                   backgroundColor: Colors.white),
                //               backgroundColor: Colors.red,
                //             ),
                //             SizedBox(
                //               height: 2.5,
                //             ),
                //             Text('Pick a time',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.w500,
                //                     color: Colors.red,
                //                     fontSize: 15))
                //           ],
                //         ),
                //       ),
                //     ]),
                // SizedBox(height: 20),
                // Container(
                //   height: 30,
                //   width: 30,
                //   child: FloatingActionButton(
                //     backgroundColor: Colors.red,
                //     child: Icon(Icons.done),
                //     onPressed: () => setState(() {
                //       datetime = datepicked + '   ' + timepicked;
                //     }),
                //   ),
                // ),

                SizedBox(height: 20),
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
                                        ? Colors.black
                                        : Colors.white),
                                onTap: () => {
                                      if (ontapcount == 0)
                                        {
                                          setState(() {
                                            mood = moods[index].name;
                                            image = moods[index].moodimage;
                                            moods[index].iselected = true;
                                            ontapcount = ontapcount + 1;
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
                const Text('What were you doing that day?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    'Hold on the activity to select,You can choose multiple',
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
                                      ? Colors.black
                                      : Colors.white),
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
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      // Provider.of<MoodCard>(context, listen: false).addPlace(
                      //     datetime,
                      //     mood,
                      //     image,
                      //     Provider.of<MoodCard>(context, listen: false)
                      //         .activityimage
                      //         .join('_'),
                      //     Provider.of<MoodCard>(context, listen: false)
                      //         .activityname
                      //         .join('_'),
                      //     dateonly);
                      // print("Pressed");
                      //print(act);

                      // for (var e in list) {
                      //   print(e);

                      String time = ((selectedTime.hour.toString() + ":") +
                          selectedTime.minute.toString());

                      // DateFormat("dd-MM-yyyy")
                      //     .format(DateTime.parse(widget.selectedDate));

                      // DateTime.parse(widget.selectedDate);

                      if (mood != null && list.isNotEmpty) {
                        FirebaseFirestore.instance
                            .collection('MoodTracking')
                            .add({
                          'userID': uid,
                          'DateOfMood': widget.selectedDate,
                          'TimeOfMood': time,
                          'Mood': mood,
                          'Activities': list,
                          'DateTime': DateTime.parse(widget.selectedDate),
                          'Icon': image
                        });
                        Get.to(const ListMoods());
                      }
                      //                   Mood('assets/smile.png', 'Happy', false),   6
                      // Mood('assets/sad.png', 'Sad', false), 1
                      // Mood('assets/angry.png', 'Angry', false), 4
                      // Mood('assets/surprised.png', 'Surprised', false), 5
                      // Mood('assets/stressed.png', 'Stressed', false), 2
                      // Mood('assets/scared.png', 'Panicked', false) 3

                      //  switch(mood) {
                      //     case "Happy": {  print("Happy");

                      //      FirebaseFirestore.instance
                      //                         .collection('MoodCount')
                      //                         .add({
                      //                       'userID': uid,
                      //                       'DateOfMood': widget.selectedDate,
                      //                       'TimeOfMood': time,
                      //                       'Mood': mood,
                      //                       'Activities': list,
                      //                       'DateTime': DateTime.parse(widget.selectedDate),
                      //                       'Icon': image
                      //                     });

                      //      }
                      //     break;

                      //     case "B": {  print("Good"); }
                      //     break;

                      //     case "C": {  print("Fair"); }
                      //     break;

                      //     case "D": {  print("Poor"); }
                      //     break;

                      //     default: { print("Invalid choice"); }
                      //     break;
                      //  }

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ListMoods(),
                      //     ));
                    }
                        //print(activityname);
                        // print(act[index].name);
                        ),
                    // Navigator.of(context).pushNamed('/home_screen'),
                  },
                  child: Container(
                    height: 38.00,
                    width: 117.00,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'Save',
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
                      color: Colors.red,
                      border: Border.all(
                        width: 1.00,
                        color: Color(0xffff3d00),
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
