# Agent Guide: English Learning App (Flutter)

Welcome to the English Learning App repository. This guide provides essential information for AI agents to navigate, understand, and contribute to this Flutter-based codebase.

## 🚀 Essential Commands

| Task | Command |
|------|---------|
| **Setup** | `flutter pub get` |
| **Run (Windows)** | `flutter run -d windows` |
| **Run (Web)** | `flutter run -d chrome` or `flutter run -d edge` |
| **Lint/Analyze** | `flutter analyze` |
| **Test** | `flutter test` |
| **Clean** | `flutter clean` |

> [!TIP]
> On Windows, you can use `start.bat` in the root directory for a guided startup menu.

## 📂 Project Structure

The project follows a feature-layered architecture (simplified for now, with plans to migrate to Clean Architecture):

```text
lib/
├── main.dart             # Entry point, service initialization, and app root
├── models/               # Data entities (Article, Word, Sentence, User)
├── screens/              # UI Pages (Home, Practice, Stats, etc.)
├── services/             # Business logic and data access (ArticleService, WordService, etc.)
├── mock/                 # Static mock data for development and testing
├── widgets/              # Reusable UI components (modern_ui.dart)
└── services/
    ├── database_service.dart # SQLite implementation
    ├── storage_service.dart  # SharedPreferences implementation
    └── ...
```

## 🏗️ Architecture & Patterns

### Service Layer
Services encapsulate business logic and data fetching. 
- **Mock Toggle**: Most services have a `_useMockData` flag (defaulting to `true`). 
- **Persistence**: Services interact with `StorageService` (for simple KV/Prefs) and `DatabaseService` (for structured SQLite data).

### State Management
Currently using standard **`StatefulWidget`** for local state. 
- *Planned*: Migration to **Provider** or **Riverpod**.

### Local Storage
- **SharedPreferences**: Used for user settings, simple progress, and flags (`StorageService`).
- **SQLite (sqflite)**: Used for structured data like practice history and wrong answers (`DatabaseService`).

## 🎨 Coding Conventions

- **Linting**: Follows `package:flutter_lints/flutter.yaml`. Run `flutter analyze` frequently.
- **Naming**: 
  - Classes: `PascalCase`
  - Variables/Methods: `camelCase`
  - Files: `snake_case.dart`
- **Comments**: Documentation in `docs/` is primarily in Chinese, while code comments vary. Stick to English for new code comments unless requested otherwise.
- **Services**: Always initialize services in `main.dart` before `runApp()` if they require async initialization.

## ⚠️ Important Gotchas

1. **Async Initialization**: `WidgetsFlutterBinding.ensureInitialized()` is required in `main.dart` for plugin initialization (SharedPrefs, SQLite).
2. **Mock Data**: If you see data not updating from an API/Database, check the `_useMockData` flag in the respective service.
3. **Paths**: Use absolute imports (e.g., `import 'package:flutter_app/models/word.dart'`) or relative imports consistently. The project currently uses relative imports (e.g., `import '../models/word.dart'`).

## 📚 Documentation Reference

- `docs/ARCHITECTURE.md`: Detailed directory and service layer breakdown.
- `docs/plan/tech-stack.md`: Current and future technology roadmap.
- `docs/plan/development-progress.md`: Feature completion status and technical debt.
- `docs/plan/module-execution-plan.md`: Implementation details for various modules.

## 🛠️ Development Workflow for Agents

1. **Read `pubspec.yaml`** to check for available packages before adding new dependencies.
2. **Check `lib/mock/`** when implementing new UI features to see available test data.
3. **Update `docs/plan/development-progress.md`** when completing a major milestone or fixing significant tech debt.
4. **Run `flutter analyze`** before finishing any task to ensure no linting regressions.
