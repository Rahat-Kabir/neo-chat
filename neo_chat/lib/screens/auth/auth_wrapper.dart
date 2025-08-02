import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../providers/chat_provider.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // If user is logged in, initialize chat provider and show home screen
        if (snapshot.hasData && snapshot.data != null) {
          // Initialize ChatProvider when user is authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final chatProvider = context.read<ChatProvider>();
            if (!chatProvider.isInitialized) {
              chatProvider.initialize();
            }
          });

          return const HomeScreen();
        }
        
        // If user is not logged in, show login screen
        return const LoginScreen();
      },
    );
  }
}
