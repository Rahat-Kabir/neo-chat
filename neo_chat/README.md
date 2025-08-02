# NeoChat 🚀

**NeoChat** is an AI-powered chat application built with Flutter that combines real-time messaging with intelligent AI conversations. Experience the future of communication with seamless integration of multiple AI models and modern chat features.

## ✨ Features

### 🎨 Core Features
- **Splash Screen** ✅ - Customizable animated splash screen with branding
- **User Authentication** ✅ - Firebase Auth with email/password and Google Sign-In
- **AI Chat Integration** ✅ - OpenRouter API integration with DeepSeek R1 model
- **Modern Chat UI** ✅ - Material Design 3 chat interface with message bubbles
- **Real-time Chat** 🔄 - One-to-one and group messaging with Firebase
- **Settings Module** 🔄 - Profile management, themes, and AI model selection
- **Push Notifications** 🔄 - Firebase Cloud Messaging integration

### 🛠️ Technical Features
- **Material Design 3** - Modern UI with light/dark theme support
- **Responsive Design** - Optimized for all screen sizes
- **State Management** - Provider pattern for efficient state handling
- **Secure Authentication** - Firebase Auth integration
- **API Integration** - HTTP client for OpenRouter API communication
- **Error Handling** - Comprehensive error handling with retry functionality
- **Cross-platform** - iOS, Android, Web, and Desktop support

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Firebase account (for backend services)
- OpenRouter API key (for AI chat functionality)

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

3. **Configure API Keys**
   - Copy `lib/firebase_options.dart.template` to `lib/firebase_options.dart`
   - Update Firebase configuration with your project settings
   - Update OpenRouter API key in `lib/config/api_config.dart`

4. **Run the application**
   ```bash
   # For web
   flutter run -d chrome

   # For Android emulator
   flutter run -d emulator-5554

   # For Windows desktop
   flutter run -d windows
   ```

## 🧪 Testing

### Tested Platforms
- ✅ **Web (Chrome)** - Fully functional
- ✅ **Android Emulator** - Fully functional
- 🔄 **Windows Desktop** - Basic functionality
- 🔄 **iOS** - Not yet tested

### How to Test Chat Functionality
1. Launch the app on your preferred platform
2. Complete authentication (sign up or sign in)
3. Click "Start Chatting" on the home screen
4. Type a message and press send
5. Wait for AI response from OpenRouter API
6. Test error handling by disconnecting internet
7. Test retry functionality when errors occur

## 📱 Screenshots

*Screenshots will be added as features are implemented*

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point with Provider setup
├── config/                   # Configuration files
│   └── api_config.dart      # ✅ OpenRouter API configuration
├── models/                   # Data models
│   └── chat_message.dart    # ✅ Chat message model
├── providers/                # State management
│   └── chat_provider.dart   # ✅ Chat state management
├── screens/                  # UI screens
│   ├── splash_screen.dart   # ✅ Animated splash screen
│   ├── home_screen.dart     # ✅ Home screen with chat navigation
│   ├── auth/                # ✅ Authentication screens
│   └── chat/                # ✅ Chat-related screens
│       └── chat_screen.dart # ✅ Main chat interface
├── services/                 # Backend services
│   ├── auth_service.dart    # ✅ Firebase authentication
│   └── openrouter_service.dart # ✅ OpenRouter API service
├── widgets/                  # Reusable UI components
│   └── message_bubble.dart  # ✅ Chat message bubble widget
└── utils/                    # 🔄 Utility functions
```

## 🔧 Development Progress

### ✅ Completed (Phase 3)
- [x] Project setup and structure
- [x] Splash screen with animations
- [x] Material Design 3 theming
- [x] Firebase Authentication system
- [x] User registration and login screens
- [x] OpenRouter API integration
- [x] AI chat functionality with DeepSeek R1 model
- [x] Modern chat interface with message bubbles
- [x] State management with Provider pattern
- [x] Error handling and retry functionality
- [x] Cross-platform support (Web & Android tested)

### 🔄 In Progress
- [ ] Real-time messaging with Firebase Firestore
- [ ] Message persistence and history

### 📋 Planned (Phase 4+)
- [ ] Group chat functionality
- [ ] Push notifications
- [ ] Settings and profile management
- [ ] AI model selection interface
- [ ] Media sharing (images, files)
- [ ] Message encryption
- [ ] Voice messages
- [ ] Chat themes and customization

## 🤖 AI Integration

NeoChat currently supports OpenRouter API with plans for multiple AI providers:
- **OpenRouter** ✅ - Currently integrated with DeepSeek R1 model (free tier)
- **OpenAI** 🔄 - GPT models for conversational AI (planned)
- **Anthropic** 🔄 - Claude models for advanced reasoning (planned)

### Current AI Features:
- Real-time AI chat responses
- Error handling with retry functionality
- Configurable model selection
- Message history context
- Copy-to-clipboard functionality

## 🔐 Security Features

- Firebase Authentication with email/password and Google Sign-In
- Secure API key management for OpenRouter integration
- Firebase security rules (to be implemented)
- User authentication and authorization
- Input validation and sanitization
- Error handling without exposing sensitive information

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

### Current Dependencies
- `firebase_core` ✅ - Firebase initialization
- `firebase_auth` ✅ - Authentication
- `google_sign_in` ✅ - Google Sign-In integration
- `http` ✅ - API requests for AI integration
- `provider` ✅ - State management
- `nested` ✅ - Provider dependency

### Planned Dependencies
- `cloud_firestore` - Real-time database
- `firebase_messaging` - Push notifications
- `shared_preferences` - Local storage
- `image_picker` - Media sharing
- `file_picker` - File attachments

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
