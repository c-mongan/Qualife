import 'dart:async';
import 'dart:io';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/screens/home_page.dart';
import 'package:health_app_fyp/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();

  final configuration = DdSdkConfiguration(
    clientToken: 'pubf95e31114c49951733bdcbd1df890da1',
    env: 'prod',
    site: DatadogSite.us1,
    trackingConsent: TrackingConsent.granted,
    nativeCrashReportEnabled: true,
    loggingConfiguration: LoggingConfiguration(),
    //tracingConfiguration: TracingConfiguration(),
    rumConfiguration:
        RumConfiguration(applicationId: 'ee8d9e09-6a24-4396-8d80-c9e07508d1d6'),
  );

  await DatadogSdk.runApp(configuration, () async {
    runApp(GetMaterialApp(
        home: const MyApp(),

//This tracks the changes in users navigation
        navigatorObservers: [
          DatadogNavigationObserver(datadogSdk: DatadogSdk.instance),
        ],
        debugShowCheckedModeBanner: false));
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Health App',

      theme: ThemeData(primarySwatch: Colors.red),
      // home: const LoginScreen(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    Timer(const Duration(seconds: 2), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        //Associates the RUM with the user
        DatadogSdk.instance.setUserInfo(
          id: FirebaseAuth.instance.currentUser?.uid,
          email: FirebaseAuth.instance.currentUser?.email,
        );

        final myLogger = DatadogSdk.instance.createLogger(
          LoggingConfiguration(loggerName: "Logins", printLogsToConsole: true),
        );

        String? id = FirebaseAuth.instance.currentUser?.uid;
        myLogger.addAttribute('hostname', id!);

        myLogger
            .info("Logged in user: ${FirebaseAuth.instance.currentUser?.uid} ");

        Get.to(const HomePage());
      } else {
        Get.to(const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  child: Image.asset(
                    "assets/LOGO1.png",
                    fit: BoxFit.contain,
                  )),
              // Image.asset("assets/LOGO1.png"),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Qualife",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
