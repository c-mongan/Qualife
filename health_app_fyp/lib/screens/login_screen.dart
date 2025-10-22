import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // for platform guard
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health_app_fyp/screens/register_screen.dart';

import 'package:health_app_fyp/theme/app_theme.dart';
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
    // Email field with new styling
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your Email");
        }
        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
          return ("Please enter a valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      style: AppTheme.textTheme.bodyLarge,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail_outline, color: AppTheme.accentPrimary),
        hintText: "Email address",
        labelText: "Email",
      ),
    );

    // Password field with new styling
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for Login");
        }
        if (!regex.hasMatch(value)) {
          return ("Password must be at least 6 characters in length");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      style: AppTheme.textTheme.bodyLarge,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: AppTheme.accentPrimary),
        hintText: "Enter your password",
        labelText: "Password",
      ),
    );

    // Modern login button
    final loginButton = ElevatedButton(
      onPressed: () {
        signIn(emailController.text, passwordController.text);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentPrimary,
        minimumSize: const Size(double.infinity, 56),
        elevation: AppTheme.elevationMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
      child: Text(
        "Log In",
        style: AppTheme.textTheme.labelLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppTheme.spacingXL),
                    // Logo
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surfaceLight.withOpacity(0.3),
                        ),
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: Image.asset(
                            "assets/LOGO1.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    // Welcome text
                    Text(
                      "Welcome back",
                      style: AppTheme.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      "Sign in to continue your wellness journey",
                      style: AppTheme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingXXL),
                    // Login card
                    Card(
                      elevation: AppTheme.elevationMid,
                      color: AppTheme.surfaceLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            emailField,
                            const SizedBox(height: AppTheme.spacingL),
                            passwordField,
                            const SizedBox(height: AppTheme.spacingXL),
                            loginButton,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    // Sign up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTheme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistrationScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.accentPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
