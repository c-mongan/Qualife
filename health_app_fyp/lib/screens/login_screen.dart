import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // for platform guard
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app_fyp/screens/register_screen.dart';

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  /*
  FIRESTORE PERMISSION-DENIED QUICK GUIDE:
  Ensure Firestore rules allow the authenticated user to read/write their own docs.
  Example permissive (development only) rules:
  rules_version = '2';
  service cloud.firestore { match /databases/{database}/documents { match /{document=**} { allow read, write: if request.auth != null; } } }

  Example scoped production pattern for user-owned collections:
  service cloud.firestore { match /databases/{db}/documents {
    match /users/{userId} { allow read, write: if request.auth != null && request.auth.uid == userId; }
    match /UserData/{docId} { allow read, write: if request.auth != null && request.auth.uid == resource.data.userID; }
    match /BMI/{docId} { allow read, write: if request.auth != null && request.auth.uid == resource.data.userID; }
    match /TDEE/{docId} { allow read, write: if request.auth != null && request.auth.uid == resource.data.userID; }
    match /remainingCalories/{docId} { allow read, write: if request.auth != null && request.auth.uid == resource.data.userID; }
    match /DailyCheckIn/{docId} { allow read, write: if request.auth != null && request.auth.uid == resource.data.userID; }
    match /MoodTracking/{docId} { allow read, write: if request.auth != null && request.auth.uid == resource.data.userID; }
    // Add similar matches for ActivityTracking, SleepTracking etc.
  }}

  INVALID-CREDENTIAL NOTES:
  Firebase returns invalid-credential for:
    * Wrong password
    * Malformed email/password credential
    * Expired credential/session
  We show a consolidated message guiding user to retry or reset password.
  */

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var myLogger = DatadogSdk.instance.createLogger(
    LoggingConfiguration(loggerName: "loginLogger"),
  );

  //firebase
  final _auth = FirebaseAuth.instance;

  //error message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
//email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please enter your Email");
          }
          //reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please enter a valid Email");
          }

          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
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

//passwordField
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          //Fire Base needs a minimum of 6 characters in a password to register a user
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for Login");
          }
          if (!regex.hasMatch(value)) {
            return ("Password must be at least 6 characters in length");
          }
          return null; // Added to satisfy validator contract
        },
        onSaved: (value) {
          passwordController.text = value!;
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

//Login Button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black, //Color of button
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context)
              .size
              .width, //resizes button to width of fields
          //When the button is pressed , use the controllers to set the text

          onPressed: () {
            

            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            "Login",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 30.0,
                                        ),

                                        Text(
                                          "Login",
                                          style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        // Text(
                                        //   "WellnessScale",
                                        //   style: const TextStyle(
                                        //     fontSize: 30,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        // SizedBox(
                                        //     height: 200,
                                        //     child: Image.asset(
                                        //       "assets/healthy1.png",
                                        //       fit: BoxFit.contain,
                                        //     )),
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
                                        //   "Login",
                                        //   style: const TextStyle(
                                        //       fontSize: 25,
                                        //       fontWeight: FontWeight.bold,
                                        //       color: Colors.grey),
                                        // ),
                                        const SizedBox(height: 45),
                                        emailField,
                                        const SizedBox(height: 25),
                                        passwordField,
                                        const SizedBox(height: 35),
                                        loginButton,
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Text(
                                                "Don't have an account? "),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RegistrationScreen())); //This sends the user to sign up if they click it
                                              },
                                              child: const Text("Sign Up",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ])))
            ]))));
  }

// try {
//   await FirebaseAuth.instance.signInWithEmailAndPassword(
//     email: "barry.allen@example.com",
//     password: "SuperSecretPassword!"
//   );
// } on FirebaseAuthException catch  (e) {
//   print('Failed with error code: ${e.code}');
//   print(e.message);

//Login Method
//Google async function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
//If Login is a success we will pass it the UserID
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful! "),

                  myLogger.info(
                      "Logged in user: ${FirebaseAuth.instance.currentUser?.uid}"),

                  myLogger.addAttribute('hostname', uid),

                  //Associates the RUM with the user
                  // Datadog user association (skip on web where plugin web implementation may be incomplete)
                  if (!kIsWeb)
                    DatadogSdk.instance.setUserInfo(
                      id: FirebaseAuth.instance.currentUser?.uid,
                      email: FirebaseAuth.instance.currentUser?.email,
                    ),
                  //Login Success message
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage())),
                  //Navigates the user to Home Screen
                });
      } on FirebaseAuthException catch (error) {
        // Log the actual error code and message for debugging
        print('FirebaseAuthException code: ${error.code}');
        print('FirebaseAuthException message: ${error.message}');
        
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be invalid.";
            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");
            break;
          case "wrong-password":
          case "invalid-credential":
            // invalid-credential can also mean malformed/expired credential; most common for email/password is wrong password
            errorMessage = "Incorrect password or expired credential. Try again or reset your password.";

            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");

            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");
            break;
          case "too-many-requests":
            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");
            break;
          default:
            errorMessage = "Error: ${error.code} - ${error.message}";
            myLogger.error("Login Error: $errorMessage "
                "User Email:  $email, ");
        }
        Fluttertoast.showToast(msg: errorMessage!);
      } catch (e) {
        // Catch any other errors
        print('Unexpected error during login: $e');
        errorMessage = "An unexpected error occurred: $e";
        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
  }
}
