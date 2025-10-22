import 'package:flutter/material.dart';
import 'package:health_app_fyp/theme/app_theme.dart';

/// SectionCard
/// Reusable elevated card container for dashboard and other grouped content.
/// Provides consistent spacing, elevation, and typography alignment.
class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<Widget>? actions;
  final CrossAxisAlignment crossAxisAlignment;

  const SectionCard({
    Key? key,
    this.title,
    required this.child,
    this.padding,
    this.margin,
    this.actions,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationMid,
      color: AppTheme.surfaceLight,
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (title != null || (actions != null && actions!.isNotEmpty))
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: AppTheme.textTheme.headlineSmall,
                        ),
                      ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
