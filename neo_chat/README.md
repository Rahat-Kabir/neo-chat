# NeoChat 🚀

**NeoChat** is an AI-powered chat application built with Flutter that combines real-time messaging with intelligent AI conversations. Experience the future of communication with seamless integration of multiple AI models and modern chat features.

## ✨ Features

### 🎨 Core Features
- **Splash Screen** ✅ - Customizable animated splash screen with branding
- **User Authentication** 🔄 - Firebase Auth with email/password and Google Sign-In
- **Real-time Chat** 🔄 - One-to-one and group messaging with Firebase
- **AI Integration** 🔄 - Support for OpenRouter, OpenAI, and Anthropic APIs
- **Settings Module** 🔄 - Profile management, themes, and AI model selection
- **Push Notifications** 🔄 - Firebase Cloud Messaging integration

### 🛠️ Technical Features
- **Material Design 3** - Modern UI with light/dark theme support
- **Responsive Design** - Optimized for all screen sizes
- **State Management** - Efficient state handling
- **Secure Authentication** - Firebase Auth integration
- **Real-time Database** - Firebase Firestore for instant messaging
- **Cross-platform** - iOS, Android, Web, and Desktop support

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Firebase account (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd NeoChat/neo_chat
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Screenshots

*Screenshots will be added as features are implemented*

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # UI screens
│   ├── splash_screen.dart   # ✅ Animated splash screen
│   ├── home_screen.dart     # ✅ Temporary home screen
│   ├── auth/                # 🔄 Authentication screens
│   ├── chat/                # 🔄 Chat-related screens
│   └── settings/            # 🔄 Settings screens
├── widgets/                 # 🔄 Reusable UI components
├── services/                # 🔄 Backend services
├── models/                  # 🔄 Data models
└── utils/                   # 🔄 Utility functions
```

## 🔧 Development Progress

### ✅ Completed
- [x] Project setup and structure
- [x] Splash screen with animations
- [x] Material Design 3 theming
- [x] Basic navigation structure

### 🔄 In Progress
- [ ] Firebase Authentication setup
- [ ] User registration and login screens
- [ ] Chat interface design
- [ ] AI integration setup

### 📋 Planned
- [ ] Real-time messaging
- [ ] Group chat functionality
- [ ] Push notifications
- [ ] Settings and profile management
- [ ] AI model selection
- [ ] Media sharing
- [ ] Message encryption

## 🤖 AI Integration

NeoChat will support multiple AI providers:
- **OpenAI** - GPT models for conversational AI
- **Anthropic** - Claude models for advanced reasoning
- **OpenRouter** - Access to multiple AI models through one API

## 🔐 Security Features

- End-to-end encryption for messages
- Secure API key management
- Firebase security rules
- User authentication and authorization

## 🎨 Design System

- **Primary Color**: #6C63FF (Modern purple)
- **Material Design 3** components
- **Responsive layouts** for all devices
- **Dark/Light theme** support
- **Smooth animations** and transitions

## 📚 Dependencies

### Core Dependencies
- `flutter` - UI framework
- `cupertino_icons` - iOS-style icons

### Planned Dependencies
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Real-time database
- `firebase_messaging` - Push notifications
- `http` - API requests for AI integration
- `shared_preferences` - Local storage
- `provider` - State management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact the development team

---

**NeoChat** - Where AI meets conversation 💬✨
