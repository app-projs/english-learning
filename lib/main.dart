import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/screens/splash_screen.dart';
import 'core/theme/lumina_theme.dart';
import 'core/services/storage_service.dart';
import 'features/word/services/word_service.dart';
import 'features/sentence/services/sentence_service.dart';
import 'features/dialogue/services/dialogue_service.dart';
import 'features/article/services/article_service.dart';
import 'features/profile/services/user_service.dart';
import 'core/theme/theme_service.dart';
import 'core/services/database_service.dart';

import 'core/services/audio_service.dart';

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
