import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Data extends StatefulWidget {
  @override
  DataState createState() => DataState();
}

class DataState extends State<Data> {
  int key = 0;

  late List<Mood> _moods = [];

  Map<String, double> getMoodData() {
    Map<String, double> catMap = {};
    for (var item in _moods) {
      print(item.mood);
      if (catMap.containsKey(item.mood) == false) {
        catMap[item.mood] = 1;
      } else {
        catMap.update(item.mood, (int) => catMap[item.mood]! + 1);
        // test[item.mood] = test[item.mood]! + 1;
      }
      print(catMap);
    }
    return catMap;
  }

  List<Color> colorList = [
    Color.fromRGBO(82, 98, 255, 1),
    Color.fromRGBO(46, 198, 255, 1),
    Color.fromRGBO(123, 201, 82, 1),
    Color.fromRGBO(255, 171, 67, 1),
    Color.fromRGBO(252, 91, 57, 1),
    Color.fromRGBO(139, 135, 130, 1),
  ];

  Widget pieChartExampleOne() {
    return PieChart(
      key: ValueKey(key),
      dataMap: getMoodData(),
      initialAngleInDegree: 0,
      animationDuration: Duration(milliseconds: 2000),
      chartType: ChartType.ring,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      ringStrokeWidth: 32,
      colorList: colorList,
      chartLegendSpacing: 32,
      chartValuesOptions: ChartValuesOptions(
          showChartValuesOutside: true,
          showChartValuesInPercentage: true,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      centerText: 'Mood',
      legendOptions: LegendOptions(
          showLegendsInRow: false,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendPosition: LegendPosition.right,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> expStream = FirebaseFirestore.instance
        .collection('MoodTracking')
        .orderBy("DateTime")
        .where('DateTime',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0, 0))
        .where('DateTime',
            isLessThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day + 10, 23, 59, 59))
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    void getExpfromSanapshot(snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _moods = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          var a = snapshot.docs[i];
          // print(a.data());
          Mood emotion = Mood.fromJson(a.data());
          _moods.add(emotion);
          // print(emotion);
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            StreamBuilder<Object>(
              stream: expStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final data = snapshot.requireData;
                print("Data: $data");
                getExpfromSanapshot(data);
                return pieChartExampleOne();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Mood {
  String mood;

  Mood({
    required this.mood,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      mood: json['Mood'],
    );
  }
}

// // Sample data for PiChart
// Map<String, double> dataMap = {
//   "Food": 4,
//   "Health": 3,
//   "Social Life": 2,
// };

// // Sample data for Mood list
// List<Mood> getExpenseList() {
//   final List<Mood> chartData = [
//     Mood(
//       mood: "RM100",
//     ),
//     Mood(
//       mood: "RM200",
//     ),
//     Mood(
//       mood: "RM200",
//     ),
//     Mood(
//       mood: "RM45",
//     ),
//     Mood(
//       mood: "RM80",
//     ),
//   ];
//   return chartData;
// }
