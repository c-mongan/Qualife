import 'package:flutter/material.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set app bar and body in MainScreen()

//Changed them color with "theme"
    return MaterialApp(
        debugShowCheckedModeBanner:
            false, //Gets rid of debug mode icon in top right
        theme: ThemeData(
            primaryColor: Colors.white,
            //Specify theme color above (White)

            scaffoldBackgroundColor: Colors.white
            //Specify Scaffold color (White)

            //Set home screen to MainScreen class
            ),
        home: const MainScreen());

    //Scaffold was removed from here and
    //pasted into MainScreen
    //Class below , Home screen then set to
//MainScreen
  }
}
