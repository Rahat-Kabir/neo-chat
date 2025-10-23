# NeoChat - Flutter Application

AI-powered cross-platform chat application with real-time messaging and multi-model AI integration.

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                 # App entry point with Provider setup
├── config/                   # Configuration files
│   └── api_config.dart      # OpenRouter/OpenAI API configuration
├── models/                   # Data models
│   └── chat_message.dart    # Chat message model with Firestore serialization
├── providers/                # State management (Provider pattern)
│   └── chat_provider.dart   # Chat state and AI integration
├── screens/                  # UI screens
│   ├── splash_screen.dart   # Animated splash screen
│   ├── home_screen.dart     # Main navigation hub
│   ├── auth/                # Authentication screens
│   │   ├── auth_wrapper.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── chat/                # Chat interfaces
│       ├── chat_screen.dart
│       └── group_chat_screen.dart
├── services/                 # Backend services
│   ├── auth_service.dart    # Firebase Authentication
│   ├── firestore_service.dart # Firestore database operations
│   ├── user_service.dart    # User profile management
│   ├── openrouter_service.dart # OpenRouter API client
│   ├── openai_service.dart  # OpenAI API client
│   └── ai_service.dart      # AI service abstraction
├── widgets/                  # Reusable UI components
│   └── message_bubble.dart  # Chat message bubble widget
└── utils/                    # Utility functions
```

## 🔧 Technical Stack

### Core Technologies
- **Flutter** (>=3.8.1) - Cross-platform UI framework
- **Dart** - Programming language
- **Material Design 3** - UI design system

### State Management
- **Provider** - Reactive state management
- **Nested** - Provider dependency management

### Backend Services
- **Firebase Core** - Firebase initialization
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time database
- **Google Sign-In** - OAuth authentication

### Network & APIs
- **HTTP** - API requests for AI services
- **OpenRouter API** - Multi-model AI access
- **OpenAI API** - GPT models

## 🚀 Setup Instructions

### 1. Prerequisites
```bash
flutter doctor  # Verify Flutter installation
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase

**Copy Firebase template:**
```bash
cp lib/firebase_options.dart.template lib/firebase_options.dart
```

**Update Firebase configuration:**
- Get your Firebase config from Firebase Console
- Replace placeholder values in `firebase_options.dart`
- Configure for each platform (Android, iOS, Web)

**Setup platform-specific files:**
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Web: Firebase config in `firebase_options.dart`

See [FIREBASE_SETUP.md](../FIREBASE_SETUP.md) for detailed instructions.

### 4. Configure API Keys

**Run setup script:**
```bash
# Windows
setup_api_config.bat

# Linux/Mac
chmod +x setup_api_config.sh
./setup_api_config.sh
```

**Or manually:**
```bash
cp lib/config/api_config.dart.template lib/config/api_config.dart
```

**Edit `lib/config/api_config.dart`:**
```dart
class ApiConfig {
  static const String openRouterApiKey = 'your-actual-api-key';
  static const String openAiApiKey = 'your-actual-api-key';
  // ...
}
```

**⚠️ SECURITY WARNING:** Never commit API keys to version control!

### 5. Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### 6. Run Application

```bash
# Development
flutter run

# Specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS
flutter run -d windows     # Windows Desktop

# Release build
flutter build apk          # Android APK
flutter build ios          # iOS
flutter build web          # Web
```

## ✨ Features

### Implemented Features
- **Splash Screen** - Animated splash with branding
- **User Authentication** - Firebase Auth with email/password and Google Sign-In
- **AI Chat** - OpenRouter and OpenAI integration
- **Modern Chat UI** - Material Design 3 interface
- **Real-time Messaging** - Firebase Firestore integration
- **Group Chat** - Multi-user chat rooms
- **Message Persistence** - Chat history storage
- **Cross-platform** - iOS, Android, Web, Desktop

### AI Integration
- **OpenRouter** - DeepSeek R1 and other models
- **OpenAI** - GPT-3.5 Turbo and GPT-4
- Real-time streaming responses
- Context-aware conversations
- Multi-model selection

## 🎨 Design System

### Theme
- **Primary Color**: #6C63FF (Modern purple)
- **Material Design 3**: Dynamic color schemes
- **Dark/Light Modes**: Automatic theme switching
- **Custom Animations**: Smooth transitions

### UI Components
- Custom message bubbles
- Animated splash screen
- Responsive layouts
- Loading states and error handling

## 🔐 Security

### API Key Management
- ✅ Template-based configuration
- ✅ Gitignored sensitive files
- ✅ Environment-based setup
- ❌ Never commit real API keys

### Firestore Security Rules
```javascript
// User data isolation
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}

// Message privacy
match /chats/{userId}/messages/{messageId} {
  allow read, write: if request.auth.uid == userId;
}
```

## 🧪 Development

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable/function names
- Document public APIs
- Keep files under 300 lines when possible

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Debugging
```bash
# Enable logging
flutter run --debug

# DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  google_sign_in: ^6.2.1

  # State Management
  provider: ^6.1.1
  nested: ^1.0.0

  # Networking
  http: ^1.2.0
```

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (11+)
- ✅ Web (Chrome, Safari, Firefox, Edge)
- ✅ Windows (7+)
- ✅ macOS (10.14+)
- ✅ Linux

## 🔨 Build & Deployment

### Android
```bash
flutter build apk --release              # Release APK
flutter build appbundle --release        # Play Store Bundle
```

### iOS
```bash
flutter build ios --release              # Release build
```

### Web
```bash
flutter build web --release              # Web build
firebase deploy --only hosting           # Deploy to Firebase
```

### Desktop
```bash
flutter build windows --release          # Windows
flutter build macos --release            # macOS
flutter build linux --release            # Linux
```

## 🐛 Troubleshooting

### Common Issues

**Firebase initialization error:**
- Verify `firebase_options.dart` configuration
- Check platform-specific config files
- Run `flutterfire configure`

**API connection errors:**
- Verify API keys in `api_config.dart`
- Check network connectivity
- Verify API quotas

**Build errors:**
- Run `flutter clean`
- Run `flutter pub get`
- Check Flutter version compatibility

## 📚 Additional Documentation

- [Firebase Setup Guide](../FIREBASE_SETUP.md)
- [Firestore Security Rules](../firestore.rules)
- [Main Project README](../README.md)

## 🤝 Contributing

1. Follow the existing code structure
2. Write tests for new features
3. Update documentation
4. Keep commits atomic and descriptive
5. Never commit sensitive data

---

**Built with Flutter** 💙
