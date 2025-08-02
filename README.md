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
- **Real-time Chat** 🔄 - One-to-one and group messaging with Firebase
- **AI Integration** 🔄 - Support for OpenRouter, OpenAI, and Anthropic APIs
- **Settings Module** 🔄 - Profile management, themes, and AI model selection
- **Push Notifications** 🔄 - Firebase Cloud Messaging integration

### 🛠️ Technical Features
- **Material Design 3** - Modern UI with light/dark theme support
- **Responsive Design** - Optimized for all screen sizes
- **Cross-platform** - iOS, Android, Web, and Desktop support
- **Secure Authentication** - Firebase Auth integration
- **Real-time Database** - Firebase Firestore for instant messaging

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
│   │   ├── screens/         # UI screens
│   │   │   ├── splash_screen.dart     # ✅ Animated splash screen
│   │   │   ├── home_screen.dart       # ✅ User dashboard
│   │   │   └── auth/                  # ✅ Authentication screens
│   │   │       ├── auth_wrapper.dart      # ✅ Auth state management
│   │   │       ├── login_screen.dart      # ✅ Login interface
│   │   │       ├── register_screen.dart   # ✅ Registration interface
│   │   │       └── forgot_password_screen.dart # ✅ Password reset
│   │   └── services/        # Business logic
│   │       └── auth_service.dart      # ✅ Firebase Auth service
│   ├── assets/              # ✅ App assets
│   │   └── images/          # ✅ UI images
│   ├── pubspec.yaml         # ✅ Dependencies with Firebase
│   └── android/app/google-services.json  # ✅ Firebase config
├── FIREBASE_SETUP.md        # ✅ Firebase setup guide
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

### 🔄 Phase 3: Chat System (Next)
- [ ] Firebase Firestore setup
- [ ] Chat interface design
- [ ] Real-time messaging
- [ ] Message history
- [ ] Group chat functionality
- [ ] Typing indicators
- [ ] Message status (sent/delivered/read)

### 🤖 Phase 4: AI Integration (Planned)
- [ ] OpenAI API integration
- [ ] Anthropic Claude integration
- [ ] OpenRouter API setup
- [ ] Streaming responses
- [ ] Context management
- [ ] AI model selection

### ⚙️ Phase 5: Advanced Features (Planned)
- [ ] Push notifications (FCM)
- [ ] Settings and profile management
- [ ] Media sharing
- [ ] Message encryption
- [ ] Theme customization

## 🎨 Design System

- **Primary Color**: #6C63FF (Modern purple)
- **Material Design 3** components
- **Responsive layouts** for all devices
- **Dark/Light theme** support
- **Smooth animations** and transitions

## 🤖 AI Integration

NeoChat will support multiple AI providers:
- **OpenAI** - GPT models for conversational AI
- **Anthropic** - Claude models for advanced reasoning
- **OpenRouter** - Access to multiple AI models through one API

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
