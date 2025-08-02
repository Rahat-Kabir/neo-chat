# Firebase Setup Guide for NeoChat

This guide will help you set up Firebase Authentication for the NeoChat application.

## 🔥 Firebase Project Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `neochat` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

### 2. Enable Authentication
1. In your Firebase project, go to **Authentication** > **Sign-in method**
2. Enable the following sign-in providers:
   - **Email/Password**: Click and toggle "Enable"
   - **Google**: Click, toggle "Enable", and add your project support email

## 📱 Platform Configuration

### Android Setup

#### 1. Add Android App
1. In Firebase Console, click "Add app" and select Android
2. Enter package name: `com.example.neo_chat`
3. Enter app nickname: `NeoChat Android`
4. Download `google-services.json`
5. Place the file in `neo_chat/android/app/google-services.json` ✅ (Already done)

#### 2. Generate SHA-1 Key
You need to add SHA-1 fingerprints to Firebase for Google Sign-In to work.

**Method 1: Using Gradle (Recommended)**
```bash
cd neo_chat/android
./gradlew signingReport
```

**Method 2: Using keytool**
```bash
# For debug keystore (development)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Method 3: Using Flutter**
```bash
cd neo_chat
flutter build apk --debug
# Then check the build output for SHA-1 key
```

#### 3. Add SHA-1 to Firebase
1. Copy the SHA-1 fingerprint from the output
2. In Firebase Console, go to **Project Settings** > **Your apps** > **Android app**
3. Click "Add fingerprint"
4. Paste the SHA-1 key
5. Click "Save"

### Web Setup

#### 1. Add Web App
1. In Firebase Console, click "Add app" and select Web
2. Enter app nickname: `NeoChat Web`
3. Enable Firebase Hosting (optional)
4. Copy the Firebase configuration object

#### 2. Update Firebase Options
**IMPORTANT**: The `firebase_options.dart` file is now gitignored for security.

1. Copy the template file:
   ```bash
   cp neo_chat/lib/firebase_options.dart.template neo_chat/lib/firebase_options.dart
   ```

2. Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase config:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'your-actual-web-api-key',
     appId: 'your-actual-web-app-id',
     messagingSenderId: 'your-actual-sender-id',
     projectId: 'your-actual-project-id',
     authDomain: 'your-project-id.firebaseapp.com',
     storageBucket: 'your-project-id.appspot.com',
   );
   ```

3. **Never commit this file to git** - it contains sensitive API keys!

### iOS Setup (Future)

#### 1. Add iOS App
1. In Firebase Console, click "Add app" and select iOS
2. Enter bundle ID: `com.example.neo_chat`
3. Enter app nickname: `NeoChat iOS`
4. Download `GoogleService-Info.plist`
5. Add the file to `neo_chat/ios/Runner/GoogleService-Info.plist`

## 🔧 Current Implementation Status

### ✅ Completed Features
- [x] Firebase Core integration
- [x] Email/Password authentication
- [x] User registration
- [x] User login
- [x] Password reset
- [x] Google Sign-In (Web)
- [x] Authentication state management
- [x] Sign out functionality
- [x] Form validation
- [x] Error handling
- [x] Loading states
- [x] Responsive UI design

### 🔄 Authentication Screens
- [x] **Login Screen**: Email/password login with Google Sign-In option
- [x] **Register Screen**: User registration with email/password
- [x] **Forgot Password Screen**: Password reset functionality
- [x] **Auth Wrapper**: Handles authentication state changes
- [x] **Home Screen**: Shows user info and sign-out option

### 🎨 UI Features
- [x] Material Design 3 theming
- [x] Gradient backgrounds
- [x] Smooth animations
- [x] Form validation with error messages
- [x] Loading indicators
- [x] Responsive design
- [x] User profile display

## 🚀 Testing the Authentication

### 1. Run the Application
```bash
cd neo_chat
flutter run
```

### 2. Test Email/Password Authentication
1. Click "Sign Up" to create a new account
2. Enter email and password
3. Click "Create Account"
4. Try logging in with the created credentials

### 3. Test Google Sign-In (Web Only)
1. Click "Continue with Google"
2. Complete Google authentication flow
3. Verify user is signed in

### 4. Test Password Reset
1. Click "Forgot Password?"
2. Enter your email
3. Check your email for reset link

## 🔐 Security Configuration

### ⚠️ CRITICAL: API Key Security
**NEVER commit Firebase configuration files to public repositories!**

The following files contain sensitive API keys and are now gitignored:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

### API Key Management
1. **Keep API keys private**: Never share or commit them to version control
2. **Use environment variables**: For production, consider using environment variables
3. **Rotate keys regularly**: Generate new keys periodically for security
4. **Monitor usage**: Check Firebase Console for unusual API usage

### Firebase Security Rules
Update your Firestore security rules (when implementing chat):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Chat messages (implement later)
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📝 Next Steps

1. **Complete Firebase Configuration**:
   - Add your actual Firebase config values to `firebase_options.dart`
   - Generate and add SHA-1 key to Firebase Console

2. **Test Authentication**:
   - Test email/password registration and login
   - Test Google Sign-In (after adding SHA-1)
   - Test password reset functionality

3. **Implement Chat Features**:
   - Set up Firestore for real-time messaging
   - Create chat interface
   - Add AI integration

## 🆘 Troubleshooting

### Common Issues

1. **"FirebaseOptions cannot be null"**
   - Update `firebase_options.dart` with actual Firebase config values

2. **Google Sign-In not working**
   - Ensure SHA-1 key is added to Firebase Console
   - Check that Google Sign-In is enabled in Firebase Auth

3. **Build errors on Android**
   - Ensure `google-services.json` is in the correct location
   - Check that Google Services plugin is properly configured

4. **Web authentication issues**
   - Verify Firebase config in `firebase_options.dart`
   - Check browser console for detailed error messages

## 📞 Support

If you encounter any issues:
1. Check the Firebase Console for error logs
2. Review the Flutter debug console output
3. Ensure all configuration files are properly set up
4. Verify that authentication providers are enabled in Firebase

---

**Ready to continue with chat implementation once authentication is fully configured!** 🚀
