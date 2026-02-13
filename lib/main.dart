import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'services/word_service.dart';
import 'services/sentence_service.dart';
import 'services/dialogue_service.dart';
import 'services/article_service.dart';
import 'services/user_service.dart';

late StorageService storageService;
late WordService wordService;
late SentenceService sentenceService;
late DialogueService dialogueService;
late ArticleService articleService;
late UserService userService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  storageService = await StorageService.getInstance();
  wordService = WordService(storageService);
  sentenceService = SentenceService(storageService);
  dialogueService = DialogueService(storageService);
  articleService = ArticleService();
  userService = UserService(storageService);

  runApp(const EnglishLearningApp());
}

class EnglishLearningApp extends StatelessWidget {
  const EnglishLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Learning App',
      theme: ThemeData(
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
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
