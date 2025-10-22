# UX/UI Enhancement Migration Notes

**Date:** October 22, 2025  
**Version:** 1.0

## Summary of Changes

This update introduces a comprehensive design system refresh focused on:
- Wellness-inspired color palette
- Modern typography using Google Fonts (Poppins, Inter)
- Card-based UI components for dashboard sections
- Improved spacing and visual hierarchy
- Enhanced accessibility foundations (contrast, readable type scale)
- Consistent theming via centralized `AppTheme`

## Breaking Changes

None. All changes are visual and do not affect data models, Firestore structure, or business logic.

## New Dependencies

- `google_fonts: ^6.1.0` (added to `pubspec.yaml`) for dynamic font loading (Poppins & Inter)

## Files Modified

### New Files
- `lib/theme/app_theme.dart` – Centralized design system (colors, spacing, typography, gradients, ThemeData)
- `lib/widgets/section_card.dart` – Reusable card wrapper for dashboard and future modular sections
- `MIGRATION_NOTES.md` – This migration summary
- (Guide already present) `UX_UI_ENHANCEMENT_GUIDE.md` – Detailed implementation instructions

### Modified Files
- `lib/main.dart` – Integrated `AppTheme.theme`, splash redesign
- `lib/screens/login_screen.dart` – Modern gradient background, card layout, themed inputs/buttons
- `lib/screens/home_page.dart` – Dashboard cards (BMI, calories, mood, weight), navigation bar integration
- `lib/widgets/customnavbar.dart` – Rounded elevated navigation container with theme colors
- `lib/widgets/nuemorphic_button.dart` – Updated default color to use themed surface
- `README.md` – Added Recent Updates section for UX/UI refresh
- `pubspec.yaml` – Added Google Fonts dependency

## Rollback Instructions

To revert these changes:

```bash
git log --oneline -n 10         # Identify the commit before UX/UI refresh
git checkout <commit-hash> -- health_app_fyp/lib/ health_app_fyp/pubspec.yaml README.md
flutter pub get
```

Or to hard reset (dangerous – removes later commits):
```bash
git reset --hard <commit-hash>
flutter pub get
```

## Known Issues / Follow-Up

- Numerous existing lint warnings unrelated to theme remain (naming conventions, unused imports).
- Deprecated APIs: Some deprecated color scheme fields (e.g. `background`, `onBackground`). Consider updating to latest Material 3 tokens.
- `home_page.dart` still contains legacy logic (inline Firestore queries + state mixing). Future refactor recommended.
- Need active state handling for bottom navigation (currently always passive styling).
- Mood/weight widgets could be refactored into separate stateless components for clarity.

## Recommended Next Steps

1. Refactor data-fetch logic into services / providers.
2. Add dark/light theme toggle (extend `AppTheme` or create `AppTheme.light`).
3. Run accessibility audit (font scaling, minimum tap targets).
4. Extract repeated StreamBuilder patterns into generic builder widgets.
5. Remove unused imports and resolve lints (`flutter analyze` baseline cleanup).
6. Introduce state management (Provider/Riverpod) for shared wellness metrics.
7. Add integration tests for entry flow and dashboard rendering.

## Contrast & Accessibility Notes

- Primary text (`#FFFFFF`) on dark surfaces meets WCAG AA.
- Secondary text (`#B0BEC5`) borderline on darkest background; validate contrast ratio and adjust if needed.
- Accent colors (Sky Blue / Mint) acceptable for call-to-action; ensure non-color cues for critical states.

## Performance Considerations

- Multiple StreamBuilders on `home_page.dart`; consider batching or caching results.
- Image assets (logo) now loaded larger on splash/login; ensure proper caching and size optimization.

## Testing Checklist (Executed / To Execute)

- [x] Splash gradient renders & animation works
- [x] Login form validation intact after theming
- [x] Dashboard cards display without overflow
- [x] Navigation bar responsive to taps
- [ ] Screenshot set captured
- [ ] Lint cleanup run
- [ ] Profile mode performance check

## Design Tokens Introduced

See `lib/theme/app_theme.dart` for canonical definitions:
- Color palette (primary, accent, semantic)
- Spacing scale (4–48)
- Border radii (8–24, full)
- Elevation levels (2, 4, 8)
- Typography scale (Display / Headline / Body / Label variants)

## Roll Forward Strategy

Future enhancements can extend `AppTheme`:
- Add `lightColorScheme` variant
- Introduce motion specs (animation durations, curves)
- Centralize shape tokens (rounded rectangle radii)
- Provide semantic color wrappers (e.g., success/warning/error surfaces)

---

**Maintainer:** Development Team  
**Contact:** Open an issue in the repository for questions or regressions.
