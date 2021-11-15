import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register/model/user_model.dart';
import 'package:flutter_login_register/screens/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_login_register/screens/profile_page.dart';
import 'package:flutter_login_register/screens/home_page.dart';
import 'package:flutter_login_register/screens/exit_page.dart';
import 'package:flutter_login_register/screens/feed_page.dart';
import 'package:flutter_login_register/screens/chat_page.dart';

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

  final screens = [
    HomePage(),
    FeedPage(),
    ChatPage(),
    ProfilePage(),
    ExitPage()
  ];

  // final screens = [
  //Center(child: Text('Home', style: TextStyle(fontSize: 40))),
  //Center(child: Text('Feed', style: TextStyle(fontSize: 40))),
  //Center(child: Text('Chat', style: TextStyle(fontSize: 40))),
  // Center(child: Text('Profile', style: TextStyle(fontSize: 40))),
  // Center(child: Text('Exit', style: TextStyle(fontSize: 40))),
  //];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: screens[currentIndex],

      /*Use this for stateful Pages
      
      body:IndexedStack(
        index: currentIndex,
        children: screens,
        ),
        */


      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed, For less dynamic
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 40, //individual icon size
        selectedFontSize: 25,
        unselectedFontSize: 15,
        showUnselectedLabels: false,
        //showSelectedLabels: false, Use this to get rid of labels
        //Still need to add a label name to avoid errors however

        //On tap changes which label text comes up when you click it
        onTap: (index) => setState(() => currentIndex = index),
        //Set state as the class extends stateful widget ^^^ Top of page
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Feed',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Chat',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Extra',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app_rounded),
            label: 'Exit',
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
    Fluttertoast.showToast(msg: "Logout Successful! ");
  }
}
