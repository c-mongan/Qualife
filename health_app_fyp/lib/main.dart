import 'dart:async';
import 'dart:io';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/screens/home_page.dart';
import 'package:health_app_fyp/screens/login_screen.dart';
import 'package:health_app_fyp/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

      theme: AppTheme.theme,
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
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with subtle scale animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingXL),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceLight.withOpacity(0.3),
                  ),
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: Image.asset(
                      "assets/LOGO1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
              // App name
              Text(
                "Qualife",
                style: AppTheme.textTheme.displayLarge,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                "Your wellness companion",
                style: AppTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXXL),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.accentPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
