// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';

// import '../MoodTracker/original/list_of_moods.dart';
// import '../OpenFoodFacts/calorie_tracker_list.dart';
// import '../screens/home_page.dart';

// // State added
// class CustomisedNavigationBar extends StatefulWidget {
//   final double bevel;
//   final Offset blurOffset;
//   final Color color;
//   final EdgeInsets padding;
//   final int selectedIndex;

//   CustomisedNavigationBar({
//     Key? key,
//     this.bevel = 1.0,
//     this.selectedIndex = 0,
//     this.padding = const EdgeInsets.all(1.5),
//   })  : blurOffset = Offset(bevel / 2, bevel / 2),
//         color = Colors.grey,
//         super(key: key);

//   @override
//   _CustomisedNavigationBarState createState() =>
//       _CustomisedNavigationBarState();
// }

// class _CustomisedNavigationBarState extends State<CustomisedNavigationBar> {
//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Colors.black;
//     const secondaryColor = Colors.black;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0, right: 0.0, left: 0.0),
//       child: ClipRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey, width: .28),
//                 borderRadius: BorderRadius.circular(00.0),
//                 color: Colors.grey),
//             child: Stack(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     NavBarIcon(
//                       text: "Home",
//                       icon: Icons.home_outlined,
//                       selected: widget.selectedIndex == 0,
//                       onPressed: () => Get.to(const HomePage()),
//                       defaultColor: secondaryColor,
//                       selectedColor: primaryColor,
//                     ),
//                     NavBarIcon(
//                       text: "BMI",
//                       icon: Icons.monitor_weight_outlined,
//                       selected: widget.selectedIndex == 1,
//                       onPressed: () => widget.selectedIndex == 1
//                           ? Get.to(const BMITDEE())
//                           : Get.to(const BMITDEE()),

//                       // Get.to(const BMITDEE()),
//                       defaultColor: secondaryColor,
//                       selectedColor: secondaryColor,
//                     ),
//                     NavBarIcon(
//                         text: "Food Scanner",
//                         icon: Icons.food_bank_outlined,
//                         selected: widget.selectedIndex == 2,
//                         onPressed: () => Get.to(BarcodeScanner()),
//                         defaultColor: secondaryColor,
//                         selectedColor: primaryColor),
//                     NavBarIcon(
//                       text: "Mood",
//                       icon: Icons.mood,
//                       selected: widget.selectedIndex == 3,
//                       onPressed: () => Get.to(ListMoods()),
//                       selectedColor: primaryColor,
//                       defaultColor: secondaryColor,
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class NavBarIcon extends StatelessWidget {
//   const NavBarIcon(
//       {Key? key,
//       required this.text,
//       required this.icon,
//       required this.selected,
//       required this.onPressed,
//       this.selectedColor = const Color(0xffFF8527),
//       this.defaultColor = Colors.black54})
//       : super(key: key);
//   final String text;
//   final IconData icon;
//   final bool selected;
//   final Function() onPressed;
//   final Color defaultColor;
//   final Color selectedColor;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           padding: EdgeInsets.zero,
//           onPressed: onPressed,
//           icon: Icon(
//             icon,
//             size: 35,
//             color: selected ? selectedColor : defaultColor,
//           ),
//         ),
//         AnimatedContainer(
//           width: selected ? 50 : 0,
//           height: 15,
//           duration: Duration(milliseconds: 250),
//           decoration: BoxDecoration(color: Colors.transparent, boxShadow: [
//             BoxShadow(
//               color: Colors.green.withOpacity(1),
//               blurRadius: 50,
//             )
//           ]),
//         ),
//       ],
//     );
//   }
// }
