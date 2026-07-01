import 'package:flutter/material.dart';
import 'storage_service.dart';

class ThemeService {
  final StorageService _storage;

  ThemeService(this._storage);

  static const Color _primaryColor = Color(0xFF7F56FF); // 皇家紫
  static const Color _secondaryColor = Color(0xFF20C997); // 翠绿
  static const Color _accentColor = Color(0xFFFF9E1B); // 活力黄/橙

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _accentColor,
      surface: const Color(0xFFF6F5FF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F5FF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: Color(0xFF212529),
      titleTextStyle: TextStyle(
        color: Color(0xFF212529),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
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
          borderRadius: BorderRadius.circular(24), // 胶囊大圆角
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
          borderRadius: BorderRadius.circular(24),
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
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Color(0xFF868E96),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE9ECEF),
      selectedColor: _primaryColor.withOpacity(0.15),
      labelStyle: const TextStyle(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: _primaryColor,
      unselectedLabelColor: Color(0xFF868E96),
      indicatorColor: _primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE9ECEF),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
      surface: const Color(0xFF121416),
    ),
    scaffoldBackgroundColor: const Color(0xFF121416),
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
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF2B3035), width: 1),
      ),
      color: const Color(0xFF1A1D20),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
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
          borderRadius: BorderRadius.circular(24),
        ),
        side: const BorderSide(color: _primaryColor, width: 1.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1D20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2B3035)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A1D20),
      selectedItemColor: _primaryColor,
      unselectedItemColor: Color(0xFF495057),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2B3035),
      selectedColor: _primaryColor.withOpacity(0.3),
      labelStyle: const TextStyle(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: _primaryColor,
      unselectedLabelColor: Color(0xFF495057),
      indicatorColor: _primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2B3035),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2B3035),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
  static const Color primary = Color(0xFF7F56FF);
  static const Color secondary = Color(0xFF20C997);
  static const Color accent = Color(0xFFFF9E1B);
  static const Color error = Color(0xFFFF4E73);
  static const Color warning = Color(0xFFFFC043);
  static const Color success = Color(0xFF58CC02);
  static const Color info = Color(0xFF228BE6);

  static const Color lightBackground = Color(0xFFF6F5FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  static const Color darkBackground = Color(0xFF121416);
  static const Color darkSurface = Color(0xFF1A1D20);
  static const Color darkCard = Color(0xFF1A1D20);

  static const Color lightText = Color(0xFF212529);
  static const Color lightTextSecondary = Color(0xFF495057);
  static const Color darkText = Color(0xFFECEFEE);
  static const Color darkTextSecondary = Color(0xFFADB5BD);

  static const List<Color> gradientPrimary = [
    Color(0xFF7F56FF),
    Color(0xFF6C4EFA),
  ];

  static const List<Color> gradientSuccess = [
    Color(0xFF58CC02),
    Color(0xFF46A302),
  ];

  static const List<Color> gradientWarning = [
    Color(0xFFFF9E1B),
    Color(0xFFFFC043),
  ];

  static const List<Color> gradientError = [
    Color(0xFFFF6B8B),
    Color(0xFFFF4E73),
  ];
}
