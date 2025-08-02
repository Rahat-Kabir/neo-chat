enum MessageType {
  user,
  assistant,
  system,
}

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    DateTime? timestamp,
    this.isLoading = false,
    this.error,
  }) : timestamp = timestamp ?? DateTime.now();

  // Create a user message
  factory ChatMessage.user({
    required String content,
    String? id,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.user,
    );
  }

  // Create an assistant message
  factory ChatMessage.assistant({
    required String content,
    String? id,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.assistant,
      error: error,
    );
  }

  // Create a loading message
  factory ChatMessage.loading({
    String? id,
  }) {
    return ChatMessage(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: '',
      type: MessageType.assistant,
      isLoading: true,
    );
  }

  // Create a copy with updated properties
  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'role': type == MessageType.user ? 'user' : 'assistant',
      'content': content,
    };
  }

  // Create from JSON response
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? '',
      type: json['role'] == 'user' ? MessageType.user : MessageType.assistant,
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
    };
  }

  // Create from Firestore document
  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ChatMessage(
      id: documentId,
      content: data['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.user,
      ),
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      isLoading: data['isLoading'] ?? false,
      error: data['error'],
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, type: $type, timestamp: $timestamp, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
