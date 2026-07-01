import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LuminaColors {
  static const Color primary = Color(0xFF5E39E0);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF7757FA);
  
  static const Color secondary = Color(0xFF904D00);
  static const Color onSecondary = Color(0xFFFFFFFF);
  
  static const Color tertiary = Color(0xFF00647C);
  
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFF8F9FE);
  static const Color surfaceContainerLow = Color(0xFFF2F3F8);
  static const Color onSurface = Color(0xFF191C1F);
  
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF00D995); // Custom from DESIGN.md
  static const Color warning = Color(0xFFFF6B6B); // Custom from DESIGN.md

  static const Color outline = Color(0xFF797587);
  static const Color surfaceVariant = Color(0xFFE1E2E7);
}

class LuminaTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: LuminaColors.primary,
        onPrimary: LuminaColors.onPrimary,
        primaryContainer: LuminaColors.primaryContainer,
        secondary: LuminaColors.secondary,
        onSecondary: LuminaColors.onSecondary,
        tertiary: LuminaColors.tertiary,
        background: LuminaColors.background,
        surface: LuminaColors.surface,
        onSurface: LuminaColors.onSurface,
        error: LuminaColors.error,
      ),
      scaffoldBackgroundColor: LuminaColors.background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02 * 28,
          color: LuminaColors.onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: LuminaColors.onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: LuminaColors.onSurface,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: LuminaColors.onSurface,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: LuminaColors.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LuminaColors.primary,
          foregroundColor: LuminaColors.onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 0,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: LuminaColors.surfaceVariant, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
