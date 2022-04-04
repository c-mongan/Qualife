import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';
import 'package:health_app_fyp/BMR+BMR/components/container_card.dart';
import 'package:intl/intl.dart';
import 'package:health_app_fyp/screens/home_page.dart';
import '../../widgets/customnavbar.dart';
import '../colors&fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ActivityLevel {
  level_0,
  level_1,
  level_2,
  level_3,
  level_4,
}

enum WeightGoal {
  lose,
  gain,
  keep,
}

class SecondPage extends StatefulWidget {
  final String tdeeResult;
  final String bmiResult;
  final String resultText;
  final String interpretation;

  // ignore: use_key_in_widget_constructors
  const SecondPage(
      {required this.resultText,
      required this.interpretation,
      required this.bmiResult,
      required this.tdeeResult});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  ActivityLevel selectedLevel = ActivityLevel.level_0;
  WeightGoal selectedGoal = WeightGoal.keep;
  double endTDEE = 0;
  DateTime tdeeTime = (DateTime.now());

  //  FirebaseFirestore.instance
  //       .collection('TDEE').add({'TDEE':  endTDEE.toStringAsFixed(0),
  //        'tdeeTime' : tdeeTime,
  //       'userID': uid
  //       });
  double finalTDEE() {
    endTDEE = 0;
    // FirebaseFirestore.instance
    //     .collection('UserData')
    //     .doc(uid)
    //     .update({'tdee': endTDEE.toStringAsFixed(0)});
    if (selectedLevel == ActivityLevel.level_0) {
      endTDEE = 1.2 * double.parse(widget.tdeeResult);
      // FirebaseFirestore.instance
      //     .collection('UserData')
      //     .doc(uid)
      //     .update({'tdee': endTDEE.toStringAsFixed(0)});
      if (selectedGoal == WeightGoal.lose) {
        endTDEE -= 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.gain) {
        endTDEE += 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.keep) {
        return endTDEE;
      }
    } else if (selectedLevel == ActivityLevel.level_1) {
      endTDEE = 1.35 * double.parse(widget.tdeeResult);

      if (selectedGoal == WeightGoal.lose) {
        endTDEE -= 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.gain) {
        endTDEE += 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.keep) {
        return endTDEE;
      }
    } else if (selectedLevel == ActivityLevel.level_2) {
      endTDEE = 1.55 * double.parse(widget.tdeeResult);

      if (selectedGoal == WeightGoal.lose) {
        endTDEE -= 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.gain) {
        endTDEE += 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.keep) {
        return endTDEE;
      }
    } else if (selectedLevel == ActivityLevel.level_3) {
      endTDEE = 1.75 * double.parse(widget.tdeeResult);

      if (selectedGoal == WeightGoal.lose) {
        endTDEE -= 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.gain) {
        endTDEE += 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.keep) {
        return endTDEE;
      }
    } else if (selectedLevel == ActivityLevel.level_4) {
      endTDEE = 2.05 * double.parse(widget.tdeeResult);

      if (selectedGoal == WeightGoal.lose) {
        endTDEE -= 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.gain) {
        endTDEE += 250;

        return endTDEE;
      } else if (selectedGoal == WeightGoal.keep) {
        return endTDEE;
      }
    } else {
      return endTDEE = 0;
    }
    return endTDEE = 0;
  }

  late double returnedTDEE;

  @override
  void initState() {
    super.initState();
    returnedTDEE = finalTDEE();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;
  int activityLevel = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: kAppBarColor,
        //   elevation: 0,
        //   title: const Center(
        //     child: Text(
        //       'TDEE Calculator',
        //       style: TextStyle(
        //         fontFamily: "Jaapokki",
        //       ),
        //     ),
        //   ),
        // ),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  // colors: [Colors.red, Colors.white, Colors.red],
                  colors: [
                // Colors.red,
                // Color(0xff246EE9),

                Colors.black,
                Colors.grey

                // Colors.orange,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          // child: SingleChildScrollView(
          //     // <-- wrap this around
          //     child: Column(children: <Widget>[
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    children: <Widget>[
                      Text('Your BMI: ${widget.bmiResult}',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      // Container(
                      //   height: 150,
                      //Expanded(
                      // child:
                      ContainerCard(
                        color: (widget.resultText == 'Underweight' ||
                                widget.resultText == 'Overweight')
                            ? const Color(0xFFFEEAEA)
                            : const Color(0xFFE3FFEE),
                        childContainer: Container(
                          padding: const EdgeInsets.all(2.0),
                          height: 100,
                          child: Center(
                            child: Text(
                              widget.resultText.toUpperCase(),
                              style: kResultsTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: (widget.resultText == 'Underweight' ||
                                        widget.resultText == 'Overweight' ||
                                        widget.resultText == 'Obese')
                                    ? const Color(0xFFF95F49)
                                    : const Color(0xFF48C67D),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // )
                      // ,
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        bottom: 100.0,
                                        top: 20.0),
                                    child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEDE4FE),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Text(
                                              '< 18,5 – Underweight',
                                              style: kInfoTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '18,5 – 24,99 – Healthy weight',
                                              style: kInfoTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '≥ 25,0 – Overweight',
                                              style: kInfoTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                  );
                                });
                          },
                          icon: const Icon(
                            FontAwesomeIcons.infoCircle,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ContainerCard(
                  radius: 10.0,
                  color: const Color(0xFFEDE4FE),
                  childContainer: Container(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Expanded(
                          //  child:
                          SizedBox(
                            height: 20.0,
                            child: Text(
                              widget.interpretation,
                              style: kBodyTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // )
                          // ,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text('Your activity level:',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                        //.copyWith(color: Colors.black87)),
                        ),
                  )),
              Expanded(
                flex: 2,
                child: ListView(
                  children: <Widget>[
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedLevel = ActivityLevel.level_0;
                          activityLevel = 0;
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(uid)
                              .update({'activityLevel': activityLevel});
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedLevel == ActivityLevel.level_0
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'No activity',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Text(
                                '(sedentary work)',
                                textAlign: TextAlign.center,
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedLevel = ActivityLevel.level_1;
                          activityLevel = 1;
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(uid)
                              .update({'activityLevel': activityLevel});
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedLevel == ActivityLevel.level_1
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'Low activity',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Text(
                                '(1-2 workouts per week)',
                                textAlign: TextAlign.center,
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedLevel = ActivityLevel.level_2;
                          activityLevel = 2;
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(uid)
                              .update({'activityLevel': activityLevel});
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedLevel == ActivityLevel.level_2
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'Average activity',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '(3-4 workouts per week,',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'sedentary work)',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedLevel = ActivityLevel.level_3;
                          activityLevel = 3;
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(uid)
                              .update({'activityLevel': activityLevel});
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedLevel == ActivityLevel.level_3
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'High activity',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '(3-4 workouts per week,',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'physical work)',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedLevel = ActivityLevel.level_4;
                          activityLevel = 4;
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(uid)
                              .update({'activityLevel': activityLevel});
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedLevel == ActivityLevel.level_4
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'Very high activity',
                                  textAlign: TextAlign.center,
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Text(
                                '(daily workouts)',
                                textAlign: TextAlign.center,
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 26.0, right: 26.0),
                child: Divider(
                  color: Colors.black,
                  height: 16.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text('Your goal:',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  // .copyWith(
                  //     color: Colors.black87)
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView(
                  children: <Widget>[
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedGoal = WeightGoal.lose;
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedGoal == WeightGoal.lose
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'Lose weight',
                                textAlign: TextAlign.center,
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedGoal = WeightGoal.keep;
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedGoal == WeightGoal.keep
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'Keep weight',
                                textAlign: TextAlign.center,
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ContainerCard(
                      gesture: () {
                        setState(() {
                          selectedGoal = WeightGoal.gain;
                          returnedTDEE = finalTDEE();
                        });
                      },
                      color: selectedGoal == WeightGoal.gain
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      childContainer: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                'Gain weight',
                                textAlign: TextAlign.center,
                                style: kLabelTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 26.0, right: 26.0),
                child: Divider(
                  color: Colors.black,
                  height: 16.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text('You should eat:',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    ContainerCard(
                      color: const Color(0xFFE4EEFF),
                      childContainer: Container(
                        padding: const EdgeInsets.only(left: 25.0, right: 5.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(returnedTDEE.toStringAsFixed(0),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff246EE9))),
                              Text(
                                'kcal',
                                style: kKcalTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Button(
                        color: kBottomReturnButtonColor,
                        text: const Text('RETURN', style: textStyle1
                            //TextStyle(
                            // fontFamily: "Jaapokki",
                            // )
                            //,
                            ),
                        onTap: () {
                          //CREATING A TDEE ENTRY FOR TIMESTAMP PURPOSES
                          Navigator.pop(context);
                          FirebaseFirestore.instance.collection('TDEE').add({
                            'tdee': endTDEE,
                            'tdeeTime': tdeeTime,
                            'userID': uid
                          });

                          FirebaseFirestore.instance
                              .collection('remainingCalories')
                              .add({
                            'userID': uid,
                            'Cals': endTDEE,
                            'DateTime': tdeeTime,
                          });

//UPDATE TDEE VALUE THAT WE WILL USE FOR DEDUCTING FOOD CALORIES
                          FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(uid)
                              .update({'tdee': endTDEE});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ]
          // )
          // )
        ));
  }
}
