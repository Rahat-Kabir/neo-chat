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

### 3. Enable Firestore Database
1. In your Firebase project, go to **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" (we'll update rules later)
4. Select a location for your database (choose closest to your users)
5. Click "Done"

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
**IMPORTANT**: Update your Firestore security rules to secure user data.

1. Go to **Firestore Database** > **Rules** in Firebase Console
2. Replace the default rules with the content from `firestore.rules` file:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read and write their own user profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Chat conversations - users can only access their own chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && request.auth.uid == chatId;

      // Messages within a chat - users can only access messages in their own chats
      match /messages/{messageId} {
        allow read, write: if request.auth != null && request.auth.uid == chatId;
      }
    }

    // User settings and preferences
    match /userSettings/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Chat metadata and statistics
    match /chatMetadata/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. Click **Publish** to apply the rules

> **Note**: These rules ensure that users can only access their own data. Each user's chat messages are stored in a subcollection under their user ID, providing complete data isolation.

## 🆘 Troubleshooting

### Common Issues

1. **"FirebaseOptions cannot be null"**
   - Update `firebase_options.dart` with actual Firebase config values

2. **Google Sign-In not working**
   - Ensure SHA-1 key is added to Firebase Console
   - Check that Google Sign-In is enabled in Firebase Auth

3. **Build errors on Android**
   - Ensure `google-services.json` is in the correct location

4. **Web authentication issues**
   - Verify Firebase config in `firebase_options.dart`

---

**Firebase Setup Complete** 🚀
