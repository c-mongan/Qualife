import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app_fyp/BMR+BMR/screens/main_page.dart';
import 'package:health_app_fyp/MoodTracker/original/ListOfMoods.dart';
import 'package:health_app_fyp/OpenFoodFacts/FirstPageBarcodeScanner.dart';
import 'package:health_app_fyp/model/user_model.dart';
import 'package:health_app_fyp/screens/data.dart';
//import 'package:health_app_fyp/screens/chartbackup.txt';
import 'package:health_app_fyp/screens/home_screen.dart';
import 'package:health_app_fyp/screens/login_screen.dart';
import 'package:health_app_fyp/screens/simplelinechart.dart';
import 'package:health_app_fyp/screens/stackOverflowChart.dart';

//import '../MoodTracker/MoodHome.dart';
import '../MoodTracker/original/MoodHome.dart';
import '../MoodTracker/original/SFexample.dart';
import 'chart.dart';
import 'originalchart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  int currentIndex = 0; //index count for nav bar

  //Screens will be replaced by pages, e.g.

  var screens = [
    // const HomePage(),
    //Profile(),

    const ChartSlider(),

    //Data(),
    //const LineChartSample2(),

    //SlidersWithFireBaseDemo(),

    //FoodScreen(),
    // MainScreen(),
    //BMI(),
    //BMR(),
    //BMITDEE(),
    const BMITDEE(),
    //SecondPage(resultText: "NICE", interpretation: "YUP", bmiResult: "28", tdeeResult: "tdeeResult"),

    // ScanHomePage(
    //   title: 'Barcode Scanner',
    // ),

    MyTest(),

    ListMoods(),
  ];

  // final screens = [
  //Center(child: Text('Home', style: TextStyle(fontSize: 40))),
  //Center(child: Text('Feed', style: TextStyle(fontSize: 40))),
  //Center(child: Text('Chat', style: TextStyle(fontSize: 40))),
  // Center(child: Text('Profile', style: TextStyle(fontSize: 40))),
  // Center(child: Text('Exit', style: TextStyle(fontSize: 40))),
  //];

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection('UserData')
    //         .doc(user?.uid)
    //         .snapshots(),
    //     builder: (BuildContext context, snapshot) {
    //       if (snapshot.hasData) {
    //         Measurements measurements =
    //             Measurements.fromSnapshot(snapshot.data, user?.uid);
    //         return Chart(measurements: measurements);

    //       }

    return Scaffold(
// Use this if you want welcome on the top
      // appBar: AppBar(title: const Text("Welcome"), centerTitle: true),

      //This might work for dynamically chaging title but other way is better
      //appBar: AppBar(title: screens[currentIndex], centerTitle: true,),

// This is the body of the welcome page below
//from our registration app

      /* body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 150,
                  child: Image.asset("assets/logo.png", fit: BoxFit.contain)),
              // ignore: prefer_const_constructors
              Text(
                "Welcome To The Home Page",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 10,
              ),
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Text("${loggedInUser.email}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: const Text("Log Out"),
                  onPressed: () {
                    logout(context);
                  }),
            ],
          ),
        ),
      ),
      */

      //Use this for stateless Pages
      //body: screens[currentIndex],

      //Use this for stateful Pages

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
//bottomNavigationBar:

      bottomNavigationBar: 
      CustomNavBar(),
    );
    // });
  }

  BottomNavigationBar CustomNavBar() {
    return BottomNavigationBar(
      //type: BottomNavigationBarType.fixed, For less dynamic
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      iconSize: 30, //individual icon size
      selectedFontSize: 25,
      unselectedFontSize: 15,
      showUnselectedLabels: false,
      //elevation: 0,
      //showSelectedLabels: false, Use this to get rid of labels
      //Still need to add a label name to avoid errors however

      //On tap changes which label text comes up when you click it
      onTap: (index) => setState(() => currentIndex = index),
      //Set state as the class extends stateful widget ^^^ Top of page
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.grey,
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.pie_chart),
        //   label: 'Chart',
        //   backgroundColor: Colors.black,
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.add_chart),
        //   label: 'Line Chart',
        //   backgroundColor: Colors.red,
        // ),

        // BottomNavigationBarItem(
        //   icon: Icon(Icons.food_bank_outlined),
        //   label: 'API',
        //   backgroundColor: Colors.red,
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monitor_weight_outlined),
          label: 'BMI',
          backgroundColor: Colors.blue,
        ),

        //   BottomNavigationBarItem(
        //   icon: Icon(Icons.monitor_weight_outlined),
        //   label: 'TDEE',
        //   backgroundColor: Colors.black,
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.food_bank_outlined),
          label: 'Barcode',
          backgroundColor: Colors.blue,
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.mood),
          label: 'Mood tracker',
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
    Fluttertoast.showToast(msg: "Logout Successful! ");
  }
}
