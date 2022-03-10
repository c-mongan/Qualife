// ignore_for_file: empty_statements

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:visibility_detector/visibility_detector.dart';

// class ChartSlider extends StatefulWidget {
//   @override
//     _ChartState createState() => _ChartState();
// }

// class _ChartState extends State<ChartSlider> {
//   final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

class ChartSlider extends StatefulWidget {
  const ChartSlider({Key? key}) : super(key: key);

  static String id = 'chartSlider';

  // ignore: use_key_in_widget_constructors

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<ChartSlider> {
  //final Stream<QuerySnapshot> _usersDataStream = FirebaseFirestore.instance.collection('UserData').snapshots();
  //String uid = FirebaseAuth.instance.currentUser!.uid;
//Stream documentStream = FirebaseFirestore.instance.collection('UserData').doc().snapshots();

  @override
  void initState() {
    //getbmiScore();
    //asyncMethod();
    super.initState();

    setState(() {});
  }

//   @override
// void initState() {
//   super.initState();
//   asyncMethod();		// async is not allowed in initState()
// }

  void asyncMethod(bool isVisible) async {
    await getbmiScore();
    // await getbmiScore();
    // ....
  }

  double gotbmiScore = 0;
  double bmiScore = 0;

  Future<double> getbmiScore() async {
    String Exc = "Error";

    try {
      final bmiData = await FirebaseFirestore.instance
          .collection('BMI')
          .orderBy("bmiTime")
          .limitToLast(1)
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      for (var name in bmiData.docs) {
        print(name.data());
        bmiScore = bmiData.docs[0].get("bmiScore");
        //print(text1);
        double gotbmiScore = bmiScore;
        print(gotbmiScore);

        setState(() {
          gotbmiScore = bmiScore;
        });
        return gotbmiScore;
      }

      return bmiScore;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) //=> Scaffold( {
  {
    return VisibilityDetector(
        key: Key(ChartSlider.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          asyncMethod(isVisible);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('BMI'),
              elevation: 0,
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        // colors: [Colors.red, Colors.white, Colors.red],
                        colors: [
                      Colors.red,
                      Colors.blue,
                      // Colors.orange,
                    ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // const Text(
                        //   "Your BMI is : ",
                        //   style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black),
                        // ),
                        SizedBox(
                          height: 75,
                          child: Text(
                            "Your BMI Score is : " +
                                bmiScore.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            height: 10,
                            // child: SfSlider(
                            //   showLabels: true,
                            //   min: 10,
                            //   max: 40,
                            //   interval: 5,

                            //   value: bmiScore,
                            //   // value: 30,

                            //   showTicks: true,
                            //   onChanged: null,
                            // ),

                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10.0,
                                trackShape: const RoundedRectSliderTrackShape(),
                                activeTrackColor: Colors.red,
                                inactiveTrackColor: Colors.red,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 14.0,
                                  pressedElevation: 8.0,
                                ),
                                thumbColor: Colors.red,
                                overlayColor: Colors.blue.withOpacity(0.10),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 32.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.blueAccent,
                                inactiveTickMarkColor: Colors.white,
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.blue,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              child: Slider(
                                min: 0.0,
                                max: 150.0,
                                value: bmiScore,
                                divisions: 10,
                                label: '${bmiScore.toStringAsFixed(1)}',
                                onChanged:
                                    // null
                                    (bmiScore) {
                                  setState(() {
                                    bmiScore = bmiScore;
                                  });
                                },
                              ),
                            )),
                      ]),
                )))));
  }
}

void callThisMethod(bool isVisible) {
  debugPrint('_HomeScreenState.callThisMethod: isVisible: ${isVisible}');
}
