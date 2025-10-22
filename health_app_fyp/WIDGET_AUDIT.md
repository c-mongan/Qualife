# Qualife Widget Audit – October 2025

This document captures the current state of reusable widgets and navigation shells in the Qualife app, along with recommended upgrades that preserve behavior while improving stability, accessibility, and long‑term maintainability.

## Summary of Findings

| Area | Current State | Recommended Action | Risk of Change |
| --- | --- | --- | --- |
| App shell (`main.dart`) | `GetMaterialApp` wraps a secondary `MaterialApp`, causing nested navigators and theme duplication. | Collapse to a single `GetMaterialApp` configured with `theme: AppTheme.theme` and `home: const SplashScreen()`. | Low – routing stays identical, removes redundant widget tree. |
| Navigation (`lib/widgets/customnavbar.dart`) | Stateless `BottomAppBar` pushes screens with `Get.to`, stacking duplicates and losing selection state. | Replace with Flutter `NavigationBar`/`IndexedStack` or `BottomNavigationBar` with tracked index and `Get.offAllNamed`. | Medium – needs light refactor of navigation host, but improves UX and state. |
| Neumorphic buttons (`nuemorphic_button.dart`, `logout_button.dart`) | Trigger actions on pointer-down via `Listener`, bypassing semantics and long-press cancellation. | Rebuild using `GestureDetector` + `InkWell` or `ElevatedButton/FilledButton` with custom `ButtonStyle` and press animations. | Low – behavior remains; accessibility greatly improves. |
| Neumorphic progress indicator | `_isPressed` never changes; gradient/shadow logic dead code. | Remove unused listener, expose clean API for value/appearance, consider simple `DecoratedBox` + `LinearProgressIndicator`. | Low – purely visual component. |
| Registration button (`register_screen.dart`) | Uses deprecated `MaterialButton` wrapped in `Material`. | Swap to `ElevatedButton` or theme-aligned alternative. | Very Low – drop-in replacement. |
| Color utils | `Color.mix` extensions duplicated in multiple files. | Centralize shared extensions in a single utility file. | Very Low. |
| Legacy navbars (`glassmorphic_bottomnavbar.dart`, `customnavbar_iconChange.dart`) | Entirely commented out. | Delete or move to `archive/` to reduce noise. | None. |

## Detailed Notes

### 1. App Shell (`main.dart`)
- Double-app pattern prevents inherited widgets (themes, `NavigatorObservers`) from applying consistently.
- `Get.to` may open new navigation stacks because it finds the inner `MaterialApp` instead of the `GetMaterialApp`.
- **Action:** Configure `GetMaterialApp` once and remove the nested `MaterialApp`. Ensure `theme`, `navigatorObservers`, and `home` are set on the outer app.

### 2. Bottom Navigation (`CustomisedNavigationBar`)
- Stateless widget that pushes routes directly on tap, leading to multiple copies on the stack and no selected styling.
- `Get.to` always creates a new page instance, so back navigation is cluttered.
- **Action:** Introduce a `StatefulWidget` host that:
  - Stores the current tab index.
  - Uses an `IndexedStack` to retain page state.
  - Switches tabs via `setState` or `Get.offAllNamed` when appropriate.
- **Alternative:** Adopt Material 3 `NavigationBar` for modern design and built-in animations.

### 3. Neumorphic Buttons (`nuemorphic_button.dart`, `logout_button.dart`)
- Both call `onPressed` inside `Listener.onPointerDown`, so the action fires immediately and ignores cancellations.
- Buttons lack focus, hover, and semantics support.
- **Action:**
  - Swap to `GestureDetector` + `AnimatedContainer`, invoking callbacks on `onTap`.
  - Or wrap an `InkWell` inside a decorated `Container` to keep ripple, focus, and accessible feedback.

### 4. Neumorphic Progress Indicator
- `Listener` and `_isPressed` are unused; widget is effectively a styled box.
- **Action:** Simplify to a `Container` with gradient/shadow and embed a `LinearProgressIndicator` that reads its value from props.
- Optional: expose `double value` and `bool animate` to integrate with app data.

### 5. Registration Screen Button
- `MaterialButton` is deprecated and ignores global `elevatedButtonTheme`.
- **Action:** Replace with:
  ```dart
  ElevatedButton(
    onPressed: () => signUp(email, password),
    style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(56)),
    child: const Text('Sign Up'),
  );
  ```

### 6. Shared Color Utilities
- `Color.mix` extension appears separately in multiple files.
- **Action:** Move to `lib/widgets/color_extensions.dart` and import where needed to avoid duplication.

### 7. Dead Navbar Variants
- Glassmorphic and icon-change navbars are fully commented out, increasing repo noise.
- **Action:** Delete or archive under `legacy/` with a note if you still want the reference.

## Suggested Next Steps

1. Update `main.dart` to single-app structure (quick win).
2. Standardize bottom navigation host using indexed tabs.
3. Refactor neumorphic controls with accessible gesture handling.
4. Replace deprecated `MaterialButton` and centralize color utilities.
5. Prune unused navbar experiments.

## QA Considerations

- After changes, run `flutter analyze` and `flutter test` to catch regressions.
- Manually verify login, logout, and navigation flows to ensure the refactor did not break routing.
- For button changes, test focus and keyboard navigation (especially on web/desktop builds).

---
*Prepared by GitHub Copilot – October 22, 2025.*
