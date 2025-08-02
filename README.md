# NeoChat 🚀

**NeoChat** is an AI-powered chat application built with Flutter that combines real-time messaging with intelligent AI conversations. Experience the future of communication with seamless integration of multiple AI models and modern chat features.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

## ✨ Features

- **User Authentication** - Secure Firebase Auth with email/password and Google Sign-In
- **AI Chat Interface** - Modern chat UI with AI conversation support
- **Real-time Messaging** - Firebase Firestore integration with message persistence
- **Public Chat Rooms** - Multi-user chat rooms with real-time messaging
- **AI Integration** - OpenRouter API with DeepSeek R1 model support
- **Material Design 3** - Modern UI with light/dark theme support
- **Cross-platform Support** - iOS, Android, Web, and Desktop compatibility
- **Responsive Design** - Optimized for all screen sizes
- **Secure Data Storage** - Firebase Firestore with comprehensive security rules
- **Real-time Synchronization** - Instant message delivery and chat history

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Firebase account (for backend services)

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

3. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
neo-chat/
├── neo_chat/                # Flutter application
│   ├── lib/
│   │   ├── main.dart        # App entry point with Firebase
│   │   ├── firebase_options.dart  # Firebase configuration
│   │   ├── config/          # Configuration files
│   │   ├── models/          # Data models
│   │   ├── providers/       # State management
│   │   ├── screens/         # UI screens
│   │   │   ├── splash_screen.dart     # Animated splash screen
│   │   │   ├── home_screen.dart       # Main interface
│   │   │   ├── auth/                  # Authentication screens
│   │   │   └── chat/                  # Chat screens
│   │   └── services/        # Business logic
│   │       ├── auth_service.dart      # Firebase Auth service
│   │       ├── firestore_service.dart # Firestore database service
│   │       └── openrouter_service.dart # AI API service
│   ├── assets/              # App assets
│   └── pubspec.yaml         # Dependencies
├── FIREBASE_SETUP.md        # Firebase setup guide
├── firestore.rules          # Firestore security rules
├── LICENSE                  # MIT License
└── README.md               # This file
```

## 🤖 AI Integration

- **OpenRouter API** - Integrated with DeepSeek R1 model for intelligent conversations
- **Real-time AI Chat** - Context-aware responses with streaming support
- **Cross-platform Compatibility** - Works seamlessly across all platforms

## 🔐 Security & Privacy

- **Firebase Authentication** - Secure user authentication and authorization
- **Data Protection** - Comprehensive Firestore security rules
- **API Key Management** - Secure handling of sensitive credentials
- **User Privacy** - Individual chat isolation and data protection

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Rahat Kabir**
- GitHub: [@Rahat-Kabir](https://github.com/Rahat-Kabir)
- Email: rahatkabir0101@gmail.com

---

**NeoChat** - Where AI meets conversation 💬✨
