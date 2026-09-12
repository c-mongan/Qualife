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

```bash
flutter pub get
flutterfire configure
flutter run
```

The generated `lib/firebase_options.dart` and valid project-specific Firebase
configuration files are required. The source also has unresolved legacy imports
that must be repaired before it will analyze or build successfully.

## Checks

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

The current repository is a prototype and does not yet pass these checks. Do
not use it for real sensitive health information or medical decisions.

## Supporting notes

- [UX/UI enhancement guide](UX_UI_ENHANCEMENT_GUIDE.md)
- [UX/UI migration notes](MIGRATION_NOTES.md)
- [Widget audit](WIDGET_AUDIT.md)
