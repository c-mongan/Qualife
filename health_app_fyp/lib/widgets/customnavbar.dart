import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';
import 'package:health_app_fyp/SleepTracker/list_of_sleep_time.dart';
import 'package:health_app_fyp/screens/graphs_land_page.dart';
import 'package:health_app_fyp/screens/home_page.dart';

import '../MoodTracker/original/list_of_moods.dart';
import '../OpenFoodFacts/calorie_tracker_list.dart';

class CustomisedNavigationBar extends StatelessWidget {
  CustomisedNavigationBar({
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
              Icons.home_outlined,
              size: 30,

              // color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(const BMITDEE());
            },
            icon: const Icon(
              Icons.monitor_weight_outlined,
              size: 30,
              // color: Colors.blue,
            ),
          ),
          IconButton(
              icon: const Icon(
                Icons.food_bank_outlined,
                size: 30,
              ),
              onPressed: () {
                Get.to(const BarcodeScanner());
              }),
          IconButton(
              icon: const Icon(
                Icons.mood,
                size: 30,
              ),
              onPressed: () {
                Get.to(const ListMoods());
              }),
          IconButton(
              icon: const Icon(
                Icons.bedroom_child_outlined,
                size: 30,
              ),
              onPressed: () {
                Get.to(const ListSleep());
              }),
          IconButton(
              icon: const Icon(
                Icons.analytics_outlined,
                size: 30,
              ),
              onPressed: () {
                Get.to(const GraphsHome());
              }),
        ]),
      ),
    );
  }
}
