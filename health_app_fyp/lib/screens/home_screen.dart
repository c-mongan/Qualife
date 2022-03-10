import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app_fyp/model/user_model.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                // colors: [Colors.red, Colors.white, Colors.red],
                colors: [
              Colors.blue,
              Colors.red,
              // Colors.red,
              //Colors.blue,

              // Colors.orange,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Text(
                    "Welcome ${loggedInUser.firstName}!",
                    // "Welcome ${loggedInUser.firstName} ${loggedInUser.secondName}!",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                    height: 120,
                    child: Image.asset("assets/healthy1.png",
                        fit: BoxFit.contain)),
                // ignore: prefer_const_constructors

                // ignore: prefer_const_constructors
                SizedBox(
                  height: 25,
                ),
                Text(
                    "Your Name: ${loggedInUser.firstName} ${loggedInUser.secondName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
                Text("Your E-mail: ${loggedInUser.email}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(
                  height: 25,
                ),
                ActionChip(
                    label: const Text("Log Out"),
                    labelStyle:
                        const TextStyle(color: Colors.white, fontSize: 15),
                    backgroundColor: Colors.red,
                    onPressed: () {
                      logout(context);
                    }),
              ],
            ),
          ),
        ),
      ));
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
  Fluttertoast.showToast(msg: "Logout Successful! ");
}
