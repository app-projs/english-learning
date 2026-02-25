import 'package:flutter/material.dart';
import 'storage_service.dart';

class ThemeService {
  final StorageService _storage;

  ThemeService(this._storage);

  static const Color _primaryColor = Color(0xFF6366F1);
  static const Color _secondaryColor = Color(0xFF8B5CF6);
  static const Color _accentColor = Color(0xFF10B981);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _accentColor,
      surface: const Color(0xFFF8FAFC),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: Color(0xFF1E293B),
      titleTextStyle: TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: const BorderSide(color: _primaryColor, width: 1.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Color(0xFF94A3B8),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF1F5F9),
      selectedColor: _primaryColor.withOpacity(0.15),
      labelStyle: const TextStyle(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: _primaryColor,
      unselectedLabelColor: Color(0xFF94A3B8),
      indicatorColor: _primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _accentColor,
      surface: const Color(0xFF0F172A),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color(0xFF1E293B),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: const BorderSide(color: _primaryColor, width: 1.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      selectedItemColor: _primaryColor,
      unselectedItemColor: Color(0xFF64748B),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF334155),
      selectedColor: _primaryColor.withOpacity(0.3),
      labelStyle: const TextStyle(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: _primaryColor,
      unselectedLabelColor: Color(0xFF64748B),
      indicatorColor: _primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF334155),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  Future<bool> isDarkMode() async {
    final settings = _storage.getSettings();
    return settings['darkMode'] ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    await _storage.updateSetting('darkMode', value);
  }

  ThemeData getTheme(bool isDark) {
    return isDark ? darkTheme : lightTheme;
  }
}

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF1E293B);

  static const Color lightText = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static const List<Color> gradientPrimary = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> gradientSuccess = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];

  static const List<Color> gradientWarning = [
    Color(0xFFF59E0B),
    Color(0xFFFBBF24),
  ];

  static const List<Color> gradientError = [
    Color(0xFFEF4444),
    Color(0xFFF87171),
  ];
}
