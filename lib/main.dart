import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/lumina_home_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/lumina_theme.dart';
import 'services/storage_service.dart';
import 'services/word_service.dart';
import 'services/sentence_service.dart';
import 'services/dialogue_service.dart';
import 'services/article_service.dart';
import 'services/user_service.dart';
import 'services/theme_service.dart';
import 'services/database_service.dart';

import 'services/audio_service.dart';

late StorageService storageService;
late WordService wordService;
late SentenceService sentenceService;
late DialogueService dialogueService;
late ArticleService articleService;
late UserService userService;
late ThemeService themeService;
late DatabaseService databaseService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  storageService = await StorageService.getInstance();
  databaseService = await DatabaseService.getInstance();
  wordService = WordService(storageService, databaseService);
  sentenceService = SentenceService(storageService, databaseService);
  dialogueService = DialogueService(storageService, databaseService);
  articleService = ArticleService(storageService, databaseService);
  userService = UserService(storageService);
  themeService = ThemeService(storageService);
  await AudioService.instance.init();

  runApp(const ProviderScope(child: EnglishLearningApp()));
}

class EnglishLearningApp extends StatelessWidget {
  const EnglishLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.isDarkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'lumina English',
          theme: isDark ? ThemeService.darkTheme : LuminaTheme.lightTheme,
          darkTheme: ThemeService.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(
            isDarkMode: isDark,
            onThemeChanged: (val) => themeService.setDarkMode(val),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
