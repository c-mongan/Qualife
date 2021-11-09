

import 'package:flutter/material.dart';

void main() {
  // Main method
  runApp(
      const MyApp()); // MyApp class defined below , creating new instance of class
}

class MyApp extends StatelessWidget {
  //StatelessWidget is the parent class
  // Doesn't have state (Doesn't change throughout running the app) (static)

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override //Overide the build method to make it stateless
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sets up the app for us
      title: 'Conors App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        //Primary color for our app
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override //Overide the build method to make it stateless
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                'Hello World!')), //Sets up the layout of the page to add widgets to
        body: Row(
          //Can be column or row which will align widgets
          children: <Widget>[
            TestWidget(),
            TestWidget(),
            TestWidget()
          ], //We have 3 children in our column (parent)
        )); // List of widgets in a column
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello World!');
  }
}
