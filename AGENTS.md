# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

This repo is a Flutter app nested one level deep — the actual project lives in [neo_chat/](neo_chat/). Run all `flutter` / `dart` commands from that subdirectory, not the repo root. Root-level files are auxiliary: [firestore.rules](firestore.rules), [FIREBASE_SETUP.md](FIREBASE_SETUP.md), and `demo/` screenshots.

## Common commands

Run from [neo_chat/](neo_chat/):

- Install deps: `flutter pub get`
- Run app: `flutter run -d chrome` (web) · `-d android` · `-d ios` · `-d windows` · `-d macos` · `-d linux`
- Analyze / lint: `flutter analyze` (uses [analysis_options.yaml](neo_chat/analysis_options.yaml), `flutter_lints`)
- Test all: `flutter test`
- Test a single file: `flutter test test/widget_test.dart`
- Test a single name: `flutter test --plain-name "test description"`

Run from repo root:

- Deploy Firestore rules: `firebase deploy --only firestore:rules`

## First-run setup

First-run local files:

1. `lib/firebase_options.dart` — **required to compile.** Copy from `lib/firebase_options.dart.template` and fill in manually, or regenerate via `flutterfire configure`. Gitignored. See [FIREBASE_SETUP.md](FIREBASE_SETUP.md).
2. API keys come from root-level `env.json` via `--dart-define-from-file=../env.json`. The file is gitignored and must not be committed. `lib/config/api_config.dart` is checked in because it contains only `String.fromEnvironment(...)` lookups and no real keys.

## Architecture

### State management
`provider` package, `ChangeNotifier` pattern. Two top-level providers are wired in [main.dart](neo_chat/lib/main.dart):
- `ChatProvider` — 1:1 chat between the user and an AI model.
- `PublicChatProvider` — multi-user group chat rooms.

These are independent feature stacks; do not cross-couple them.

### AI provider abstraction
[lib/services/ai_service.dart](neo_chat/lib/services/ai_service.dart) is a singleton facade that dispatches on an `ApiProvider` enum (defined in [lib/config/api_config.dart](neo_chat/lib/config/api_config.dart)) to a shared OpenAI-compatible client:
- [openai_compatible_service.dart](neo_chat/lib/services/openai_compatible_service.dart) — OpenRouter and OpenAI chat-completions client

Anthropic Claude is reachable today **only through OpenRouter** (`anthropic/claude-haiku-4.5` and `anthropic/claude-sonnet-4.5` are listed in `openRouterModels` in [api_config.dart](neo_chat/lib/config/api_config.dart)) — there is no direct Anthropic SDK integration and no `anthropic` arm on the `ApiProvider` enum. To add a true direct-Anthropic provider: extend the `ApiProvider` enum, create a new service for Anthropic's Messages API, and add a dispatch arm in `AIService`. UI never talks to provider clients directly — always go through `AIService`.

### Firestore access boundary
Widgets and providers must not call `cloud_firestore` directly. All reads/writes go through service classes:
- [firestore_service.dart](neo_chat/lib/services/firestore_service.dart) — generic Firestore helpers
- [public_chat_service.dart](neo_chat/lib/services/public_chat_service.dart) — group-chat collections
- [user_service.dart](neo_chat/lib/services/user_service.dart) — user profile documents
- [auth_service.dart](neo_chat/lib/services/auth_service.dart) — Firebase Auth (email/password + Google Sign-In)

Document shapes in [lib/models/](neo_chat/lib/models/) (`chat_message.dart`, `public_chat_message.dart`) must stay aligned with the schema assumed by [firestore.rules](firestore.rules) — changing one without the other will surface as permission-denied errors at runtime, not compile errors.

### Navigation flow
[SplashScreen](neo_chat/lib/screens/splash_screen.dart) → [AuthWrapper](neo_chat/lib/screens/auth/auth_wrapper.dart) (decides logged-in vs. auth screens) → [HomeScreen](neo_chat/lib/screens/home_screen.dart) → chat surfaces under [screens/chat/](neo_chat/lib/screens/chat/).

## Conventions

- Theming: Material 3, seed color `Color(0xFF6C63FF)`, light + dark variants defined in [main.dart](neo_chat/lib/main.dart).
- Cross-platform: code must build for Android, iOS, Web, Windows, macOS, and Linux — avoid platform-only APIs without conditional imports.
