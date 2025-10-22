import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Qualife App Theme
/// Centralized design system with wellness-inspired colors and typography
class AppTheme {
  // ============================================================================
  // Color Palette - Soft Wellness Theme
  // ============================================================================
  // Primary colors - Calming Blues & Teals
  static const Color primaryDark = Color(0xFF1A2332); // Deep Navy
  static const Color primaryMid = Color(0xFF2D3E50); // Slate Blue
  static const Color primaryLight = Color(0xFF4A5F7F); // Soft Steel

  // Accent colors - Energizing Coral & Mint
  static const Color accentPrimary = Color(0xFF6EC1E4); // Sky Blue
  static const Color accentSecondary = Color(0xFF54D2D2); // Mint Teal
  static const Color accentWarm = Color(0xFFFFA07A); // Light Coral

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
        iconTheme: const IconThemeData(color: textPrimary),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: elevationMid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        margin: const EdgeInsets.symmetric(
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
          padding: const EdgeInsets.symmetric(
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: surfaceElevated, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: accentPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        hintStyle: const TextStyle(color: textTertiary),
        labelStyle: const TextStyle(color: textSecondary),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
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
  static LinearGradient get primaryGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryDark,
          primaryMid,
          primaryLight,
        ],
      );

  static LinearGradient get accentGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentPrimary,
          accentSecondary,
        ],
      );

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          backgroundDark,
          primaryDark,
        ],
      );
}
