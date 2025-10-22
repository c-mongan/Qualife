//SET STATE ERROR










// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';
// import 'package:health_app_fyp/screens/home_page.dart';

// import '../MoodTracker/original/list_of_moods.dart';
// import '../OpenFoodFacts/calorie_tracker_list.dart';

// // class CustomisedNavigationBar extends StatefulWidget {
// //    CustomisedNavigationBar({
// //     Key? key,
// //   }) : super(key: key);

// class CustomisedNavigationBar extends StatefulWidget {
//   const CustomisedNavigationBar({Key? key}) : super(key: key);

//   @override
//   State<CustomisedNavigationBar> createState() =>
//       _CustomisedNavigationBarState();
// }

// class _CustomisedNavigationBarState extends State<CustomisedNavigationBar> {
//   int _selectedIndex = 0;

//   void setStateIfMounted(f) {
//     if (mounted) setState(f);
//   }

//   void onTabTapped(int index) {
//     setStateIfMounted(() {
//       _selectedIndex = index;

//       if (_selectedIndex == 1) {
//         Get.to(HomePage());
//       }
//       if (_selectedIndex == 2) {
//         Get.to(BmiMainPage());
//       }
//       if (_selectedIndex == 3) {
//         Get.to(CalorieTracker());
//       }
//       if (_selectedIndex == 4) {
//         Get.to(ListOfMoods());
//       }

//       ///call your PageController.jumpToPage(index) here too, if needed
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.grey,
//       child: SizedBox(
//         height: 70,
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//           IconButton(
//             onPressed: () {
//               onTabTapped(1);
//               // Get.to(const HomePage());
//             },
//             icon: Icon(Icons.home_outlined,
//                 size: 30,
//                 color: _selectedIndex == 1 ? Colors.indigo : Colors.white

//                 // color: Colors.red,
//                 ),
//           ),
//           IconButton(
//             onPressed: () {
//               onTabTapped(2);
//               // Get.to(const BMITDEE());
//             },
//             icon: Icon(Icons.monitor_weight_outlined,
//                 size: 30,
//                 color: _selectedIndex == 2 ? Colors.indigo : Colors.white
//                 // color: Colors.blue,
//                 ),
//           ),
//           IconButton(
//               icon: Icon(Icons.food_bank_outlined,
//                   size: 30,
//                   color: _selectedIndex == 3 ? Colors.indigo : Colors.white),
//               onPressed: () {
//                 onTabTapped(3);
//                 //  Get.to(BarcodeScanner());
//               }),
//           IconButton(
//               icon: Icon(Icons.mood,
//                   size: 30,
//                   color: _selectedIndex == 4 ? Colors.indigo : Colors.white),
//               onPressed: () {
//                 onTabTapped(4);
//                 // Get.to(ListMoods());
//               }),
//         ]),
//       ),
//     );
//   }
// }
