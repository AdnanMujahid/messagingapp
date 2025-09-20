# Real-Time Chat App

A modern, feature-rich real-time messaging application built with Flutter and Firebase. This app provides a complete messaging solution with user authentication, real-time chat, group messaging, image sharing, and push notifications.

## 🚀 Features

### Core Features
- ✅ **User Authentication** - Secure login/signup with Firebase Auth
- ✅ **Real-Time Messaging** - Instant message delivery using Firestore
- ✅ **Chat History** - Persistent message storage and retrieval
- ✅ **Online/Offline Status** - Real-time user presence indicators
- ✅ **Group Chat Support** - Create and manage group conversations
- ✅ **Image Sharing** - Send and receive images with Firebase Storage
- ✅ **Message Search** - Find specific messages across all chats
- ✅ **Push Notifications** - Get notified of new messages
- ✅ **Emoji Support** - Rich emoji picker for expressive messaging
- ✅ **Modern UI/UX** - Beautiful, responsive Material Design 3 interface

### Technical Features
- **Cross-Platform** - Works on iOS, Android, Web, and Desktop
- **Real-Time Sync** - Messages sync instantly across all devices
- **Offline Support** - Messages are cached for offline viewing
- **Image Optimization** - Automatic image compression and caching
- **State Management** - Clean architecture with Provider pattern
- **Error Handling** - Comprehensive error handling and user feedback
- **Security** - Firebase security rules and data validation

## 📱 Screenshots

The app features a modern, intuitive interface with:
- Clean authentication screens with gradient buttons
- Beautiful chat interface with message bubbles
- User-friendly home screen with chat and user lists
- Advanced search functionality
- Group chat management
- Real-time status indicators

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.9.0+
- **Backend**: Firebase
  - Authentication
  - Firestore Database
  - Cloud Storage
  - Cloud Messaging
- **State Management**: Provider
- **UI**: Material Design 3
- **Additional Packages**:
  - `image_picker` - Image selection
  - `cached_network_image` - Image caching
  - `emoji_picker_flutter` - Emoji support
  - `shimmer` - Loading animations
  - `permission_handler` - Permission management
  - `flutter_local_notifications` - Local notifications

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase project
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/messaging_app.git
   cd messaging_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   a. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   
   b. Enable the following services:
      - Authentication (Email/Password)
      - Firestore Database
      - Cloud Storage
      - Cloud Messaging
   
   c. Download configuration files:
      - `google-services.json` for Android (place in `android/app/`)
      - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
   
   d. Update `lib/firebase_options.dart` with your Firebase configuration

4. **Configure Firestore Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can read/write their own user document
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Users can read/write chats they participate in
       match /chats/{chatId} {
         allow read, write: if request.auth != null && 
           request.auth.uid in resource.data.participants;
       }
       
       // Users can read/write messages in chats they participate in
       match /messages/{messageId} {
         allow read, write: if request.auth != null && 
           request.auth.uid in get(/databases/$(database)/documents/chats/$(resource.data.chatId)).data.participants;
       }
     }
   }
   ```

5. **Configure Storage Rules**
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /chat_images/{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Platform-Specific Setup

### Android
1. Add the following permissions to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
   ```

2. Ensure `google-services.json` is in `android/app/`

### iOS
1. Add the following to `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs access to camera to take photos</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs access to photo library to select images</string>
   ```

2. Ensure `GoogleService-Info.plist` is in `ios/Runner/`

## 🎯 Usage

### Creating an Account
1. Launch the app
2. Tap "Sign Up" on the login screen
3. Enter username, email, and password
4. Tap "Sign Up" to create your account

### Starting a Chat
1. Go to the "Users" tab
2. Tap on any user to start a conversation
3. Type your message and tap send

### Creating a Group
1. Tap the "+" button on the home screen
2. Enter a group name
3. Select members from the user list
4. Tap "Create Group"

### Searching Messages
1. Tap the search icon in the app bar
2. Enter your search query
3. Tap on any result to open the chat

## 🔧 Configuration

### Firebase Configuration
Update `lib/firebase_options.dart` with your Firebase project settings:

```dart
static const FirebaseOptions currentPlatform = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  // ... other platform-specific settings
);
```

### Notification Setup
For push notifications to work properly:

1. **Android**: Add your FCM server key to Firebase Console
2. **iOS**: Upload your APNs certificate to Firebase Console
3. **Web**: Add your web push certificate

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

### Manual Testing Checklist
- [ ] User registration and login
- [ ] Sending and receiving messages
- [ ] Image sharing functionality
- [ ] Group chat creation and messaging
- [ ] Search functionality
- [ ] Push notifications
- [ ] Offline/online status updates
- [ ] App state management

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the robust backend services
- Material Design team for the design system
- Open source community for the helpful packages

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/messaging_app/issues) page
2. Create a new issue with detailed information
3. Contact the development team

## 🎥 Demo

Watch the app demo following the [Demo Script](DEMO_SCRIPT.md) for a comprehensive walkthrough of all features.

---

**Built with ❤️ using Flutter and Firebase**
