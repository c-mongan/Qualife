// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:health_app_fyp/BMR+BMR/screens/main_page.dart';
// import 'package:health_app_fyp/screens/chart.dart';

// class CustomisedNavigationBar extends StatelessWidget {
//   const CustomisedNavigationBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.grey,
//       child: SizedBox(
//         height: 70,
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//           IconButton(
//             onPressed: () {
//               Get.to(const ChartSlider());
//             },
//             icon: const Icon(
//               Icons.home,
//               color: Colors.red,
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               Get.to(const BMITDEE());
//             },
//             icon: const Icon(
//               Icons.shopping_cart_outlined,
//               color: Colors.blue,
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               //Navigator.pushNamed(context, "/user");
//             },
//             icon: const Icon(
//               Icons.person_outlined,
//               color: Colors.white,
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
