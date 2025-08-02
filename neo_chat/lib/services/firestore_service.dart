import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // User profile methods
  Future<void> createUserProfile({
    required String userId,
    required String email,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'displayName': displayName ?? email.split('@')[0],
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
        'messageCount': 0,
        'preferredModel': 'deepseek/deepseek-r1-0528:free',
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        ...data,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Message methods
  Future<void> saveMessage(ChatMessage message) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      // Save the message
      await _firestore
          .collection('chats')
          .doc(currentUserId)
          .collection('messages')
          .doc(message.id)
          .set(message.toFirestore());

      // Update user's message count - use set with merge to create document if it doesn't exist
      await _firestore.collection('users').doc(currentUserId).set({
        'messageCount': FieldValue.increment(1),
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  // Get messages stream for real-time updates
  Stream<List<ChatMessage>> getMessagesStream() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('chats')
        .doc(currentUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // Get messages with pagination
  Future<List<ChatMessage>> getMessages({
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    if (currentUserId == null) return [];

    try {
      Query query = _firestore
          .collection('chats')
          .doc(currentUserId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  // Delete a message
  Future<void> deleteMessage(String messageId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('chats')
          .doc(currentUserId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  // Clear all messages for current user
  Future<void> clearAllMessages() async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      final batch = _firestore.batch();
      final messages = await _firestore
          .collection('chats')
          .doc(currentUserId)
          .collection('messages')
          .get();

      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // Reset user's message count - use set with merge to create document if it doesn't exist
      await _firestore.collection('users').doc(currentUserId).set({
        'messageCount': 0,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to clear messages: $e');
    }
  }

  // Get chat statistics
  Future<Map<String, dynamic>> getChatStats() async {
    if (currentUserId == null) return {};

    try {
      final userDoc = await _firestore.collection('users').doc(currentUserId).get();
      final userData = userDoc.data() ?? {};

      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(currentUserId)
          .collection('messages')
          .get();

      final userMessages = messagesSnapshot.docs
          .where((doc) => doc.data()['type'] == 'user')
          .length;
      
      final aiMessages = messagesSnapshot.docs
          .where((doc) => doc.data()['type'] == 'assistant')
          .length;

      return {
        'totalMessages': messagesSnapshot.docs.length,
        'userMessages': userMessages,
        'aiMessages': aiMessages,
        'joinedAt': userData['createdAt'],
        'lastActive': userData['lastActive'],
        'preferredModel': userData['preferredModel'] ?? 'deepseek/deepseek-r1-0528:free',
      };
    } catch (e) {
      throw Exception('Failed to get chat stats: $e');
    }
  }

  // Update user's preferred AI model
  Future<void> updatePreferredModel(String model) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      await _firestore.collection('users').doc(currentUserId).set({
        'preferredModel': model,
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update preferred model: $e');
    }
  }
}
