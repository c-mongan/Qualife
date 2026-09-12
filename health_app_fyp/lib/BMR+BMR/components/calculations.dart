import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';
import 'package:intl/intl.dart';

import 'health_calculations.dart';

class Calculator {
  Calculator(
      {required this.height,
      required this.weight,
      required this.gender,
      required this.age});
  final int height;
  final int weight;
  final int age;

  final gender;
  late double _bmi;
  late double _tdee;
  DateTime bmiTime = (DateTime.now());
  DateTime tdeeTime = (DateTime.now());

  //This line to link database instance with current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  setBmiTime(bmiTime) {
    bmiTime = (DateTime.now());
  }

  String calculateTDEE() {
    _tdee = calculateBasalMetabolicRate(
      heightCentimetres: height,
      weightKilograms: weight,
      ageYears: age,
      gender: gender == GenderType.male ? BmrGender.male : BmrGender.female,
    );
    return _tdee.toStringAsFixed(0);
  }

  String calculateBMI() {
    _bmi = calculateBodyMassIndex(
      heightCentimetres: height,
      weightKilograms: weight,
    );

    setBmiTime(bmiTime);
    String result = getResult();

    FirebaseFirestore.instance.collection('BMI').add({
      'bmiScore': _bmi,
      'bmiTime': bmiTime,
      'userID': uid,
      'result': result
    });

    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    return classifyBodyMassIndex(_bmi);
  }

  String getInterpretation() {
    return interpretBodyMassIndex(_bmi);
  }
}
