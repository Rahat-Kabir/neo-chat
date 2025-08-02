import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/public_chat_message.dart';

class PublicChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Hardcoded public room ID
  static const String publicRoomId = 'general-public-room';

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get current user info
  User? get currentUser => _auth.currentUser;

  // Save a message to the public room
  Future<void> saveMessage(PublicChatMessage message) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .collection('messages')
          .doc(message.id)
          .set(message.toFirestore());

      // Update room metadata
      await _updateRoomMetadata();
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  // Get messages stream for real-time updates
  Stream<List<PublicChatMessage>> getMessagesStream() {
    return _firestore
        .collection('publicRooms')
        .doc(publicRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PublicChatMessage.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // Get recent messages for AI context (last N messages)
  Future<List<PublicChatMessage>> getRecentMessages({int limit = 5}) async {
    try {
      final snapshot = await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => PublicChatMessage.fromFirestore(doc.data(), doc.id))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent messages: $e');
    }
  }

  // Delete a message (only by the sender or admin)
  Future<void> deleteMessage(String messageId, String messageUserId) async {
    if (currentUserId == null) throw Exception('User not authenticated');
    
    // Only allow deletion by the message sender
    if (currentUserId != messageUserId) {
      throw Exception('You can only delete your own messages');
    }

    try {
      await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  // Check if message mentions AI
  bool messageTriggersAI(String content) {
    final lowerContent = content.toLowerCase();
    return lowerContent.contains('@ai') || 
           lowerContent.contains('@assistant') ||
           lowerContent.contains('hey ai') ||
           lowerContent.contains('hi ai');
  }

  // Get user messages for AI context (exclude AI messages and loading messages)
  List<PublicChatMessage> getContextMessages(List<PublicChatMessage> messages, {int limit = 5}) {
    return messages
        .where((msg) => msg.type == PublicMessageType.user && !msg.isLoading)
        .take(limit)
        .toList();
  }

  // Create user message from current user
  PublicChatMessage createUserMessage(String content) {
    final user = currentUser;
    if (user == null) throw Exception('User not authenticated');

    return PublicChatMessage.user(
      content: content,
      userId: user.uid,
      displayName: user.displayName ?? user.email?.split('@')[0] ?? 'User',
      photoURL: user.photoURL,
      email: user.email,
    );
  }

  // Update room metadata (last activity, message count, etc.)
  Future<void> _updateRoomMetadata() async {
    try {
      await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .set({
        'lastActivity': FieldValue.serverTimestamp(),
        'messageCount': FieldValue.increment(1),
        'roomName': 'General Chat',
        'description': 'Public chat room for all users',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Don't throw error for metadata updates
      print('Failed to update room metadata: $e');
    }
  }

  // Initialize public room (create if doesn't exist)
  Future<void> initializePublicRoom() async {
    try {
      final roomDoc = await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .get();

      if (!roomDoc.exists) {
        await _firestore
            .collection('publicRooms')
            .doc(publicRoomId)
            .set({
          'roomName': 'General Chat',
          'description': 'Public chat room for all users',
          'createdAt': FieldValue.serverTimestamp(),
          'lastActivity': FieldValue.serverTimestamp(),
          'messageCount': 0,
          'isActive': true,
        });
      }
    } catch (e) {
      throw Exception('Failed to initialize public room: $e');
    }
  }

  // Get room info
  Future<Map<String, dynamic>?> getRoomInfo() async {
    try {
      final doc = await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .get();
      
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Failed to get room info: $e');
    }
  }

  // Get room statistics
  Future<Map<String, dynamic>> getRoomStats() async {
    try {
      final messagesSnapshot = await _firestore
          .collection('publicRooms')
          .doc(publicRoomId)
          .collection('messages')
          .get();

      final userMessages = messagesSnapshot.docs
          .where((doc) => doc.data()['type'] == 'user')
          .length;
      
      final aiMessages = messagesSnapshot.docs
          .where((doc) => doc.data()['type'] == 'assistant')
          .length;

      final uniqueUsers = messagesSnapshot.docs
          .where((doc) => doc.data()['type'] == 'user')
          .map((doc) => doc.data()['userId'])
          .toSet()
          .length;

      return {
        'totalMessages': messagesSnapshot.docs.length,
        'userMessages': userMessages,
        'aiMessages': aiMessages,
        'uniqueUsers': uniqueUsers,
      };
    } catch (e) {
      throw Exception('Failed to get room stats: $e');
    }
  }
}
