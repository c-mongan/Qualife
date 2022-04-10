import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';
import 'package:health_app_fyp/BMR+BMR/components/calculations.dart';
import 'package:health_app_fyp/BMR+BMR/components/container_card.dart';
import 'package:health_app_fyp/BMR+BMR/components/gender_icon_content.dart';
import 'package:health_app_fyp/BMR+BMR/screens/bmi_second_page.dart';
import '../../widgets/customnavbar.dart';
import '../../widgets/glassmorphic_bottomnavbar.dart';
import '../../widgets/nuemorphic_button.dart';
import '../colors&fonts.dart';

enum GenderType {
  male,
  female,
}

class BMITDEE extends StatefulWidget {
  const BMITDEE({Key? key}) : super(key: key);

  @override
  _BMITDEEState createState() => _BMITDEEState();
}

class _BMITDEEState extends State<BMITDEE> {
  GenderType selectedGender = GenderType.male;
  int height = 180;
  int weight = 85;
  int age = 20;

  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Center(
            child: Text(
              'BMI Calculator',
            ),
          ),
        ),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    // colors: [Color(0xffFF2400), Colors.white, Color(0xffFF2400)],
                    colors: [
                  Colors.black,
                  Colors.grey,

                  // Color(0xffFF2400),
                  //Color(0xff246EE9),

                  // Colors.orange,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(children: <Widget>[
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ContainerCard(
                        color: kActiveCardColor,
                        childContainer: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Flexible(
                              child: Text(
                                'WEIGHT',
                                style: textStyle2,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: <Widget>[
                                  Text(
                                    weight.toString(),
                                    style: textStyle2,
                                  ),
                                  const Text('kg',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RoundedIconButton(
                                      color: Color(0xff246EE9),
                                      icon: FontAwesomeIcons.minus,
                                      action: () {
                                        setState(() {
                                          weight--;
                                          weight = weight.toInt();
                                          FirebaseFirestore.instance
                                              .collection('UserData')
                                              .doc(uid)
                                              .update({'weight': weight});

                                          if (weight <= 0) {
                                            weight = 0;
                                            FirebaseFirestore.instance
                                                .collection('UserData')
                                                .doc(uid)
                                                .update({'weight': weight});
                                          }
                                        });
                                      }),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  RoundedIconButton(
                                      color: Color(0xff246EE9),
                                      icon: FontAwesomeIcons.plus,
                                      action: () {
                                        setState(() {
                                          weight++;

                                          weight = weight.toInt();
                                          FirebaseFirestore.instance
                                              .collection('UserData')
                                              .doc(uid)
                                              .update({'weight': weight});
                                        });
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ContainerCard(
                        color: kActiveCardColor,
                        childContainer: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Flexible(
                              child: Text(
                                'AGE',
                                style: textStyle2,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                age.toString(),
                                style: textStyle2,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RoundedIconButton(
                                      color: Color(0xff246EE9),
                                      icon: FontAwesomeIcons.minus,
                                      action: () {
                                        setState(() {
                                          age--;
                                          age = age.toInt();
                                          FirebaseFirestore.instance
                                              .collection('UserData')
                                              .doc(uid)
                                              .update({'age': age});
                                          if (age <= 0) {
                                            age = 0;
                                          }
                                        });
                                      }),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  RoundedIconButton(
                                      color: Color(0xff246EE9),
                                      icon: FontAwesomeIcons.plus,
                                      action: () {
                                        setState(() {
                                          age++;
                                          age = age.toInt();
                                          FirebaseFirestore.instance
                                              .collection('UserData')
                                              .doc(uid)
                                              .update({'age': age});
                                        });
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: ContainerCard(
                  color: kActiveCardColor,
                  childContainer: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Flexible(
                        child: Text(
                          'HEIGHT',
                          style: textStyle2,
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              height.toString(),
                              style: textStyle2,
                            ),
                            const Text('cm',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Color(0xff246EE9),
                          thumbColor: Color(0xff246EE9),
                          overlayColor: Colors.indigo.shade300,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 15.0),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 20.0),
                        ),
                        child: Slider(
                          value: height.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              height = newValue.round();
                              FirebaseFirestore.instance
                                  .collection('UserData')
                                  .doc(uid)
                                  .update({'height': height.toInt()});
                            });
                          },
                          min: 80.0,
                          max: 240.0,
                          inactiveColor: Color(0xffFF2400),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ContainerCard(
                        color: selectedGender == GenderType.male
                            ? kActiveCardColor
                            : kInactiveCardColor,
                        childContainer: const GenderIconContent(
                          color: Colors.white,
                          sex: FontAwesomeIcons.mars,
                          label: 'MALE',
                        ),
                        gesture: () {
                          setState(() {
                            selectedGender = GenderType.male;
                            FirebaseFirestore.instance
                                .collection('UserData')
                                .doc(uid)
                                .update({'gender': 'male'});
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ContainerCard(
                        color: selectedGender == GenderType.female
                            ? kActiveCardColor
                            : kInactiveCardColor,
                        childContainer: const GenderIconContent(
                          color: Colors.white,
                          sex: FontAwesomeIcons.venus,
                          label: 'FEMALE', //labelColor: Colors.white,
                        ),
                        gesture: () {
                          setState(() {
                            selectedGender = GenderType.female;
                            FirebaseFirestore.instance
                                .collection('UserData')
                                .doc(uid)
                                .update({'gender': 'female'});
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: NeumorphicButton(
                      child: const Text(
                        'Calculate BMI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        Calculator bmi = Calculator(
                            height: height,
                            weight: weight,
                            gender: selectedGender,
                            age: age);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondPage(
                              bmiResult: bmi.calculateBMI(),
                              resultText: bmi.getResult(),
                              interpretation: bmi.getInterpretation(),
                              tdeeResult: bmi.calculateTDEE(),
                            ),
                          ),
                        );
                      }
                      // },
                      )),
              SizedBox(
                height: 20.0,
              ),
            ])));
  }
}
