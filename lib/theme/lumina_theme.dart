import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LuminaColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  
  static const Color secondary = Color(0xFF0F766E); // Teal instead of brown
  static const Color onSecondary = Color(0xFFFFFFFF);
  
  static const Color tertiary = Color(0xFFF59E0B); // Amber instead of deep cyan
  
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color onSurface = Color(0xFF0F172A); // Slate 900
  
  static const Color error = Color(0xFFEF4444); // Slate red
  static const Color success = Color(0xFF10B981); // Slate emerald green
  static const Color warning = Color(0xFFF59E0B); // Slate orange/amber

  static const Color outline = Color(0xFF94A3B8);
  static const Color surfaceVariant = Color(0xFFE2E8F0);
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
