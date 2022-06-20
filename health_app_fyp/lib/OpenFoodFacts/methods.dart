import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Methods {
  final foodTrackerLogger = DatadogSdk.instance.createLogger(
    LoggingConfiguration(loggerName: 'Calorie Tracker Logger'),
  );
  getTDEE() async {
    final documents = await FirebaseFirestore.instance
        .collection('TDEE')
        .where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userTDEE = documents.docs.first.data;
    String sTDEE = userTDEE.toString();

    return sTDEE;
  }

  void deductCal(String tdee, double energy100gKcal, uid, inputTime) {
    double result = double.parse(tdee);
    double calRemaining = result - energy100gKcal;
    print(tdee + " " + "kcal");
    print(calRemaining.toString() + "kcal");

//Allows us to see how many of our users are overconsuming calories
    if (calRemaining < 0) {
      foodTrackerLogger.info(
          "User $uid has exceeded their daily recommended calorie intake by $calRemaining calories today");
    }

    FirebaseFirestore.instance.collection('CalorieCount').add({
      'Date/Time': inputTime,
      'Calories remaining': calRemaining.toStringAsFixed(2),
      'userID': uid
      //This is where to do calculation and update firebase
    });
  }
}
