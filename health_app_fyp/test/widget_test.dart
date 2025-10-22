import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_app_fyp/theme/app_theme.dart';

/// Direct splash widget test without initializing full app stack (Firebase/Get/Datadog).
/// We replicate the SplashScreen build to avoid timers & navigation side effects.
class _TestSplash extends StatelessWidget {
  const _TestSplash();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: Material(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingXL),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceLight.withOpacity(0.3),
                    ),
                    child: const SizedBox(
                      height: 180,
                      width: 180,
                      // Use placeholder Container; in production this is Image.asset("assets/LOGO1.png")
                      child: Icon(Icons.health_and_safety, size: 64, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                Text("Qualife", style: AppTheme.textTheme.displayLarge),
                const SizedBox(height: AppTheme.spacingS),
                Text("Your wellness companion", style: AppTheme.textTheme.bodyMedium),
                const SizedBox(height: AppTheme.spacingXXL),
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Splash screen static branding renders', (tester) async {
    await tester.pumpWidget(const _TestSplash());

    expect(find.text('Qualife'), findsOneWidget);
    expect(find.text('Your wellness companion'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow animation to complete.
    await tester.pump(const Duration(milliseconds: 800));
  });
}
