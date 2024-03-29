import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/initialregistrationscreens/initialbmi.dart';

import '../../model/user_model.dart';
import '../../services/database.dart';
import 'home_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
//Our Form Key
  final _formKey = GlobalKey<FormState>();
//Editing Controller

//FNAME
  final firstNameEditingController = TextEditingController();
  //SNAME
  final secondNameEditingController = TextEditingController();
  //EMAIL
  final emailEditingController = TextEditingController();
  //PASSWORD
  final passwordEditingController = TextEditingController();
  //CONFIRMPASSWORD
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //First Name Field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          //Fire Base needs a minimum of 6 characters in a password to register a user
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name is required for registration");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter a valid First Name (3 characters minimum)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.app_registration),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

//Second Name Field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          //Fire Base needs a minimum of 6 characters in a password to register a user

          if (value!.isEmpty) {
            return ("Second Name is required for registration");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.app_registration),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please enter your Email");
          }
          //reg expression for email validation
          if (!RegExp("[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please enter a valid Email");
          }

          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

//Password Field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        //Fire Base needs a minimum of 6 characters in a password to register a user
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for Login");
          }
          if (!regex.hasMatch(value)) {
            return ("Password must be at least 6 characters in length");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

//Confirm Password Field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text.length > 6 &&
              passwordEditingController.text != value) {
            return "Passwords do not match";

            //   if (confirmPasswordEditingController.text.length !=
            //   passwordEditingController.text) {
            //    return "Passwords do not match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done, //As it is the last action
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //SIGN UP BUTTON
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      //color: Colors.redAccent, //Color of button
      color: Colors.grey,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context)
              .size
              .width, //resizes button to width of fields
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black,
              Colors.grey,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: SafeArea(
                              child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      // Text(
                                      //   "Qualife",
                                      //   style: const TextStyle(
                                      //     fontSize: 30,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      Text(
                                        "Register",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      SizedBox(
                                          height: 200,
                                          child: Image.asset(
                                            "assets/LOGO1.png",
                                            fit: BoxFit.contain,
                                          )),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      // Text(
                                      //   "Register",
                                      //   style: const TextStyle(
                                      //       fontSize: 25,
                                      //       fontWeight: FontWeight.bold,
                                      //       color: Colors.grey),
                                      // ),
                                      const SizedBox(height: 45),
                                      firstNameField,
                                      const SizedBox(height: 20),
                                      secondNameField,
                                      const SizedBox(height: 20),
                                      emailField,
                                      const SizedBox(height: 20),
                                      passwordField,
                                      const SizedBox(height: 20),
                                      confirmPasswordField,
                                      const SizedBox(height: 20),
                                      signUpButton,
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ])),
              )
            ]))));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //1) Calls our FireStore
    //2) Calls our 'User' model
    //3) Write the values
    //4) Send these values to the server

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await DatabaseService(uid: user!.uid).updateUserData(
      0,
      '',
      0,
      0,
      0,
    );
    UserModel userModel = UserModel();

    //Writing values

    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Successfully created an account!");

    // String message = "Please use the mood tracker to see data";
    // FirebaseFirestore.instance.collection('MoodTracking').add({
    //   'userID': user.uid,
    //   'DateOfMood': DateTime.now(),
    //   'TimeOfMood': DateTime.now(),
    //   'Mood': message,
    //   'DateTime': DateTime.now(),
    // });

    Get.to( FirstBMI());
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => const HomeScreen()),
    //     (route) => false);
  }
}
