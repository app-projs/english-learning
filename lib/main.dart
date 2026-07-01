import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/lumina_home_screen.dart';
import 'theme/lumina_theme.dart';
import 'services/storage_service.dart';
import 'services/word_service.dart';
import 'services/sentence_service.dart';
import 'services/dialogue_service.dart';
import 'services/article_service.dart';
import 'services/user_service.dart';
import 'services/theme_service.dart';
import 'services/database_service.dart';

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
  wordService = WordService(storageService);
  sentenceService = SentenceService(storageService);
  dialogueService = DialogueService(storageService);
  articleService = ArticleService();
  userService = UserService(storageService);
  themeService = ThemeService(storageService);

  runApp(const ProviderScope(child: EnglishLearningApp()));
}

class EnglishLearningApp extends StatefulWidget {
  const EnglishLearningApp({super.key});

  @override
  State<EnglishLearningApp> createState() => _EnglishLearningAppState();
}

class _EnglishLearningAppState extends State<EnglishLearningApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await themeService.isDarkMode();
    if (mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    themeService.setDarkMode(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Learning App',
      theme: LuminaTheme.lightTheme,
      // Lumina Learning currently uses a pristine light theme design system
      home: const LuminaHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
