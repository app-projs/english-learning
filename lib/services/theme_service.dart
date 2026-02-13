import 'package:flutter/material.dart';
import 'storage_service.dart';

class ThemeService {
  final StorageService _storage;

  ThemeService(this._storage);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E7D32),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B5E20),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF4CAF50),
      unselectedItemColor: Colors.grey,
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
