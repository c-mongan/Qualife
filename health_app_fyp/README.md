# Qualife Health App

Qualife is a holistic wellness companion built in Flutter to help users track daily check-ins, mood, activity, nutrition, and sleep. The app integrates Firebase for authentication and persistence, and leverages Syncfusion widgets for rich data visualisation.

---

## UX & UI Enhancement Plan

This plan captures the upcoming visual refresh aimed at making the experience calmer, clearer, and more cohesive across platforms.

### 1. Design System Refresh (Day 0.5)
- Introduce a dedicated `app_theme.dart` with shared colors, typography, and shapes inspired by soft wellness palettes.
- Add Google Fonts (e.g., `Poppins` for display, `Inter` for body text) to improve readability and character.
- Define reusable spacing, elevation, and radius tokens to tighten layout consistency.

### 2. Entry Flow Polish (Day 0.5)
- Redesign the splash screen with a gentle animated gradient and refined logo treatment.
- Rebuild the login screen using elevated cards, accent headers, and error feedback aligned with the new theme.
- Add supportive copy for first-time users and smooth button states (pressed, loading).

### 3. Core Dashboard Glow-Up (Day 0.5)
- Update the home dashboard to use card-based sections, wider breathing room, and hierarchy for critical stats.
- Refresh the daily check-in CTA using a modern filled button with subtle motion.
- Align the mood and calorie charts with the new palette, ensuring accessible contrast.

### 4. Navigation & Components (Day 0.25)
- Restyle the bottom navigation bar with rounded corners, translucency, and clear active states.
- Harmonise the custom neumorphic button with the global theme, reducing shadow harshness.
- Audit form fields and dialogs across the app to apply shared input styles and padding.

### 5. Validation & Handoff (Day 0.25)
- Run `flutter analyze` and key widget tests to confirm no regressions.
- Capture before/after screenshots for splash, login, and home to document the improvements.
- Summarise outstanding stretch ideas (e.g., dark mode, accessibility review) for the backlog.

Estimated total effort: ~2 days of focused implementation and validation.

---

## Getting Started

The project uses the standard Flutter tooling:

```bash
flutter pub get
flutter run
```

Ensure Firebase is configured with the project credentials in `lib/firebase_options.dart` before running on device or simulator.

For general Flutter documentation, refer to the [online docs](https://flutter.dev/docs).
