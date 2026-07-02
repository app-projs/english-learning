# Agent Guide: English Learning App (Flutter)

This guide highlights the key architecture patterns, coding conventions, and workflow rules specific to this repository.

## 🏗️ Architecture & Patterns

- **Service Layer & Mocking**: Services handle business logic and persistence. Most services use a `_useMockData` flag (defaulting to `true`). 
- **State Management**: Standard `StatefulWidget` is used for local state (migration to Provider/Riverpod is planned).
- **Local Storage**: `StorageService` implements SharedPreferences for settings/flags. `DatabaseService` implements SQLite (sqflite) for structured progress/history.

## 🎨 Coding Conventions & Gotchas

- **Naming & Linting**: Follow `package:flutter_lints/flutter.yaml`. Class names use `PascalCase`, methods/variables use `camelCase`, and files use `snake_case.dart`.
- **Async Initialization**: `WidgetsFlutterBinding.ensureInitialized()` is required in `main.dart` for initializing plugins (SharedPrefs, SQLite).
- **Paths**: Use relative imports (e.g., `import '../models/word.dart'`) consistently across the codebase.
- **Comments**: Keep comments precise. Write new comments in Chinese or English as appropriate (default to English for code comments unless requested otherwise).

## 📚 Documentation Reference

- [ARCHITECTURE.md](file:///d:/workspace/test/english-learning/docs/ARCHITECTURE.md): Detailed directory and service layer breakdown.
- [tech-stack.md](file:///d:/workspace/test/english-learning/docs/plan/tech-stack.md): Current and future technology roadmap.
- [development-progress.md](file:///d:/workspace/test/english-learning/docs/plan/development-progress.md): Feature completion status and technical debt.
- [module-execution-plan.md](file:///d:/workspace/test/english-learning/docs/plan/module-execution-plan.md): Implementation details for various modules.

## 🛠️ Development Workflow & Checks

1. **Dependency Check**: Read `pubspec.yaml` before adding new packages.
2. **Mock Data**: Check `lib/mock/` for mock data when building UI.
3. **Plan Sync**: When finishing a feature, check the corresponding module execution plan, update progress in `docs/plan/development-progress.md`, and run `flutter analyze`.
4. **Code Quality**: Always run `flutter analyze` before finishing a task to ensure no linting regressions.