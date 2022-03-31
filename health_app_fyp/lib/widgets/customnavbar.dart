import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/screens/main_page.dart';
import 'package:health_app_fyp/screens/HOME.dart';

import '../MoodTracker/original/ListOfMoods.dart';
import '../OpenFoodFacts/FirstPageBarcodeScanner.dart';

class CustomisedNavigationBar extends StatelessWidget {
  const CustomisedNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey,
      child: SizedBox(
        height: 70,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
            onPressed: () {
              Get.to(const HomePage());
            },
            icon: const Icon(
              Icons.home,
              // color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(const BMITDEE());
            },
            icon: const Icon(
              Icons.monitor_weight_outlined,
              // color: Colors.blue,
            ),
          ),
          IconButton(
              icon: Icon(Icons.food_bank_outlined),
              onPressed: () {
                Get.to(BarcodeScanner());
              }),
          IconButton(
              icon: Icon(Icons.mood),
              onPressed: () {
                Get.to(ListMoods());
              }),
        ]),
      ),
    );
  }
}
