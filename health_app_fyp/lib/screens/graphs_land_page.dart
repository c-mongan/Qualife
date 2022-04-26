import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/BMR+BMR/colors&fonts.dart';
import 'package:health_app_fyp/MoodTracker/moodIcon.dart';
import 'package:health_app_fyp/screens/bmi_graph.dart';
import 'package:health_app_fyp/screens/pie_chart_screen.dart';
import 'package:health_app_fyp/screens/range_selector_zoom.dart';
import 'package:health_app_fyp/widgets/customnavbar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:pie_chart/pie_chart.dart';
import '../model/user_model.dart';
import '../widgets/glassmorphic_bottomnavbar.dart';
import '../widgets/nuemorphic_button.dart';
import 'graphs.dart';
import 'home_page.dart';
import 'login_screen.dart';

class GraphsHome extends StatefulWidget {
  const GraphsHome({Key? key}) : super(key: key);

  static String id = 'GraphLandPage';

  @override
  _GraphPageState createState() => _GraphPageState();
}

User? user = FirebaseAuth.instance.currentUser;
UserModel loggedInUser = UserModel();

class _GraphPageState extends State<GraphsHome> {
  int key = 0;

  @override
  Widget build(BuildContext context) //=> Scaffold( {
  {
    return VisibilityDetector(
        key: Key(GraphsHome.id),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          //asyncMethod(isVisible);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Graphs'),
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            bottomNavigationBar: CustomisedNavigationBar(),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.black,
                  Colors.grey,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: SingleChildScrollView(
                    // <-- wrap this around
                    child: Column(children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          CustomListTile(
                              text: "Daily Check In",
                              leadingIcon: Icon(Icons.today),
                              trailingIcon: Icon(Icons.chevron_right),
                              onTap: () {
                                Get.to(CheckInGraph());
                              },
                              color: Color.fromARGB(255, 255, 255, 255)),
                          const Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          CustomListTile(
                              text: "BMI Chart",
                              leadingIcon: Icon(Icons.monitor_weight),
                              trailingIcon: Icon(Icons.chevron_right),
                              onTap: () {
                                Get.to(RangeSelectorZoomingPage());
                              },
                              color: Color.fromARGB(255, 255, 255, 255)),
                          const Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),

                          CustomListTile(
                              text: "Pie Charts",
                              leadingIcon: Icon(Icons.pie_chart),
                              trailingIcon: Icon(Icons.chevron_right),
                              onTap: () {
                                Get.to(PieChartSelect());
                              },
                              color: Color.fromARGB(255, 255, 255, 255)),
                          const Divider(
                            color: Colors.grey,
                            thickness: 2,
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          NeumorphicButton(
                            child: const Text('Zoom Graphs',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            onPressed: () {
                              Get.to(RangeSelectorZoomingPage());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ])))));
  }
}

void callThisMethod(bool isVisible) {
  debugPrint('_HomeScreenState.callThisMethod: isVisible: $isVisible');
}
