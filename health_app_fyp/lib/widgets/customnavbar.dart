import 'package:flutter/material.dart';
import 'package:health_app_fyp/BMR+BMR/screens/bmi_main_page.dart';
import 'package:health_app_fyp/SleepTracker/list_of_sleep_time.dart';
import 'package:health_app_fyp/screens/graphs_land_page.dart';
import 'package:health_app_fyp/screens/home_page.dart';

import '../MoodTracker/original/list_of_moods.dart';
import '../OpenFoodFacts/calorie_tracker_list.dart';
import 'package:health_app_fyp/theme/app_theme.dart';

class CustomisedNavigationBar extends StatelessWidget {
  CustomisedNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryMid,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusL),
          topRight: Radius.circular(AppTheme.radiusL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: AppTheme.elevationHigh,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                onTap: () => _replaceWith(context, const HomePage()),
              ),
              _buildNavItem(
                icon: Icons.monitor_weight_outlined,
                label: 'BMI',
                onTap: () => _replaceWith(context, const BMITDEE()),
              ),
              _buildNavItem(
                icon: Icons.restaurant_outlined,
                label: 'Food',
                onTap: () => _replaceWith(context, const BarcodeScanner()),
              ),
              _buildNavItem(
                icon: Icons.mood_outlined,
                label: 'Mood',
                onTap: () => _replaceWith(context, const ListMoods()),
              ),
              _buildNavItem(
                icon: Icons.bedtime_outlined,
                label: 'Sleep',
                onTap: () => _replaceWith(context, const ListSleep()),
              ),
              _buildNavItem(
                icon: Icons.analytics_outlined,
                label: 'Stats',
                onTap: () => _replaceWith(context, const GraphsHome()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 26,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _replaceWith(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
