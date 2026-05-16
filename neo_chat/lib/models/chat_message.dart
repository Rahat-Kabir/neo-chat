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
  final String? error;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    DateTime? timestamp,
    this.error,
  }) : timestamp = timestamp ?? DateTime.now();

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

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'type': type.name,
      'timestamp': timestamp,
      'error': error,
    };
  }

  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ChatMessage(
      id: documentId,
      content: data['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.user,
      ),
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      error: data['error'],
    );
  }

  @override
  String toString() =>
      'ChatMessage(id: $id, content: $content, type: $type, timestamp: $timestamp, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
