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
| Daily check-in | Atomically records weight, mood, activities, and sleep | Partial |
| Mood | Adds mood/activity entries and displays history and summaries | Partial |
| Sleep | Stores sleep entries and displays history/charts | Incomplete |
| Nutrition | Scans food barcodes and queries Open Food Facts | Partial |
| Calories | Maintains a transactional daily remaining-calorie balance | Partial |
| Trends | BMI, weight, sleep, mood, and combined charts | Partial |
| Notifications | Dashboard entry point only | Placeholder |

## Technology

- Flutter and Dart (`sdk: ">=3.3.0 <4.0.0"`)
- Firebase Authentication, Cloud Firestore, Realtime Database, Storage, and
  Messaging packages
- Open Food Facts for barcode-based nutrition lookup
- Syncfusion Charts plus `fl_chart` and `pie_chart`
- GetX, Provider, and GetIt packages
- Optional Datadog logging, RUM, and error reporting (compile-time opt-in)

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
- Xcode and CocoaPods for iOS development
- A Firebase project with Email/Password Authentication and Cloud Firestore
- FlutterFire CLI if regenerating Firebase configuration

### Configure and run

```bash
git clone https://github.com/c-mongan/Qualife.git
cd Qualife/health_app_fyp
flutter pub get
flutter run
```

Android and iOS initialize Firebase from their bundled native configuration.
Replace the checked-in files with files from your own Firebase project:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Web is intentionally configured without a committed
`lib/firebase_options.dart`. Supply the four required values through
compile-time defines:

```bash
flutter run -d chrome \
  --dart-define=FIREBASE_WEB_API_KEY=... \
  --dart-define=FIREBASE_WEB_APP_ID=... \
  --dart-define=FIREBASE_WEB_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_WEB_PROJECT_ID=...
```

`FIREBASE_WEB_AUTH_DOMAIN` and `FIREBASE_WEB_STORAGE_BUCKET` are optional.
Keep environment-specific values out of source control. Missing required web
values produce the existing Firebase initialization failure screen.

### Platform status

| Platform | Firebase startup status |
|---|---|
| Android | Supported with `android/app/google-services.json` |
| iOS | Supported with `ios/Runner/GoogleService-Info.plist` |
| Web | Supported with the four required `FIREBASE_WEB_*` compile-time defines |
| macOS | Unsupported until a macOS Firebase app and native configuration are added |
| Windows/Linux | Not configured or supported |

### Telemetry and privacy

Datadog is disabled by default. Without a build flag, the app does not
initialize the Datadog SDK, attach its navigation observer, or send Datadog
logs, RUM, or crash reports. There is no persisted in-app telemetry consent
setting. An observability build must be explicitly created with:

```bash
flutter run --dart-define=ENABLE_TELEMETRY=true
```

The enabled implementation sends only coarse, fixed event names (for example,
`auth.login_succeeded`, `mood.entry_saved`, and `body.metrics_saved`). It does
not call Datadog `setUserInfo` or add event attributes. Raw email, UID, mood,
activities, barcode, food name, BMI, weight, calorie values/targets, and health
classification are not sent. Raw health-value console prints in `lib/` have
also been removed. If Datadog initialization fails, the app starts normally
without telemetry.

This switch is compile-time and build-wide; it is not a substitute for
end-user consent where consent is legally required. Before enabling it in a
release, review Datadog retention/access controls and publish an applicable
privacy notice. Firebase continues to process feature data independently of
this telemetry switch.

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

The most important remaining issues are:

1. **Privacy governance remains incomplete.** Datadog defaults off behind
   `ENABLE_TELEMETRY`, emits only coarse event names when enabled, and is not
   associated with account or health values. There is still no persisted
   end-user consent control, retention policy, account export, or deletion
   flow.
2. **Sleep entry is incomplete.** The standalone control currently records a
   fixed eight-hour duration.
3. **Authentication and navigation remain mixed.** The root auth state is now
   handled by `AuthGate`, but feature navigation still uses direct GetX calls.
4. **Automated coverage is limited.** Core health calculations have unit
   coverage, but Firebase repository/emulator and end-to-end tests are absent.

Other release blockers include the example Android application ID, debug
release signing, missing account export/deletion controls, inconsistent error
handling, and unverified accessibility.

## Recommended repair order

1. Decide whether build-level telemetry approval is sufficient for deployment;
   if not, add genuine persisted consent. Define retention/access controls and
   implement account export/deletion.
2. Move Firebase access out of widgets into typed repositories.
3. Validate check-in inputs and write related records with awaited batches or
   transactions.
4. Replace the append-only calorie balance with a typed transactional daily
   model.
5. Repair the standalone sleep duration control and complete error handling.
6. Use one application router with an authentication-state listener and safe
   route replacement.
7. Add widget, repository/emulator, and end-to-end tests.
8. Add CI for formatting, analysis, tests, and platform builds.

## Development checks

Run these from `health_app_fyp/`:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Treat analyzer and test failures as defects, not as expected release output.

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
