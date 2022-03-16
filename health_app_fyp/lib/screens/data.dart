// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:health_app_fyp/ExampleMood/models/mood.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:visibility_detector/visibility_detector.dart';

// class Data extends StatefulWidget {
//   const Data({Key? key}) : super(key: key);
//   static String id = 'chartSlider';

//   @override
//   _DataState createState() => _DataState();
// }

// class _DataState extends State<Data> {
//   late List<MoodData> chartData;
//   @override
//   void initState() {
//     setState(() {});
//     getLatestMood();

//     chartData = getChartData(); //Chart Data Initialised
//     //print(MoodList);
//     super.initState();
//   }

//   String moodNameText1 = "";
//   String moodNameText2 = "";
//   String moodNameText3 = "";
//   String moodNameText4 = "";
//   String moodNameText5 = "";
//   List MoodList = [];
//   int count = 1;
//   bool once = true;

//   Future<String> getLatestMood() async {
//     String Exc = "Error";

//     try {
//       final latestMoodName = await FirebaseFirestore.instance
//           .collection('MoodTracking')
//           .orderBy('DateTime')
//           .where('DateTime',
//               isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
//                   DateTime.now().month, DateTime.now().day, 0, 0))
//           .where('DateTime',
//               isLessThanOrEqualTo: DateTime(DateTime.now().year,
//                   DateTime.now().month, DateTime.now().day, 23, 59, 59))
//           .where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();

//       List count = [];
//       List moods = [];
//       print(latestMoodName.docs.length);
//       for (int i = 0; i < latestMoodName.docs.length; i++) {
//         print(latestMoodName.docs.length);
//         count.add(i);
//         print(count);
//       }
//       for (int i = 0; i < count.length; i++) {
//         moods.add(latestMoodName.docs[i].get("Mood"));
//         print(moods);
//       }
//       var map = Map();
//       moods.forEach((x) => map[x] = !map.containsKey(x) ? (1) : (map[x] + 1));

//       print(map);

//       int AngryCount = (map['Angry']);

//       print(AngryCount);

//       MoodData angry = MoodData("Angry", AngryCount);

//       //chartData.add(angry);

//       if (once = true) {
//         List<MoodData> _addDataPoint() {
//           //final int length = chartData.length;
//           chartData.add(MoodData("Angry", AngryCount));
//           return chartData;
//         }

//         getChartData();
//       }
//       once = false;
//       // print(chartData);

//       // List moods = [];

//       for (var moodName in latestMoodName.docs) {
//         // print(latestMoodName.docs.length);

//         // print(moodName.data());
//         // moodNameText1 = latestMoodName.docs[0].get("Mood");
//         // moodNameText2 = latestMoodName.docs[1].get("Mood");
//         // moodNameText3 = latestMoodName.docs[2].get("Mood");
//         // moodNameText4 = latestMoodName.docs[3].get("Mood");

//         // MoodList.add(moodNameText1);
//         // MoodList.add(moodNameText2);
//         // MoodList.add(moodNameText3);
//         // MoodList.add(moodNameText4);

//         print(moodNameText1);
//         print(moodNameText2);
//         print(moodNameText3);

//         String FirestoreMoodText = moodNameText1;
//         print(FirestoreMoodText);

//         setMoodResult();

//         MoodList.add(FirestoreMoodText);
//         // print(MoodList);

//         //chartData = getChartData(moodNameText1); //Chart Data Initialised
//         return FirestoreMoodText;
//       }
//       return moodNameText1;
//     } catch (Exc) {
//       print(Exc);
//       rethrow;
//     }
//   }

//   void setMoodResult() async {
//     getLatestMood().then((FirestoreMoodText) {
//       moodNameText1 = FirestoreMoodText;
//       // MoodList.add(moodNameText1);
//       // print(MoodList.first);
//     });
//   }

//   void asyncMethod(bool isVisible) async {
//     // await getbmiScore();
//     // await getBMITextResult();
//     // MoodList.clear();

//     await getLatestMood();

//     // MoodList.add(moodNameText1);
//     // MoodList.add(moodNameText2);
//     // MoodList.add(moodNameText3);
//     // MoodList.add(moodNameText4);
//     // print(MoodList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//         key: Key(Data.id),
//         onVisibilityChanged: (VisibilityInfo info) {
//           bool isVisible = info.visibleFraction != 0;
//           asyncMethod(isVisible);
//         },
//         child: SafeArea(
//             child: Scaffold(
//                 body: SfCircularChart(
//           title: ChartTitle(text: 'Your Health Scores (%)'),
//           legend: Legend(
//               isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
//           series: <CircularSeries>[
//             RadialBarSeries<MoodData, String>(
//                 dataSource: chartData,
//                 xValueMapper: (MoodData data, _) => data.Mood,
//                 yValueMapper: (MoodData data, _) => data.Angrycount,
//                 dataLabelSettings: DataLabelSettings(isVisible: true),
//                 enableTooltip: true,
//                 maximumValue: 100)
//           ],
//         ))));
//   }
// }

// List<MoodData> getChartData() {
//   //String moodNameText1
//   List<MoodData> chartData = [
//     //MoodData(moodNameText1, 44),
//     MoodData("Body", 44),
//     MoodData('Mind', 56),
//     MoodData('Lifestyle', 10),
//   ];
//   return chartData;
// }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // //import 'package:flutter_chart_json';
// // import 'package:charts_flutter/flutter.dart' as charts;

// // class Data extends StatefulWidget {
// //   const Data({Key? key}) : super(key: key);

// //   @override
// //   DataPageState createState() {
// //     return DataPageState();
// //   }
// // }

// // class DataPageState extends State<Data> {
// //   late List<charts.Series<dynamic, MoodData>> _seriesPieData;
// //   late List<MoodData> mydata;
// //   _generateData(mydata) {
// //     _seriesPieData = [];
// //     _seriesPieData.add(
// //       charts.Series(
// //         domainFn: (MoodData moodData, _) => moodData.Mood,
// //         measureFn: (MoodData moodData, _) => moodData.Icon.characters as num,
// //         // colorFn: (MoodData moodData, _) =>
// //         //     charts.ColorUtil.fromDartColor(Color(int.parse(moodData.colorVal))),
// //         id: 'tasks',
// //         data: mydata,
// //         labelAccessorFn: (MoodData row, _) => row.Mood,
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Tasks')),
// //       body: _buildBody(context),
// //     );
// //   }

// //   Widget _buildBody(BuildContext context) {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: FirebaseFirestore.instance.collection('MoodTracking').snapshots(),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData) {
// //           return LinearProgressIndicator();
// //         } else {
// //           // ignore: unnecessary_cast
// //           List<MoodData> moodData = snapshot.data!.docs
// //                   .map((DocumentSnapshot doc) =>
// //                       MoodData.fromMap(doc.data()! as Map<String, dynamic>))
// //                   .toList()

// //               //as List<dynamic>;
// //               ;
// //           // List <MoodData> moodData=

// //           // snapshot.data!.docs
// //           //     .map((documentSnapshot) => MoodData.fromMap(documentSnapshot.data())
// //           //     .toList();
// //           return _buildChart(context, moodData);
// //         }
// //       },
// //     );
// //   }

// //   Widget _buildChart(BuildContext context, List<MoodData> taskdata) {
// //     mydata = taskdata;
// //     _generateData(mydata);
// //     return Padding(
// //       padding: EdgeInsets.all(8.0),
// //       child: Container(
// //         child: Center(
// //           child: Column(
// //             children: <Widget>[
// //               Text(
// //                 'Time spent on daily tasks',
// //                 style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(
// //                 height: 10.0,
// //               ),
// //               Expanded(
// //                 child: charts.PieChart<MoodData>(_seriesPieData,
// //                     animate: true,
// //                     animationDuration: Duration(seconds: 5),
// //                     behaviors: [
// //                       charts.DatumLegend(
// //                         outsideJustification:
// //                             charts.OutsideJustification.endDrawArea,
// //                         horizontalFirst: false,
// //                         desiredMaxRows: 2,
// //                         cellPadding:
// //                             EdgeInsets.only(right: 4.0, bottom: 4.0, top: 4.0),
// //                         entryTextStyle: charts.TextStyleSpec(
// //                             color: charts.MaterialPalette.purple.shadeDefault,
// //                             fontFamily: 'Georgia',
// //                             fontSize: 18),
// //                       )
// //                     ],
// //                     defaultRenderer: charts.ArcRendererConfig(
// //                         arcWidth: 100,
// //                         arcRendererDecorators: [
// //                           charts.ArcLabelDecorator(
// //                               labelPosition: charts.ArcLabelPosition.inside)
// //                         ])),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// class MoodData {
//   late String Mood;
//   late int Angrycount;

//   MoodData(this.Mood, this.Angrycount);

//   MoodData.fromMap(Map<String, dynamic> map)
//       : assert(map['Mood'] != null),
//         Mood = 'Mood';

//   @override
//   String toString() => "Record<$Mood:$Icon>";

//   toList() {}
// }

// void callThisMethod(bool isVisible) {
//   debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
// }
