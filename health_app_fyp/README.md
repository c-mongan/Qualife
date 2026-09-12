# Qualife Flutter application

<p align="center">
  <img src="assets/LOGO1.png" alt="Qualife logo" width="180">
</p>

This directory contains the Flutter/Firebase prototype for Qualife, a personal
wellbeing journal covering mood, activity, sleep, food, weight, BMI, estimated
calorie needs, and trend charts.

> [!IMPORTANT]
> Start with the [project README](../README.md). It contains the feature matrix,
> architecture, Firebase data model, setup requirements, known release
> blockers, privacy warning, and recommended repair order.

## Quick start

Android and iOS use Firebase's bundled native configuration:

```bash
flutter pub get
flutter run
```

Replace `android/app/google-services.json` or
`ios/Runner/GoogleService-Info.plist` with the matching file from your Firebase
project before running that platform.

Web has no committed Firebase configuration. Supply its four required
`FirebaseOptions` values at compile time:

```bash
flutter run -d chrome \
  --dart-define=FIREBASE_WEB_API_KEY=... \
  --dart-define=FIREBASE_WEB_APP_ID=... \
  --dart-define=FIREBASE_WEB_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_WEB_PROJECT_ID=...
```

`FIREBASE_WEB_AUTH_DOMAIN` and `FIREBASE_WEB_STORAGE_BUCKET` are optional
additional defines. Keep environment-specific values out of source control.
If a required value is absent, the app shows its Firebase initialization
failure screen rather than attempting to use an incomplete configuration.

| Platform | Firebase startup status |
|---|---|
| Android | Supported with `android/app/google-services.json` |
| iOS | Supported with `ios/Runner/GoogleService-Info.plist` |
| Web | Supported when the required `FIREBASE_WEB_*` defines are supplied |
| macOS | Unsupported until a macOS Firebase app and native configuration are added |
| Windows/Linux | Not configured or supported |

Telemetry is compile-time opt-in and is disabled by default. A normal
`flutter run` does not initialize Datadog, install its navigation observer, or
send Datadog logs, RUM, or crash reports. For an explicitly approved
observability build:

```bash
flutter run --dart-define=ENABLE_TELEMETRY=true
```

This is a build-wide switch, not in-app consent. Enabled builds send only
coarse event names such as `auth.login_failed` and `food.entry_saved`.
Datadog is never given a user ID or email, and event attributes do not include
mood, activities, barcodes, food names, BMI, weight, calorie values/targets, or
health classifications. Initialization failure falls back to starting the app
without telemetry.

## Privacy

- Telemetry is off unless `ENABLE_TELEMETRY=true` is supplied at build/run
  time; no persisted user-consent control currently exists.
- Firebase still stores the wellbeing data required by app features. Datadog
  receives no raw health or account values from the application logger.
- Console logging of raw health records and values has been removed from
  `lib/`; remaining diagnostics are coarse operation or initialization names.
- Do not enable telemetry for a release unless the build-level approval,
  Datadog retention/access settings, and applicable privacy notice have been
  reviewed.

## Checks

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

The current repository is a prototype. Telemetry now defaults off and its
application events are data-minimised, but Firebase data governance, account
export/deletion, and production privacy review remain incomplete. Do not use it
for real sensitive health information or medical decisions.

## Supporting notes

- [UX/UI enhancement guide](UX_UI_ENHANCEMENT_GUIDE.md)
- [UX/UI migration notes](MIGRATION_NOTES.md)
- [Widget audit](WIDGET_AUDIT.md)
