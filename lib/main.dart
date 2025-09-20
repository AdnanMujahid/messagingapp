
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chatScreen.dart';
import 'firebase_options.dart';
import 'logibscreen.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before calling Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// AuthGate determines which screen to show based on the user's auth state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show a loading spinner while checking the auth state.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If a user is logged in, show the ChatScreen.
        if (snapshot.hasData) {
          return const ChatScreen();
        }

        // Otherwise, show the LoginScreen.
        return const LoginScreen();
      },
    );
  }
}
