# NeoChat 🚀

**NeoChat** is an AI-powered chat application built with Flutter that combines real-time messaging with intelligent AI conversations. Experience the future of communication with seamless integration of multiple AI models and modern chat features.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

## Quick Start

```bash
git clone https://github.com/Rahat-Kabir/neo-chat.git
cd neo-chat/neo_chat
flutter pub get
flutterfire configure
setup_api_config.bat
flutter run -d chrome --dart-define-from-file=../env.json
```

On Linux/macOS, run `chmod +x setup_api_config.sh && ./setup_api_config.sh` from `neo_chat/` instead of the `.bat` script.

## 📸 Screenshots

<p align="center">
  <img src="demo/neochatdemo1.jpg" width="30%" alt="NeoChat Screenshot 1">
  <img src="demo/neochatdemo2.jpg" width="30%" alt="NeoChat Screenshot 2">
  <img src="demo/neochatdemo3.jpg" width="30%" alt="NeoChat Screenshot 3">
</p>

## ✨ Features

### Core Features
- **User Authentication** - Secure Firebase Auth with email/password and Google Sign-In
- **AI Chat Interface** - Modern chat UI with AI conversation support
- **Real-time Messaging** - Firebase Firestore integration with message persistence
- **Group Chat Rooms** - Multi-user chat rooms with real-time synchronization
- **Multi-Model AI Support** - Direct integration with OpenRouter and OpenAI; Anthropic Claude models accessible via OpenRouter
- **Cross-platform Support** - Works seamlessly on iOS, Android, Web, and Desktop

### Technical Features
- **Material Design 3** - Modern UI with light/dark theme support
- **Responsive Design** - Optimized for all screen sizes
- **Real-time Synchronization** - Instant message delivery and chat history
- **Secure Data Storage** - Firebase Firestore with comprehensive security rules
- **State Management** - Efficient Provider pattern implementation
- **Offline Support** - Message caching and synchronization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Firebase account
- OpenRouter and/or OpenAI API key (for AI features)
- Firebase CLI + FlutterFire CLI (`npm install -g firebase-tools` and `dart pub global activate flutterfire_cli`)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Rahat-Kabir/neo-chat.git
   cd neo-chat/neo_chat
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** — generates `lib/firebase_options.dart` (gitignored)
   ```bash
   firebase login
   flutterfire configure
   ```
   Pick or create a Firebase project, then select Android / iOS / Web / Windows / macOS as needed. See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for details.

4. **Configure API Keys** — create `env.json` at the **repo root** (gitignored, never committed):
   ```json
   {
     "OPENROUTER_API_KEY": "sk-or-v1-...",
     "OPENAI_API_KEY": ""
   }
   ```
   Leave a key empty if you don't use that provider. Keys are injected at build time via `--dart-define-from-file` (see commands below) — they are **not** stored in `api_config.dart`.

5. **Deploy Firestore Security Rules** (from repo root)
   ```bash
   firebase deploy --only firestore:rules
   ```

6. **Run the application** — from `neo_chat/`, always pass the env file:
   ```bash
   # Web
   flutter run -d chrome   --dart-define-from-file=../env.json

   # Android (device/emulator connected)
   flutter run -d android  --dart-define-from-file=../env.json

   # iOS
   flutter run -d ios      --dart-define-from-file=../env.json

   # Desktop (Windows / macOS / Linux)
   flutter run -d windows  --dart-define-from-file=../env.json
   ```
   VS Code users: the [.vscode/launch.json](neo_chat/.vscode/launch.json) configurations pass the flag automatically — just hit **F5**.

### Build a Release APK

From `neo_chat/`:
```bash
# Fat APK (single file, all CPU architectures)
flutter build apk --release --dart-define-from-file=../env.json

# Split per ABI (smaller per-device APKs)
flutter build apk --release --split-per-abi --dart-define-from-file=../env.json

# Play Store bundle
flutter build appbundle --release --dart-define-from-file=../env.json
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

> ⚠️ API keys are compiled into the APK and can be extracted by decompilation. For personal builds this is fine; for public distribution, proxy AI calls through a backend instead of shipping keys in the client.

## 🏗️ Project Structure

```
neo-chat/
├── neo_chat/                # Flutter application
│   ├── lib/
│   │   ├── main.dart        # App entry point
│   │   ├── config/          # API and app configuration
│   │   ├── models/          # Data models
│   │   ├── providers/       # State management
│   │   ├── screens/         # UI screens
│   │   ├── services/        # Business logic & APIs
│   │   └── widgets/         # Reusable UI components
│   └── pubspec.yaml         # Dependencies
├── FIREBASE_SETUP.md        # Firebase configuration guide
├── firestore.rules          # Firestore security rules
├── LICENSE                  # MIT License
└── README.md               # This file
```

## 🤖 AI Integration

NeoChat dispatches through a single OpenAI-compatible client ([lib/services/openai_compatible_service.dart](neo_chat/lib/services/openai_compatible_service.dart)) keyed by an `ApiProvider` enum. Currently wired:

- **OpenRouter** — GPT-OSS 20B (free), Llama 3.3 70B (free), Gemini 2.5 Flash, Claude Haiku 4.5, Claude Sonnet 4.5, GPT-4o, GPT-4.1
- **OpenAI** (direct) — GPT-4o, GPT-4o mini, GPT-4.1, GPT-4.1 mini
- **Anthropic Claude** — reached via OpenRouter. There is no direct Anthropic Messages-API client yet.

The model list lives in [lib/config/api_config.dart](neo_chat/lib/config/api_config.dart); to add a new OpenAI-compatible provider (Groq, Together, Mistral, …) just extend the enum and add cases — no new service file needed.

### Features
- Context-aware conversations
- Multi-model selection
- Conversation history persistence

## 🔐 Security & Privacy

- **Secure Authentication** - Firebase Authentication with email/password and OAuth
- **Data Encryption** - All communications use HTTPS
- **Firestore Security Rules** - User data isolation and access control
- **API Key Management** - Template-based secure configuration
- **Privacy Protection** - Individual user data isolation

## 📱 Supported Platforms

- ✅ **Android** - Fully tested and supported
- ✅ **iOS** - Full support with native features
- ✅ **Web** - Progressive Web App capabilities
- ✅ **Windows** - Desktop application support
- ✅ **macOS** - Native desktop experience
- ✅ **Linux** - Desktop support

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter best practices
- Write clean, documented code
- Test on multiple platforms
- Never commit sensitive credentials
- Update documentation for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Rahat Kabir**
- GitHub: [@Rahat-Kabir](https://github.com/Rahat-Kabir)
- Email: rahatkabir0101@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- OpenRouter, OpenAI, and Anthropic for AI capabilities
- The open-source community

---

**NeoChat** - Where AI meets conversation 💬✨
