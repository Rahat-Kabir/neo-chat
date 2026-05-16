# NeoChat Flutter App

AI-powered cross-platform chat app with Firebase auth, Firestore persistence, private AI chat, and public chat rooms.

## Project Structure

```text
lib/
  main.dart
  config/
    api_config.dart
  models/
    chat_message.dart
    public_chat_message.dart
  providers/
    chat_provider.dart
    public_chat_provider.dart
  screens/
    splash_screen.dart
    home_screen.dart
    auth/
    chat/
  services/
    ai_service.dart
    openai_compatible_service.dart
    auth_service.dart
    firestore_service.dart
    public_chat_service.dart
    user_service.dart
  widgets/
    chat_composer.dart
    message_bubble.dart
    public_message_bubble.dart
    typing_bubble.dart
```

## Setup

Run commands from this `neo_chat/` directory unless noted otherwise.

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Firebase

Generate `lib/firebase_options.dart` with FlutterFire:

```bash
firebase login
flutterfire configure
```

You can also copy `lib/firebase_options.dart.template` to `lib/firebase_options.dart` and fill it manually. See [FIREBASE_SETUP.md](../FIREBASE_SETUP.md).

### 3. Configure API Keys

Create `../env.json` at the repo root. The setup scripts will create a blank file:

```bash
# Windows
setup_api_config.bat

# Linux/macOS
chmod +x setup_api_config.sh
./setup_api_config.sh
```

Manual version:

```json
{
  "OPENROUTER_API_KEY": "",
  "OPENAI_API_KEY": ""
}
```

`env.json` is gitignored. Do not commit real keys.

### 4. Run

```bash
flutter run -d chrome --dart-define-from-file=../env.json
flutter run -d android --dart-define-from-file=../env.json
flutter run -d ios --dart-define-from-file=../env.json
flutter run -d windows --dart-define-from-file=../env.json
```

VS Code users can use the checked-in `.vscode/launch.json` configs.

## AI Integration

`AIService` dispatches through `OpenAICompatibleService`, which supports OpenRouter and direct OpenAI chat-completions endpoints. Provider URLs, headers, model lists, and default models live in `lib/config/api_config.dart`.

Anthropic Claude models are currently reached through OpenRouter. There is no direct Anthropic Messages API client yet.

## Quality Checks

```bash
flutter analyze
flutter test
```

## Release Builds

```bash
flutter build apk --release --dart-define-from-file=../env.json
flutter build appbundle --release --dart-define-from-file=../env.json
flutter build web --release --dart-define-from-file=../env.json
```

API keys passed with `--dart-define-from-file` are compiled into client apps and can be extracted from distributed builds. For public distribution, proxy AI calls through a backend.

## Firestore Rules

Deploy from the repo root:

```bash
firebase deploy --only firestore:rules
```
