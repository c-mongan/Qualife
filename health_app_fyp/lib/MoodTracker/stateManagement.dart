// import 'package:flutter/cupertino.dart';
// import 'package:health_app_fyp/MoodTracker/db_helper.dart';

// import 'models.dart';

// class MoodCard extends ChangeNotifier {
//   late String datetime;
//   String mood;
//   List<String> activityname = [];
//   List<String> activityimage = [];
//   String image;
//   String actimage;
//   String actname;
//   MoodCard({required this.actimage,required this.actname,required  this.datetime,required this.image,required this.mood});
//  late  List items;
//   List<MoodData> data=[];
//   late String date;
//   bool isloading=false;
//   List<String> actiname=[];


//   void add(Activity act) {
//     activityimage.add(act.image);
//     activityname.add(act.name);
//   }

//   notifyListeners();

//   Future<void> addPlace(
//     String datetime,
//     String mood,
//     String image,
//     String actimage,
//     String actname,
//     String date
//   ) async {
//     DBHelper.insert('user_moods', {
//       'datetime': datetime,
//       'mood': mood,
//       'image': image,
//       'actimage': actimage,
//       'actname': actname,
//       'date':date
//     });
//     notifyListeners();
//   }

//   Future<void> deletePlaces(String datetime) async {
//     DBHelper.delete(datetime);
//     notifyListeners();
//   }
// }