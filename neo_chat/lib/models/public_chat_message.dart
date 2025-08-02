enum PublicMessageType {
  user,
  assistant,
  system,
}

class PublicChatMessage {
  final String id;
  final String content;
  final PublicMessageType type;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;
  
  // User information for public chat
  final String userId;
  final String displayName;
  final String? photoURL;
  final String? email;

  PublicChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.userId,
    required this.displayName,
    this.photoURL,
    this.email,
    DateTime? timestamp,
    this.isLoading = false,
    this.error,
  }) : timestamp = timestamp ?? DateTime.now();

  // Create a user message
  factory PublicChatMessage.user({
    required String content,
    required String userId,
    required String displayName,
    String? photoURL,
    String? email,
    String? id,
  }) {
    return PublicChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: PublicMessageType.user,
      userId: userId,
      displayName: displayName,
      photoURL: photoURL,
      email: email,
    );
  }

  // Create an assistant message
  factory PublicChatMessage.assistant({
    required String content,
    String? id,
    String? error,
  }) {
    return PublicChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: PublicMessageType.assistant,
      userId: 'ai-assistant',
      displayName: 'AI Assistant',
      photoURL: null,
      error: error,
    );
  }

  // Create a loading message
  factory PublicChatMessage.loading({
    String? id,
  }) {
    return PublicChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: '',
      type: PublicMessageType.assistant,
      userId: 'ai-assistant',
      displayName: 'AI Assistant',
      isLoading: true,
    );
  }

  // Create a copy with updated properties
  PublicChatMessage copyWith({
    String? id,
    String? content,
    PublicMessageType? type,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
    String? userId,
    String? displayName,
    String? photoURL,
    String? email,
  }) {
    return PublicChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      email: email ?? this.email,
    );
  }

  // Convert to JSON for API requests (for AI context)
  Map<String, dynamic> toJson() {
    return {
      'role': type == PublicMessageType.user ? 'user' : 'assistant',
      'content': content,
    };
  }

  // Create from JSON response
  factory PublicChatMessage.fromJson(Map<String, dynamic> json) {
    return PublicChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? '',
      type: json['role'] == 'user' ? PublicMessageType.user : PublicMessageType.assistant,
      userId: 'ai-assistant',
      displayName: 'AI Assistant',
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'type': type.name,
      'timestamp': timestamp,
      'isLoading': isLoading,
      'error': error,
      'userId': userId,
      'displayName': displayName,
      'photoURL': photoURL,
      'email': email,
    };
  }

  // Create from Firestore document
  factory PublicChatMessage.fromFirestore(Map<String, dynamic> data, String documentId) {
    return PublicChatMessage(
      id: documentId,
      content: data['content'] ?? '',
      type: PublicMessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => PublicMessageType.user,
      ),
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      isLoading: data['isLoading'] ?? false,
      error: data['error'],
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? 'Unknown User',
      photoURL: data['photoURL'],
      email: data['email'],
    );
  }

  // Check if message mentions AI
  bool get mentionsAI {
    return content.toLowerCase().contains('@ai') || 
           content.toLowerCase().contains('@assistant');
  }

  // Get display name with fallback
  String get displayNameOrFallback {
    if (displayName.isNotEmpty) return displayName;
    if (email != null && email!.isNotEmpty) return email!.split('@')[0];
    return 'User';
  }

  @override
  String toString() {
    return 'PublicChatMessage(id: $id, content: $content, type: $type, userId: $userId, displayName: $displayName, timestamp: $timestamp, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PublicChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
