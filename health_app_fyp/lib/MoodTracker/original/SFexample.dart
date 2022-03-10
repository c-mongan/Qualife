// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:health_app_fyp/MoodTracker/original/start.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:intl/intl.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(MoodHome());
// // }

// class MoodHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'FireBase',
//       home: LoadDataFromFireStore(),
//     );
//   }
// }

// class LoadDataFromFireStore extends StatefulWidget {
//   @override
//   LoadDataFromFireStoreState createState() => LoadDataFromFireStoreState();
// }

// class LoadDataFromFireStoreState extends State<LoadDataFromFireStore> {
//   List<Color> _colorCollection = <Color>[];
//   MeetingDataSource? events;
//   final List<String> options = <String>['Add', 'Delete', 'Update'];
//   final fireStoreReference = FirebaseFirestore.instance;
//   bool isInitialLoaded = false;
//   DateTime now = DateTime.now();

//   @override
//   void initState() {
//     _initializeEventColor();
//     getDataFromFireStore().then((results) {
//       SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
//         setState(() {});
//       });
//     });
//     fireStoreReference.collection("MoodTrack").snapshots().listen((event) {
//       event.docChanges.forEach((element) {
//         if (element.type == DocumentChangeType.added) {
//           if (!isInitialLoaded) {
//             return;
//           }

//           final Random random = new Random();
//           Meeting app = Meeting.fromFireBaseSnapShotData(
//               element, _colorCollection[random.nextInt(9)]);
//           setState(() {
//             events!.appointments!.add(app);
//             events!.notifyListeners(CalendarDataSourceAction.add, [app]);
//           });
//         } else if (element.type == DocumentChangeType.modified) {
//           if (!isInitialLoaded) {
//             return;
//           }

//           final Random random = new Random();
//           Meeting app = Meeting.fromFireBaseSnapShotData(
//               element, _colorCollection[random.nextInt(9)]);
//           setState(() {
//             int index = events!.appointments!
//                 .indexWhere((app) => app.key == element.doc.id);

//             Meeting meeting = events!.appointments![index];

//             events!.appointments!.remove(meeting);
//             events!.notifyListeners(CalendarDataSourceAction.remove, [meeting]);
//             events!.appointments!.add(app);
//             events!.notifyListeners(CalendarDataSourceAction.add, [app]);
//           });
//         } else if (element.type == DocumentChangeType.removed) {
//           if (!isInitialLoaded) {
//             return;
//           }

//           setState(() {
//             int index = events!.appointments!
//                 .indexWhere((app) => app.key == element.doc.id);

//             Meeting meeting = events!.appointments![index];
//             events!.appointments!.remove(meeting);
//             events!.notifyListeners(CalendarDataSourceAction.remove, [meeting]);
//           });
//         }
//       });
//     });
//     super.initState();
//   }

//   Future<void> getDataFromFireStore() async {
//     var snapShotsValue = await fireStoreReference.collection("MoodTrack").get();

//     final Random random = new Random();
//     List<Meeting> list = snapShotsValue.docs
//         .map((e) => Meeting(
//             eventName: e.data()['Subject'],
//             from:
//                 DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['StartTime']),
//             to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['EndTime']),
//             background: _colorCollection[random.nextInt(9)],
//             isAllDay: false,
//             key: e.id))
//         .toList();
//     setState(() {
//       events = MeetingDataSource(list);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     isInitialLoaded = true;
//     return Scaffold(
//         appBar: AppBar(
//             leading: PopupMenuButton<String>(
//           icon: Icon(Icons.settings),
//           itemBuilder: (BuildContext context) => options.map((String choice) {
//             return PopupMenuItem<String>(
//               value: choice,
//               child: Text(choice),
//             );
//           }).toList(),
//           onSelected: (String value) async {
//             if (value == 'Add') {
//               int day = now.day;
//               int month = now.month;
//               int year = now.year;
//               int hour = now.hour;

//               // if (day < 10) {
//               // //  day = ("0" + day.toString()) as int;
//               // } else if (month < 10) {
//               //   // month = ("0" + day.toString()) as int;
//               //   month = DateTime.now().month.toString().padLeft(2, '0') as int;
//               //   print(month);
//               // }
//               // print(month);
//               // // bool a;
//               await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StartPage(),
//                   ));

//               // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>StartPage(sele)));

//               fireStoreReference.collection("MoodTrack").doc("1").set({
//                 'Subject': 'Mastering Flutter',
//                 // 'StartTime': '07/04/2020 08:00:00',
//                 'StartTime': '$day/$month/$year $hour:00:00',
//                 'EndTime': '$day/$month/$year $hour:00:00',
//               });
//             } else if (value == "Delete") {
//               try {
//                 fireStoreReference.collection('MoodTrack').doc('1').delete();
//               } catch (e) {}
//             } else if (value == "Update") {
//               try {
//                 fireStoreReference
//                     .collection('MoodTrack')
//                     .doc('1')
//                     .update({'Subject': 'Meeting'});
//               } catch (e) {}
//             }
//           },
//         )),
//         body: SfCalendar(
//           view: CalendarView.month,
//           initialDisplayDate: DateTime(DateTime.now().year,
//               DateTime.now().month, DateTime.now().day, 9, 0, 0),
//           dataSource: events,
//           // onTap: calendarTapped(),
//           monthViewSettings: MonthViewSettings(
//             showAgenda: true,
//           ),
//         ));
//   }

//   void _initializeEventColor() {
//     _colorCollection.add(const Color(0xFF0F8644));
//     _colorCollection.add(const Color(0xFF8B1FA9));
//     _colorCollection.add(const Color(0xFFD20100));
//     _colorCollection.add(const Color(0xFFFC571D));
//     _colorCollection.add(const Color(0xFF36B37B));
//     _colorCollection.add(const Color(0xFF01A1EF));
//     _colorCollection.add(const Color(0xFF3D4FB5));
//     _colorCollection.add(const Color(0xFFE47C73));
//     _colorCollection.add(const Color(0xFF636363));
//     _colorCollection.add(const Color(0xFF0A8043));
//   }
// }

// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }

//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }

//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }

//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay;
//   }

//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }

//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
// }

// class Meeting {
//   String? eventName;
//   DateTime? from;
//   DateTime? to;
//   Color? background;
//   bool? isAllDay;
//   String? key;

//   Meeting(
//       {this.eventName,
//       this.from,
//       this.to,
//       this.background,
//       this.isAllDay,
//       this.key});

//   static Meeting fromFireBaseSnapShotData(dynamic element, Color color) {
//     return Meeting(
//         eventName: element.doc.data()!['Subject'],
//         from: DateFormat('dd/MM/yyyy HH:mm:ss')
//             .parse(element.doc.data()!['StartTime']),
//         to: DateFormat('dd/MM/yyyy HH:mm:ss')
//             .parse(element.doc.data()!['EndTime']),
//         background: color,
//         isAllDay: false,
//         key: element.doc.id);
//   }

//   void calendarTapped(CalendarTapDetails details) {
//     if (details.targetElement == CalendarElement.appointment ||
//         details.targetElement == CalendarElement.agenda) {
//       final Meeting _meeting = details.appointments![0];
//     }
//   }
// }
