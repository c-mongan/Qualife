import 'package:flutter/cupertino.dart';
//import 'package:health_app_fyp/ExampleMood/helpers/mooddata.dart';

import 'activity.dart';

class MoodCard extends ChangeNotifier {
  String datetime;
  String mood;
  List<String> activityname = [];
  List<String> activityimage = [];
  String image;
  String actimage;
  String actname;
  MoodCard(
      {required this.actimage,
      required this.actname,
      required this.datetime,
      required this.image,
      required this.mood});
  late List items;
  late String date;
  bool isloading = false;
  List<String> actiname = [];

  void add(Activity act) {
    activityimage.add(act.image);
    activityname.add(act.name);
    notifyListeners();
  }
}
