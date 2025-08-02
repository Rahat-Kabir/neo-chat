import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class UserService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize user profile when they first sign in
  Future<void> initializeUserProfile(User user) async {
    try {
      // Check if user profile already exists
      final existingProfile = await _firestoreService.getUserProfile(user.uid);
      
      if (existingProfile == null) {
        // Create new user profile
        await _firestoreService.createUserProfile(
          userId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoURL: user.photoURL,
        );
      } else {
        // Update last active timestamp
        await _firestoreService.updateUserProfile(user.uid, {
          'lastActive': DateTime.now(),
        });
      }
    } catch (e) {
      throw Exception('Failed to initialize user profile: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final updates = <String, dynamic>{};
      
      if (displayName != null) {
        updates['displayName'] = displayName;
        await user.updateDisplayName(displayName);
      }
      
      if (photoURL != null) {
        updates['photoURL'] = photoURL;
        await user.updatePhotoURL(photoURL);
      }

      if (updates.isNotEmpty) {
        await _firestoreService.updateUserProfile(user.uid, updates);
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      return await _firestoreService.getUserProfile(user.uid);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Delete user account and all associated data
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // Clear all user data from Firestore
      await _firestoreService.clearAllMessages();
      
      // Delete user profile
      // Note: This would need additional implementation to delete user document
      
      // Delete Firebase Auth account
      await user.delete();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
