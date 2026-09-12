import 'dart:async';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_app_fyp/screens/home_page.dart';
import 'package:health_app_fyp/screens/login_screen.dart';
import 'package:health_app_fyp/services/telemetry.dart';
import 'package:health_app_fyp/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Object? firebaseInitializationError;
  try {
    await Firebase.initializeApp(
      options: kIsWeb ? _webFirebaseOptions : null,
    );
  } catch (error) {
    firebaseInitializationError = error;
    debugPrint('Firebase initialization failed.');
  }

  var appStarted = false;
  void startApp() {
    if (appStarted) return;
    appStarted = true;
    runApp(MyApp(firebaseInitializationError: firebaseInitializationError));
  }

  if (!telemetryEnabled) {
    startApp();
    return;
  }

  final configuration = DdSdkConfiguration(
    clientToken: 'pubf95e31114c49951733bdcbd1df890da1',
    env: 'prod',
    site: DatadogSite.us1,
    trackingConsent: TrackingConsent.granted,
    nativeCrashReportEnabled: true,
    loggingConfiguration: LoggingConfiguration(),
    rumConfiguration:
        RumConfiguration(applicationId: 'ee8d9e09-6a24-4396-8d80-c9e07508d1d6'),
  );

  try {
    await DatadogSdk.runApp(configuration, () async => startApp());
  } catch (_) {
    debugPrint('Telemetry initialization failed.');
    startApp();
  }
}

FirebaseOptions get _webFirebaseOptions {
  const apiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  const appId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
  const messagingSenderId =
      String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID');
  const projectId = String.fromEnvironment('FIREBASE_WEB_PROJECT_ID');
  const authDomain = String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
  const storageBucket = String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET');

  if (apiKey.isEmpty ||
      appId.isEmpty ||
      messagingSenderId.isEmpty ||
      projectId.isEmpty) {
    throw StateError('Missing required Firebase web configuration.');
  }

  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: authDomain.isEmpty ? null : authDomain,
    storageBucket: storageBucket.isEmpty ? null : storageBucket,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.firebaseInitializationError}) : super(key: key);

  final Object? firebaseInitializationError;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: AppTheme.theme,
      navigatorObservers: telemetryEnabled
          ? [DatadogNavigationObserver(datadogSdk: DatadogSdk.instance)]
          : const [],
      home: firebaseInitializationError == null
          ? const AuthGate()
          : const FirebaseInitializationFailure(),
    );
  }
}

class FirebaseInitializationFailure extends StatelessWidget {
  const FirebaseInitializationFailure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingXL),
          child: Text(
            'Qualife could not connect to Firebase. '
            'Check this platform\'s Firebase configuration and restart the app.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final StreamSubscription<User?> _authSubscription;
  User? _user;
  bool _hasAuthState = false;

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
          _handleAuthState,
        );
  }

  void _handleAuthState(User? user) {
    if (!mounted) return;
    setState(() {
      _user = user;
      _hasAuthState = true;
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasAuthState) {
      return _user == null ? const LoginScreen() : const HomePage();
    }

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
