# Qualife

<p align="center">
  <img src="health_app_fyp/assets/LOGO1.png" alt="Qualife logo" width="180">
</p>

Qualife is a Flutter wellbeing-tracking prototype that brings several daily
health logs into one app. Users can record mood, activities, sleep, food,
weight, BMI, and estimated calorie needs, then review their history through
lists and charts.

> [!WARNING]
> Qualife is a final-year-project prototype, not a medical device or a
> production-ready health service. The current source has known build,
> reliability, privacy, and data-consistency issues. Do not use it for medical
> decisions or real sensitive health data without completing the work in
> [Current status](#current-status).

## What is implemented

| Area | Current behaviour | Status |
|---|---|---|
| Accounts | Firebase email/password registration, login, and logout | Partial |
| Onboarding | Captures body measurements and estimates BMI/TDEE | Partial |
| Daily check-in | Records weight, mood, activities, and sleep | Needs repair |
| Mood | Adds mood/activity entries and displays history and summaries | Partial |
| Sleep | Stores sleep entries and displays history/charts | Incomplete |
| Nutrition | Scans food barcodes and queries Open Food Facts | Partial |
| Calories | Maintains a remaining-calorie ledger | Needs repair |
| Trends | BMI, weight, sleep, mood, and combined charts | Partial |
| Notifications | Dashboard entry point only | Placeholder |

## Technology

- Flutter and Dart (`sdk: ">=3.3.0 <4.0.0"`)
- Firebase Authentication, Cloud Firestore, Realtime Database, Storage, and
  Messaging packages
- Open Food Facts for barcode-based nutrition lookup
- Syncfusion Charts plus `fl_chart` and `pie_chart`
- GetX, Provider, and GetIt packages
- Datadog logging, RUM, and error reporting

The app currently uses a screen-driven architecture: widgets perform
authentication, Firestore queries, calculations, navigation, and telemetry
directly. `lib/services/database.dart` contains some shared persistence logic,
but the features are not yet separated into consistent repositories or state
controllers.

## Repository layout

```text
.
├── README.md
└── health_app_fyp/
    ├── assets/                         Images and bundled assets
    ├── lib/
    │   ├── BMR+BMR/                    BMI and BMR/TDEE flow
    │   ├── MoodTracker/                Mood and activity tracking
    │   ├── OpenFoodFacts/              Barcode and calorie tracking
    │   ├── SleepTracker/               Sleep entry and history
    │   ├── initialregistrationscreens/ Onboarding
    │   ├── model/                      User data models
    │   ├── screens/                    Authentication, dashboard, charts
    │   ├── services/                   Shared database code
    │   ├── theme/                      Application theme
    │   ├── widgets/                    Shared and archived widgets
    │   └── main.dart                   Startup, Firebase, Datadog, routing
    ├── test/                           Flutter tests
    ├── firestore.rules                 Firestore access rules
    ├── pubspec.yaml                    Package and asset configuration
    └── firebase.json                   Firebase deployment configuration
```

## Local setup

### Prerequisites

- Flutter with a Dart 3.3-compatible SDK
- Android Studio and Java 17 for Android development
- Xcode and CocoaPods for iOS or macOS development
- A Firebase project with Email/Password Authentication and Cloud Firestore
- FlutterFire CLI if regenerating Firebase configuration

### Configure and run

```bash
git clone https://github.com/c-mongan/Qualife.git
cd Qualife/health_app_fyp
flutter pub get
flutterfire configure
flutter run
```

`flutterfire configure` must generate `lib/firebase_options.dart`. Replace the
checked-in Android and iOS Firebase configuration with files from your own
Firebase project:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

The current source also contains invalid legacy import paths, so a fresh clone
will not pass analysis until those imports are repaired. See the first item in
[Recommended repair order](#recommended-repair-order).

### Firebase rules

The supplied Firestore rules scope the known top-level collections by a
`userID` field and deny unmatched collections:

```bash
cd health_app_fyp
firebase deploy --only firestore:rules
```

Client-side `.where("userID", ...)` filters are not authorization. Review and
test `firestore.rules` against the Firebase Emulator Suite before storing user
data.

## Data model

The prototype stores related records across several top-level Firestore
collections:

- `users` and `UserData`
- `BMI` and `TDEE`
- `DailyCheckIn`
- `MoodTracking` and `ActivityTracking`
- `SleepTracking`
- `TempFood`, `Food`, `CalorieCount`, and `remainingCalories`

Documents are associated through a `userID` value. Dates and numeric values are
not represented consistently across every feature, and related writes are not
currently transactional. A typed, versioned schema should be defined before a
production migration.

## Current status

**Readiness: prototype/demo only.**

The most important known issues are:

1. **Build is currently broken.** `lib/firebase_options.dart` is absent and
   several imports reference moved or missing files.
2. **TLS verification is disabled globally.** `lib/main.dart` accepts invalid
   certificates and must not ship in this state.
3. **Dashboard queries recurse.** Some getters trigger setters that trigger the
   same queries again, causing repeated Firestore reads.
4. **Check-in writes are inconsistent.** A single check-in can create duplicate
   sleep entries, navigate repeatedly, or leave partially written data.
5. **Telemetry needs a privacy redesign.** Datadog consent is automatically
   granted and identity, mood, food, and body-metric context can be logged.
6. **Food and calorie updates are not atomic.** Concurrent operations can lose
   updates, while missing nutrition values can crash the food flow.
7. **Mood deletion is not relationally safe.** It can delete activity records
   unrelated to the selected mood.
8. **Sleep entry is incomplete.** The standalone control currently records a
   fixed eight-hour duration.
9. **Authentication and navigation are fragile.** User state is frequently
   force-unwrapped and root screens accumulate in the route stack.
10. **Automated coverage is minimal.** The only widget test recreates a test
    splash screen instead of exercising production code.

Other release blockers include the example Android application ID, debug
release signing, missing account export/deletion controls, inconsistent error
handling, and unverified accessibility.

## Recommended repair order

1. Restore a clean `flutter analyze` and build by fixing imports and Firebase
   configuration.
2. Remove the global HTTP override and restore normal certificate validation.
3. Add explicit telemetry consent, data minimisation, redaction, retention, and
   account export/deletion.
4. Move Firebase access out of widgets into typed repositories and remove
   recursive dashboard reads.
5. Validate check-in inputs and write related records with awaited batches or
   transactions.
6. Replace the append-only calorie balance with a transactional daily model.
7. Repair sleep duration, full-date comparisons, barcode cancellation, missing
   nutrient handling, and mood/activity deletion.
8. Use one application router with an authentication-state listener and safe
   route replacement.
9. Add unit, widget, repository/emulator, and end-to-end tests.
10. Add CI for formatting, analysis, tests, and platform builds.

## Development checks

Run these from `health_app_fyp/`:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

The repository does not currently pass this quality gate. Treat analyzer and
test failures as baseline defects to fix, not as expected release output.

## Product direction

The strongest version of Qualife is a **simple daily wellbeing journal**, not a
medical diagnosis tool. A focused release should make check-in completion fast,
show trustworthy trends across mood, sleep, nutrition, and weight, and explain
exactly how private data is used. Notifications, social features, AI advice,
wearables, and clinician sharing should remain out of scope until correctness,
privacy, and data ownership are proven.

## License

No license file is currently included. Unless a license is added, the source is
copyrighted and no reuse rights are granted by default.
