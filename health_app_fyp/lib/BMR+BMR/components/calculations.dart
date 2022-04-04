import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';
import 'package:intl/intl.dart';

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
    if (gender == GenderType.male) {
      _tdee = 9.99 * weight + 6.25 * height - 4.92 * age + 5;

      return _tdee.toStringAsFixed(0);
    } else {
      _tdee = 9.99 * weight + 6.25 * height - 4.92 * age - 161;

      return _tdee.toStringAsFixed(0);
    }
  }

  String calculateBMI() {
    _bmi = weight / pow((height / 100), 2);

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
    if (_bmi >= 30) {
      return 'Obese';
    } else if (_bmi >= 25) {
      return 'Overweight';
    } else if (_bmi > 18.0) {
      return 'Healthy';
    } else {
      return 'Underweight';
    }
  }

  String getInterpretation() {
    if (_bmi < 18.5) {
      return 'Your BMI score is too low. Consider eating in a caloric surplus ';
    } else if (_bmi >= 25.0) {
      return 'You BMI score is too high. Consider eating in a caloric deficit.';
    } else {
      return 'Good job  You have a healthy BMI score.';
    }
  }
}
