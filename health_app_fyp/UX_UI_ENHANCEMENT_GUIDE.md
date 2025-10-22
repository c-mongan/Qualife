# Qualife UX/UI Enhancement Guide

**Version:** 1.0  
**Last Updated:** October 22, 2025  
**Estimated Total Effort:** ~2 days of focused implementation and validation

This document provides detailed, step-by-step instructions for implementing the visual refresh across the Qualife health app. Each section includes specific file changes, code snippets, and validation checkpoints.

---

## Table of Contents

1. [Design System Refresh (Day 0.5)](#1-design-system-refresh)
2. [Entry Flow Polish (Day 0.5)](#2-entry-flow-polish)
3. [Core Dashboard Glow-Up (Day 0.5)](#3-core-dashboard-glow-up)
4. [Navigation & Components (Day 0.25)](#4-navigation--components)
5. [Validation & Handoff (Day 0.25)](#5-validation--handoff)
6. [Appendix: Color Palette & Typography Reference](#appendix-color-palette--typography-reference)

---

## 1. Design System Refresh

**Goal:** Create a centralized theme system with consistent colors, typography, spacing, and elevation.

**Estimated Time:** 4 hours

### Step 1.1: Add Google Fonts Dependency

**File:** `pubspec.yaml`

Add the following under `dependencies:`:

```yaml
dependencies:
  # ... existing dependencies ...
  google_fonts: ^6.1.0
```

**Action:** Run in terminal:

```bash
cd /Users/conormongan/Documents/GitHub/Qualife/health_app_fyp
flutter pub get
```

### Step 1.2: Create Theme File

**File:** `lib/theme/app_theme.dart` (new file)

Create this new file with the following content:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Qualife App Theme
/// Centralized design system with wellness-inspired colors and typography
class AppTheme {
  // ============================================================================
  // Color Palette - Soft Wellness Theme
  // ============================================================================
  
  // Primary colors - Calming Blues & Teals
  static const Color primaryDark = Color(0xFF1A2332);      // Deep Navy
  static const Color primaryMid = Color(0xFF2D3E50);       // Slate Blue
  static const Color primaryLight = Color(0xFF4A5F7F);     // Soft Steel
  
  // Accent colors - Energizing Coral & Mint
  static const Color accentPrimary = Color(0xFF6EC1E4);    // Sky Blue
  static const Color accentSecondary = Color(0xFF54D2D2);  // Mint Teal
  static const Color accentWarm = Color(0xFFFFA07A);       // Light Coral
  
  // Neutral palette
  static const Color backgroundDark = Color(0xFF121826);
  static const Color backgroundMid = Color(0xFF1E2836);
  static const Color surfaceLight = Color(0xFF2A3544);
  static const Color surfaceElevated = Color(0xFF364152);
  
  // Semantic colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFEF5350);
  static const Color infoBlue = Color(0xFF42A5F5);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textTertiary = Color(0xFF78909C);
  static const Color textDisabled = Color(0xFF546E7A);
  
  // ============================================================================
  // Spacing System
  // ============================================================================
  
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // ============================================================================
  // Border Radius
  // ============================================================================
  
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;
  
  // ============================================================================
  // Elevation
  // ============================================================================
  
  static const double elevationLow = 2.0;
  static const double elevationMid = 4.0;
  static const double elevationHigh = 8.0;
  
  // ============================================================================
  // Typography
  // ============================================================================
  
  static TextTheme textTheme = TextTheme(
    // Display styles - for headers and prominent text
    displayLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -0.25,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    
    // Headline styles - for section titles
    headlineLarge: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    
    // Body styles - for general content
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textSecondary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textTertiary,
      height: 1.4,
    ),
    
    // Label styles - for buttons and UI elements
    labelLarge: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: textSecondary,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: textTertiary,
      letterSpacing: 0.5,
    ),
  );
  
  // ============================================================================
  // Material Theme Data
  // ============================================================================
  
  static ThemeData get theme {
    return ThemeData(
      // Color scheme
      brightness: Brightness.dark,
      primaryColor: accentPrimary,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: accentPrimary,
        secondary: accentSecondary,
        surface: surfaceLight,
        background: backgroundDark,
        error: errorRed,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textPrimary,
      ),
      
      // Typography
      textTheme: textTheme,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: surfaceLight,
        elevation: elevationMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimary,
          foregroundColor: textPrimary,
          elevation: elevationMid,
          padding: EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentPrimary,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: surfaceElevated, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: accentPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: errorRed, width: 1),
        ),
        hintStyle: TextStyle(color: textTertiary),
        labelStyle: TextStyle(color: textSecondary),
      ),
      
      // Icon theme
      iconTheme: IconThemeData(
        color: textSecondary,
        size: 24,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: surfaceElevated,
        thickness: 1,
        space: spacingL,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryMid,
        selectedItemColor: accentPrimary,
        unselectedItemColor: textTertiary,
        elevation: elevationHigh,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
  
  // ============================================================================
  // Gradient Helpers
  // ============================================================================
  
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryDark,
      primaryMid,
      primaryLight,
    ],
  );
  
  static LinearGradient get accentGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentPrimary,
      accentSecondary,
    ],
  );
  
  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundDark,
      primaryDark,
    ],
  );
}
```

### Step 1.3: Update Main App to Use New Theme

**File:** `lib/main.dart`

**Changes Required:**

1. Import the new theme file at the top:
```dart
import 'package:health_app_fyp/theme/app_theme.dart';
```

2. In the `MyApp` widget's `build` method, replace the existing `theme:` line:

**Before:**
```dart
theme: ThemeData(primarySwatch: Colors.red),
```

**After:**
```dart
theme: AppTheme.theme,
```

### Step 1.4: Verify Theme Installation

**Action:** Run the following commands to verify:

```bash
flutter pub get
flutter analyze
```

Expected output: No errors related to theme or google_fonts.

---

## 2. Entry Flow Polish

**Goal:** Modernize the splash screen and login screen with the new design system.

**Estimated Time:** 4 hours

### Step 2.1: Update Splash Screen

**File:** `lib/main.dart` (SplashScreen widget)

**Complete Replacement:** Replace the entire `_SplashScreenState` widget's `build` method:

**Before:** (lines ~104-154)

**After:**
```dart
@override
Widget build(BuildContext context) {
  return Material(
    child: Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with subtle scale animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceLight.withOpacity(0.3),
                ),
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Image.asset(
                    "assets/LOGO1.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),
            // App name
            Text(
              "Qualife",
              style: AppTheme.textTheme.displayLarge,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              "Your wellness companion",
              style: AppTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingXXL),
            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.accentPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

### Step 2.2: Redesign Login Screen

**File:** `lib/screens/login_screen.dart`

This is a larger change. Create a backup first, then apply these updates:

**Import the theme at the top:**
```dart
import 'package:health_app_fyp/theme/app_theme.dart';
```

**Replace the `build` method in `_LoginScreenState`:**

```dart
@override
Widget build(BuildContext context) {
  // Email field with new styling
  final emailField = TextFormField(
    autofocus: false,
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value!.isEmpty) {
        return ("Please enter your Email");
      }
      if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$").hasMatch(value)) {
        return ("Please enter a valid Email");
      }
      return null;
    },
    onSaved: (value) {
      emailController.text = value!;
    },
    textInputAction: TextInputAction.next,
    style: AppTheme.textTheme.bodyLarge,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.mail_outline, color: AppTheme.accentPrimary),
      hintText: "Email address",
      labelText: "Email",
    ),
  );

  // Password field with new styling
  final passwordField = TextFormField(
    autofocus: false,
    controller: passwordController,
    obscureText: true,
    validator: (value) {
      RegExp regex = RegExp(r'^.{6,}$');
      if (value!.isEmpty) {
        return ("Password is required for Login");
      }
      if (!regex.hasMatch(value)) {
        return ("Password must be at least 6 characters in length");
      }
      return null;
    },
    onSaved: (value) {
      passwordController.text = value!;
    },
    textInputAction: TextInputAction.done,
    style: AppTheme.textTheme.bodyLarge,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.lock_outline, color: AppTheme.accentPrimary),
      hintText: "Enter your password",
      labelText: "Password",
    ),
  );

  // Modern login button
  final loginButton = ElevatedButton(
    onPressed: () {
      signIn(emailController.text, passwordController.text);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accentPrimary,
      minimumSize: Size(double.infinity, 56),
      elevation: AppTheme.elevationMid,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
    ),
    child: Text(
      "Log In",
      style: AppTheme.textTheme.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  return Scaffold(
    body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Logo
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surfaceLight.withOpacity(0.3),
                      ),
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: Image.asset(
                          "assets/LOGO1.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Welcome text
                  Text(
                    "Welcome back",
                    style: AppTheme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    "Sign in to continue your wellness journey",
                    style: AppTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXXL),
                  
                  // Login card
                  Card(
                    elevation: AppTheme.elevationMid,
                    color: AppTheme.surfaceLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          emailField,
                          const SizedBox(height: AppTheme.spacingL),
                          passwordField,
                          const SizedBox(height: AppTheme.spacingXL),
                          loginButton,
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Sign up prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTheme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
```

### Step 2.3: Test Entry Flow

**Actions:**
1. Hot reload the app: `r` in the Flutter terminal
2. Verify the splash screen shows the animated logo
3. Verify the login screen uses the new card-based layout
4. Test form validation still works
5. Ensure navigation to signup works

---

## 3. Core Dashboard Glow-Up

**Goal:** Transform the home page into a modern, card-based dashboard with clear visual hierarchy.

**Estimated Time:** 4 hours

### Step 3.1: Import Theme in Home Page

**File:** `lib/screens/home_page.dart`

Add at the top with other imports:
```dart
import 'package:health_app_fyp/theme/app_theme.dart';
```

### Step 3.2: Update AppBar

**In the `Scaffold` widget, replace the existing `appBar:`:**

**Before:**
```dart
appBar: AppBar(
  title: const Text('Home'),
  elevation: 0,
  backgroundColor: Colors.black,
),
```

**After:**
```dart
appBar: AppBar(
  title: Text('Dashboard', style: AppTheme.textTheme.headlineMedium),
  elevation: 0,
  backgroundColor: AppTheme.primaryDark,
  actions: [
    IconButton(
      icon: Icon(Icons.notifications_outlined),
      onPressed: () {
        // Future: notifications
      },
    ),
  ],
),
```

### Step 3.3: Update Background Container

**Replace the `Container` decoration in the body:**

**Before:**
```dart
decoration: const BoxDecoration(
  gradient: LinearGradient(
    colors: [Colors.black, Colors.grey],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
),
```

**After:**
```dart
decoration: BoxDecoration(
  gradient: AppTheme.backgroundGradient,
),
```

### Step 3.4: Wrap Welcome Section in Card

**Find the welcome section (around line 380-395) and wrap it:**

**Before structure:**
```dart
Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [
      Text("Welcome ${loggedInUser.firstName}!", ...),
      // ... rest of welcome content
    ],
  ),
),
```

**After structure:**
```dart
Padding(
  padding: const EdgeInsets.all(AppTheme.spacingM),
  child: Card(
    elevation: AppTheme.elevationMid,
    color: AppTheme.surfaceLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusL),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          Text(
            "Welcome, ${loggedInUser.firstName}!",
            style: AppTheme.textTheme.headlineLarge,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            "${loggedInUser.firstName} ${loggedInUser.secondName}",
            style: AppTheme.textTheme.bodyLarge,
          ),
          Text(
            loggedInUser.email ?? "",
            style: AppTheme.textTheme.bodyMedium,
          ),
          // ... rest of welcome content
        ],
      ),
    ),
  ),
),
```

### Step 3.5: Update Daily Check-In Button

**Find the NeumorphicButton for check-in (around line 395-410) and replace with modern ElevatedButton:**

**Replace:**
```dart
NeumorphicButton(
  child: const Text('Check In', style: TextStyle(color: Colors.white, fontSize: 15)),
  onPressed: () {
    Get.to(const DailyCheckInPage());
  },
)
```

**With:**
```dart
Padding(
  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
  child: ElevatedButton.icon(
    onPressed: () {
      Get.to(const DailyCheckInPage());
    },
    icon: Icon(Icons.check_circle_outline, size: 24),
    label: Text(
      'Complete Daily Check-In',
      style: AppTheme.textTheme.labelLarge,
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accentSecondary,
      minimumSize: Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
    ),
  ),
)
```

### Step 3.6: Wrap Data Sections in Cards

**For BMI section, calories section, and mood chart, wrap each in Card widgets:**

Example for BMI section:
```dart
Card(
  elevation: AppTheme.elevationMid,
  color: AppTheme.surfaceLight,
  margin: const EdgeInsets.symmetric(
    horizontal: AppTheme.spacingM,
    vertical: AppTheme.spacingS,
  ),
  child: Padding(
    padding: const EdgeInsets.all(AppTheme.spacingL),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Body Mass Index',
          style: AppTheme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.spacingM),
        bmiResultIndication(),
        bmiSlider(),
      ],
    ),
  ),
)
```

Apply similar card wrapping for:
- Calories remaining section
- Mood tracker chart
- Weight changes (if visible)

### Step 3.7: Update Dividers

**Replace all `Divider` widgets:**

**Before:**
```dart
const Divider(
  color: Colors.grey,
  thickness: 2,
),
```

**After:**
```dart
Divider(
  color: AppTheme.surfaceElevated,
  thickness: 1,
  height: AppTheme.spacingL,
),
```

### Step 3.8: Test Dashboard

**Actions:**
1. Hot reload
2. Scroll through the entire dashboard
3. Verify all cards render correctly
4. Test the check-in button
5. Ensure all text is readable

---

## 4. Navigation & Components

**Goal:** Modernize the bottom navigation and shared components.

**Estimated Time:** 2 hours

### Step 4.1: Update Custom Navigation Bar

**File:** `lib/widgets/customnavbar.dart`

**Import theme:**
```dart
import 'package:health_app_fyp/theme/app_theme.dart';
```

**Replace the entire `build` method:**

```dart
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
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
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
              activeIcon: Icons.home,
              label: 'Home',
              onTap: () => Get.to(const HomePage()),
            ),
            _buildNavItem(
              icon: Icons.monitor_weight_outlined,
              activeIcon: Icons.monitor_weight,
              label: 'BMI',
              onTap: () => Get.to(const BMITDEE()),
            ),
            _buildNavItem(
              icon: Icons.restaurant_outlined,
              activeIcon: Icons.restaurant,
              label: 'Food',
              onTap: () => Get.to(const BarcodeScanner()),
            ),
            _buildNavItem(
              icon: Icons.mood_outlined,
              activeIcon: Icons.mood,
              label: 'Mood',
              onTap: () => Get.to(const ListMoods()),
            ),
            _buildNavItem(
              icon: Icons.bedtime_outlined,
              activeIcon: Icons.bedtime,
              label: 'Sleep',
              onTap: () => Get.to(const ListSleep()),
            ),
            _buildNavItem(
              icon: Icons.analytics_outlined,
              activeIcon: Icons.analytics,
              label: 'Stats',
              onTap: () => Get.to(const GraphsHome()),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildNavItem({
  required IconData icon,
  required IconData activeIcon,
  required String label,
  required VoidCallback onTap,
}) {
  // Simple implementation - can be enhanced with active state tracking
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
```

### Step 4.2: Update Neumorphic Button (Optional Enhancement)

**File:** `lib/widgets/nuemorphic_button.dart`

**Import theme and update colors to use theme palette:**

```dart
import 'package:health_app_fyp/theme/app_theme.dart';

// In the constructor, change default color:
NeumorphicButton({
  Key? key,
  required this.child,
  this.bevel = 10.0,
  this.padding = const EdgeInsets.all(12.5),
  required this.onPressed,
})  : blurOffset = Offset(bevel / 2, bevel / 2),
      color = AppTheme.surfaceLight,  // Changed from Colors.black
      super(key: key);
```

### Step 4.3: Create Reusable Section Card Widget

**File:** `lib/widgets/section_card.dart` (new file)

```dart
import 'package:flutter/material.dart';
import 'package:health_app_fyp/theme/app_theme.dart';

/// Reusable card widget for dashboard sections
class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const SectionCard({
    Key? key,
    this.title,
    required this.child,
    this.padding,
    this.margin,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: AppTheme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.spacingM),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
```

**Usage example in home_page.dart:**
```dart
import 'package:health_app_fyp/widgets/section_card.dart';

// Replace existing card implementations with:
SectionCard(
  title: 'Body Mass Index',
  child: Column(
    children: [
      bmiResultIndication(),
      bmiSlider(),
    ],
  ),
)
```

### Step 4.4: Test Navigation

**Actions:**
1. Hot reload
2. Tap each navigation icon
3. Verify navigation works
4. Check visual feedback on tap
5. Verify labels are readable

---

## 5. Validation & Handoff

**Goal:** Ensure code quality, document changes, and prepare for deployment.

**Estimated Time:** 2 hours

### Step 5.1: Run Flutter Analyze

**Command:**
```bash
cd /Users/conormongan/Documents/GitHub/Qualife/health_app_fyp
flutter analyze
```

**Expected result:** No errors. Address any warnings related to:
- Unused imports
- Missing const constructors
- Deprecated API usage

### Step 5.2: Run Tests

**Command:**
```bash
flutter test
```

**Action:** Fix any broken tests, especially widget tests that may reference old styling.

### Step 5.3: Visual Regression Testing

**Manual testing checklist:**

- [ ] Splash screen displays correctly
- [ ] Login screen card layout works on small and large screens
- [ ] Dashboard cards render without overflow
- [ ] Text is readable on all backgrounds
- [ ] Navigation bar icons are correctly aligned
- [ ] Forms validate correctly
- [ ] Buttons respond to touch with appropriate feedback
- [ ] Charts and graphs use new color palette
- [ ] Dark theme consistency across all screens

### Step 5.4: Capture Screenshots

**Actions:**
1. Launch app on iOS simulator or Android emulator
2. Capture screenshots for:
   - Splash screen
   - Login screen
   - Home dashboard (scrolled to show different sections)
   - Navigation bar in different states

3. Save to `docs/screenshots/` folder (create if needed)

### Step 5.5: Performance Check

**Command:**
```bash
flutter run --profile
```

**Verify:**
- App launches in under 3 seconds
- Smooth 60fps scrolling on dashboard
- No jank during navigation transitions
- Memory usage remains stable

### Step 5.6: Create Migration Document

**File:** `MIGRATION_NOTES.md` (new file in project root)

```markdown
# UX/UI Enhancement Migration Notes

**Date:** October 22, 2025  
**Version:** 1.0

## Summary of Changes

This update introduces a comprehensive design system refresh focused on:
- Wellness-inspired color palette
- Modern typography using Google Fonts
- Card-based UI components
- Improved spacing and hierarchy
- Enhanced accessibility

## Breaking Changes

None. All changes are visual and do not affect data models or business logic.

## New Dependencies

- `google_fonts: ^6.1.0` - For Poppins and Inter typography

## Files Modified

### New Files
- `lib/theme/app_theme.dart` - Centralized design system
- `lib/widgets/section_card.dart` - Reusable card component
- `UX_UI_ENHANCEMENT_GUIDE.md` - Implementation guide

### Modified Files
- `lib/main.dart` - Theme integration, splash screen redesign
- `lib/screens/login_screen.dart` - Modern card-based layout
- `lib/screens/home_page.dart` - Dashboard card sections
- `lib/widgets/customnavbar.dart` - Rounded, elevated navigation
- `lib/widgets/nuemorphic_button.dart` - Theme color integration
- `pubspec.yaml` - Added google_fonts dependency
- `README.md` - Updated with enhancement plan

## Rollback Instructions

To revert these changes:

```bash
git log --oneline -n 10  # Find commit before UX update
git checkout <commit-hash> -- lib/ pubspec.yaml
flutter pub get
```

## Known Issues

None at this time.

## Future Enhancements

Consider for next iteration:
- Dark/light theme toggle
- Accessibility audit (font scaling, contrast ratios)
- Animated transitions between screens
- Haptic feedback on button presses
- Localization support for multiple languages
```

### Step 5.7: Update README

**File:** `README.md`

**Add a "Recent Updates" section after the enhancement plan:**

```markdown
## Recent Updates

### October 2025 - UX/UI Refresh v1.0 ✅

We've completed a comprehensive visual redesign focused on modern wellness aesthetics:

- ✨ **New Design System** - Centralized theme with calming blues, teals, and coral accents
- 🎨 **Modern Typography** - Google Fonts (Poppins + Inter) for improved readability
- 📱 **Card-Based UI** - Cleaner hierarchy with elevated card sections
- 🎯 **Enhanced Navigation** - Rounded, translucent bottom bar with clear active states
- 🚀 **Polished Entry Flow** - Redesigned splash and login screens

See `UX_UI_ENHANCEMENT_GUIDE.md` for implementation details and `MIGRATION_NOTES.md` for technical changes.
```

### Step 5.8: Commit Changes

**Commands:**
```bash
cd /Users/conormongan/Documents/GitHub/Qualife/health_app_fyp
git add .
git commit -m "feat: Comprehensive UX/UI refresh with modern design system

- Add centralized AppTheme with wellness-inspired palette
- Integrate Google Fonts (Poppins/Inter) for typography
- Redesign splash and login screens with card-based layouts
- Update home dashboard with elevated card sections
- Modernize bottom navigation with rounded, translucent styling
- Create reusable SectionCard widget
- Add comprehensive enhancement guide and migration notes

Closes #[issue-number] (if applicable)"
```

### Step 5.9: Final Checklist

Before marking complete:

- [ ] All files compile without errors
- [ ] `flutter analyze` shows no errors
- [ ] App runs successfully on at least one platform
- [ ] Core user flows tested (login, dashboard, navigation)
- [ ] Screenshots captured and saved
- [ ] Documentation updated (README, guides)
- [ ] Changes committed to version control
- [ ] Optional: Create pull request for team review

---

## Appendix: Color Palette & Typography Reference

### Color Palette

**Primary Colors**
- `primaryDark` - #1A2332 - Deep Navy (backgrounds, headers)
- `primaryMid` - #2D3E50 - Slate Blue (navigation, cards)
- `primaryLight` - #4A5F7F - Soft Steel (borders, dividers)

**Accent Colors**
- `accentPrimary` - #6EC1E4 - Sky Blue (CTAs, links, highlights)
- `accentSecondary` - #54D2D2 - Mint Teal (secondary actions)
- `accentWarm` - #FFA07A - Light Coral (alerts, emphasis)

**Semantic Colors**
- `successGreen` - #4CAF50
- `warningAmber` - #FFC107
- `errorRed` - #EF5350
- `infoBlue` - #42A5F5

**Text Colors**
- `textPrimary` - #FFFFFF (primary content)
- `textSecondary` - #B0BEC5 (secondary content)
- `textTertiary` - #78909C (hints, labels)
- `textDisabled` - #546E7A (disabled states)

### Typography Scale

**Display** (Poppins, bold/semi-bold)
- Large: 32px, bold
- Medium: 28px, bold
- Small: 24px, semi-bold

**Headline** (Poppins, semi-bold/medium)
- Large: 22px
- Medium: 20px
- Small: 18px

**Body** (Inter, normal)
- Large: 16px
- Medium: 14px
- Small: 12px

**Label** (Inter, semi-bold/medium)
- Large: 15px
- Medium: 13px
- Small: 11px

### Spacing Scale

- XS: 4px
- S: 8px
- M: 16px (base unit)
- L: 24px
- XL: 32px
- XXL: 48px

### Border Radius

- S: 8px
- M: 12px (standard for cards, buttons)
- L: 16px
- XL: 24px
- Full: 999px (circular)

### Elevation

- Low: 2dp (subtle lift)
- Mid: 4dp (cards, buttons)
- High: 8dp (navigation, modals)

---

## Support & Questions

For questions or issues during implementation:

1. Check the Flutter documentation: https://flutter.dev/docs
2. Review Google Fonts package docs: https://pub.dev/packages/google_fonts
3. Refer to Material Design guidelines: https://material.io/design
4. Open an issue in the project repository

**Document Version:** 1.0  
**Last Updated:** October 22, 2025  
**Maintainer:** Development Team
