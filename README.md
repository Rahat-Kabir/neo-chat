# NeoChat 🚀

**NeoChat** is an AI-powered chat application built with Flutter that combines real-time messaging with intelligent AI conversations. Experience the future of communication with seamless integration of multiple AI models and modern chat features.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

## ✨ Features

### 🎨 Core Features
- **Splash Screen** ✅ - Customizable animated splash screen with branding
- **User Authentication** ✅ - Firebase Auth with email/password and Google Sign-In
- **AI Chat Interface** ✅ - Modern chat UI with AI conversation support
- **Real-time Messaging** ✅ - Firebase Firestore integration with message persistence
- **AI Integration** ✅ - OpenRouter API with DeepSeek R1 model support
- **Settings Module** 🔄 - Profile management, themes, and AI model selection
- **Push Notifications** 🔄 - Firebase Cloud Messaging integration

### 🛠️ Technical Features
- **Material Design 3** - Modern UI with light/dark theme support
- **Responsive Design** - Optimized for all screen sizes
- **Cross-platform** - iOS, Android, Web, and Desktop support
- **Secure Authentication** - Firebase Auth integration
- **Real-time Database** - Firebase Firestore for message persistence
- **Provider State Management** - Efficient state management with Provider pattern
- **Error Handling** - Comprehensive error handling and user feedback

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
│   │   ├── main.dart        # ✅ App entry point with Firebase
│   │   ├── firebase_options.dart  # ✅ Firebase configuration
│   │   ├── config/          # ✅ Configuration files
│   │   │   └── api_config.dart    # ✅ API configuration
│   │   ├── models/          # ✅ Data models
│   │   │   └── chat_message.dart  # ✅ Chat message model
│   │   ├── providers/       # ✅ State management
│   │   │   └── chat_provider.dart # ✅ Chat state provider
│   │   ├── screens/         # UI screens
│   │   │   ├── splash_screen.dart     # ✅ Animated splash screen
│   │   │   ├── home_screen.dart       # ✅ Chat interface
│   │   │   └── auth/                  # ✅ Authentication screens
│   │   │       ├── auth_wrapper.dart      # ✅ Auth state management
│   │   │       ├── login_screen.dart      # ✅ Login interface
│   │   │       ├── register_screen.dart   # ✅ Registration interface
│   │   │       └── forgot_password_screen.dart # ✅ Password reset
│   │   └── services/        # Business logic
│   │       ├── auth_service.dart      # ✅ Firebase Auth service
│   │       ├── firestore_service.dart # ✅ Firestore database service
│   │       ├── openrouter_service.dart # ✅ AI API service
│   │       └── user_service.dart      # ✅ User management service
│   ├── assets/              # ✅ App assets
│   │   └── images/          # ✅ UI images
│   ├── pubspec.yaml         # ✅ Dependencies with Firebase
│   └── android/app/google-services.json  # ✅ Firebase config
├── FIREBASE_SETUP.md        # ✅ Firebase setup guide
├── FIRESTORE_IMPLEMENTATION.md # ✅ Firestore setup guide
├── firestore.rules          # ✅ Firestore security rules
├── requirements.md          # ✅ Project requirements
├── LICENSE                  # ✅ MIT License
└── README.md               # ✅ This file
```

## 🔧 Development Progress

### ✅ Phase 1: Foundation (Completed)
- [x] Project setup and structure
- [x] Flutter app initialization
- [x] Material Design 3 theming (light/dark mode)
- [x] Animated splash screen with branding
- [x] Basic navigation structure
- [x] Git repository setup
- [x] Documentation and README

### ✅ Phase 2: Authentication (Completed)
- [x] Firebase project setup and configuration
- [x] Firebase Authentication integration
- [x] User registration screen with validation
- [x] Login screen with email/password
- [x] Google Sign-In integration (Web ready)
- [x] Password reset functionality
- [x] Authentication state management
- [x] Auth wrapper for route protection
- [x] Comprehensive error handling
- [x] Loading states and UI feedback
- [x] Responsive authentication UI

### ✅ Phase 3: Chat System (Completed)
- [x] Firebase Firestore setup and configuration
- [x] Modern chat interface design with Material Design 3
- [x] Real-time AI conversation support
- [x] Message history and persistence
- [x] Chat message models and data structures
- [x] Provider-based state management
- [x] Message status and error handling

### ✅ Phase 4: AI Integration (Completed)
- [x] OpenRouter API integration
- [x] DeepSeek R1 model implementation
- [x] Streaming responses support
- [x] Context management for conversations
- [x] API configuration and key management
- [x] Comprehensive error handling for AI responses
- [x] Cross-platform support (Web & Android tested)

### 🔄 Phase 5: Advanced Features (Next)
- [ ] Multi-user chat rooms and group messaging
- [ ] Push notifications (FCM)
- [ ] Settings and profile management
- [ ] Multiple AI model selection (OpenAI, Anthropic)
- [ ] Media sharing and file uploads
- [ ] Message encryption
- [ ] Advanced theme customization
- [ ] Typing indicators and presence status

## 🎨 Design System

- **Primary Color**: #6C63FF (Modern purple)
- **Material Design 3** components
- **Responsive layouts** for all devices
- **Dark/Light theme** support
- **Smooth animations** and transitions

## 🤖 AI Integration

NeoChat currently supports and will expand to include:
- **OpenRouter** ✅ - Currently integrated with DeepSeek R1 model
- **OpenAI** 🔄 - GPT models for conversational AI (planned)
- **Anthropic** 🔄 - Claude models for advanced reasoning (planned)

### Current AI Features:
- Real-time AI conversations with DeepSeek R1
- Context-aware responses
- Streaming response support
- Error handling and retry mechanisms
- Cross-platform compatibility

## 🔐 Security Features

- Firebase Authentication
- Secure API key management
- Firebase security rules
- User data protection

## 📱 Screenshots

*Screenshots will be added as features are implemented*

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
- Email: rahatkabir0101@gmail.com
- GitHub: [@Rahat-Kabir](https://github.com/Rahat-Kabir)

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact: rahatkabir0101@gmail.com

---

**NeoChat** - Where AI meets conversation 💬✨

*Built with ❤️ using Flutter*
