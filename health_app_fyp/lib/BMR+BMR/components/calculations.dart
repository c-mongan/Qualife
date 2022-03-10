import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app_fyp/BMR+BMR/screens/main_page.dart';
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
  // ignore: prefer_typing_uninitialized_variables
  final gender;
  late double _bmi;
  late double _tdee;
  DateTime bmiTime = (DateTime.now());
  DateTime tdeeTime = (DateTime.now());

  // String bmiTime = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  // String tdeeTime = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  // String bmiTime =DateTime.now().toString();

  //var gender = '';

  //This line to link database instance with current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  setBmiTime(bmiTime) {
    bmiTime = (DateTime.now());

    // FirebaseFirestore.instance
    //     .collection('UserData')
    //     .doc(uid)
    //     .update({'bmiTime': bmiTime});

//  FirebaseFirestore.instance
//         .collection('UserData')
//         .doc(uid).collection('bmi').doc('bmi')
//         ({'bmiTime': bmiTime});
  }

  String calculateTDEE() {
    if (gender == GenderType.male) {
      _tdee = 9.99 * weight + 6.25 * height - 4.92 * age + 5;
      // FirebaseFirestore.instance
      //     .collection('UserData')
      //     .doc(uid)
      //     .update({'tdee': _tdee.toStringAsFixed(0)});
      //  FirebaseFirestore.instance
      //   .collection('UserTDEE').add({'TDEE': _tdee.toStringAsFixed(0),
      //   'tdeeTime' : tdeeTime,
      //   'userID': uid
      //   });

      return _tdee.toStringAsFixed(0);
    } else {
      _tdee = 9.99 * weight + 6.25 * height - 4.92 * age - 161;
      //  FirebaseFirestore.instance
      //   .collection('UserTDEE').add({'TDEE': _tdee.toStringAsFixed(0),
      //    'tdeeTime' : tdeeTime,
      //   'userID': uid
      //   });

      // FirebaseFirestore.instance
      //     .collection('UserData')
      //     .doc(uid)
      //     .update({'tdee': _tdee.toStringAsFixed(0)});
      return _tdee.toStringAsFixed(0);
    }
  }

  String calculateBMI() {
    _bmi = weight / pow((height / 100), 2);

    // FirebaseFirestore.instance
    //     .collection('UserData')
    //     .doc(uid).collection('bmiData').doc()
    //    . set({'bmiScore': _bmi.toStringAsFixed(1)});
    //    //, SetOptions(merge : true)

    // .doc('bmi')
    // .update({'bmi': _bmi.toStringAsFixed(1)});

    setBmiTime(bmiTime);

    FirebaseFirestore.instance
        .collection('BMI')
        .add({'bmiScore': _bmi, 'bmiTime': bmiTime, 'userID': uid});

    // .doc(uid).collection('bmiData').doc(). set({'bmiTime': bmiTime});
    // , SetOptions(merge : true)

    // .doc('bmi')
// FirebaseFirestore.instance
//         .collection('UserData')
//         .doc(uid).collection('bmiData').doc('bmi').collection('bmiScore').add({'bmiTime': bmiTime});
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi >= 25) {
      return 'Overweight';
    } else if (_bmi > 18.0) {
      return 'Normal';
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
