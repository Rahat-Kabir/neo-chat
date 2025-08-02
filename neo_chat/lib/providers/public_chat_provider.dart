import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/public_chat_message.dart';
import '../models/chat_message.dart';
import '../services/public_chat_service.dart';
import '../services/openrouter_service.dart';

class PublicChatProvider extends ChangeNotifier {
  final PublicChatService _publicChatService = PublicChatService();
  final OpenRouterService _openRouterService = OpenRouterService();
  final List<PublicChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<PublicChatMessage>>? _messagesSubscription;
  bool _isInitialized = false;

  // Getters
  List<PublicChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMessages => _messages.isNotEmpty;
  bool get isInitialized => _isInitialized;

  // Initialize the public chat provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize the public room
      await _publicChatService.initializePublicRoom();

      // Start listening to messages from Firestore
      _startListeningToMessages();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize public chat: $e';
      notifyListeners();
    }
  }

  // Start listening to messages from Firestore
  void _startListeningToMessages() {
    _messagesSubscription?.cancel();
    _messagesSubscription = _publicChatService.getMessagesStream().listen(
      (messages) {
        _messages.clear();
        _messages.addAll(messages);
        notifyListeners();
      },
      onError: (error) {
        _error = 'Failed to load messages: $error';
        notifyListeners();
      },
    );
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Send a message to the public room
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Clear any previous errors
    _error = null;

    try {
      // Create and send user message
      final userMessage = _publicChatService.createUserMessage(content.trim());
      await _publicChatService.saveMessage(userMessage);

      // Check if message triggers AI response
      if (_publicChatService.messageTriggersAI(content)) {
        await _handleAIResponse();
      }

    } catch (e) {
      _error = 'Failed to send message: $e';
      notifyListeners();
    }
  }

  // Handle AI response when triggered
  Future<void> _handleAIResponse() async {
    // Add loading message for AI response
    final loadingMessage = PublicChatMessage.loading();
    _messages.add(loadingMessage);
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Get recent messages for context (last 5 user messages)
      final recentMessages = await _publicChatService.getRecentMessages(limit: 10);
      final contextMessages = _publicChatService.getContextMessages(recentMessages, limit: 5);

      // Convert to format expected by OpenRouter API
      final apiMessages = contextMessages.map((msg) => msg.toJson()).toList();

      // Get AI response
      final response = await _openRouterService.sendMessage(
        messages: contextMessages.map((msg) => 
          ChatMessage.user(content: msg.content, id: msg.id)
        ).toList(),
        model: 'deepseek/deepseek-r1-0528:free',
      );

      // Remove loading message from local list
      _messages.removeWhere((msg) => msg.id == loadingMessage.id);

      // Create and save AI response
      final aiMessage = PublicChatMessage.assistant(content: response);
      await _publicChatService.saveMessage(aiMessage);

    } catch (e) {
      // Remove loading message and show error
      _messages.removeWhere((msg) => msg.id == loadingMessage.id);
      
      final errorMessage = PublicChatMessage.assistant(
        content: 'Sorry, I encountered an error and cannot respond right now. Please try mentioning me again later.',
        error: e.toString(),
      );
      
      try {
        await _publicChatService.saveMessage(errorMessage);
      } catch (saveError) {
        _error = 'Failed to save error message: $saveError';
      }
      
      _error = 'AI response failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a message (only own messages)
  Future<void> deleteMessage(PublicChatMessage message) async {
    try {
      await _publicChatService.deleteMessage(message.id, message.userId);
    } catch (e) {
      _error = 'Failed to delete message: $e';
      notifyListeners();
    }
  }

  // Get room statistics
  Future<Map<String, dynamic>> getRoomStats() async {
    try {
      return await _publicChatService.getRoomStats();
    } catch (e) {
      _error = 'Failed to get room stats: $e';
      notifyListeners();
      return {};
    }
  }

  // Get room info
  Future<Map<String, dynamic>?> getRoomInfo() async {
    try {
      return await _publicChatService.getRoomInfo();
    } catch (e) {
      _error = 'Failed to get room info: $e';
      notifyListeners();
      return null;
    }
  }

  // Check if current user can delete a message
  bool canDeleteMessage(PublicChatMessage message) {
    final currentUserId = _publicChatService.currentUserId;
    return currentUserId != null && currentUserId == message.userId;
  }

  // Get unique users count in current messages
  int get uniqueUsersCount {
    return _messages
        .where((msg) => msg.type == PublicMessageType.user)
        .map((msg) => msg.userId)
        .toSet()
        .length;
  }

  // Get AI messages count
  int get aiMessagesCount {
    return _messages
        .where((msg) => msg.type == PublicMessageType.assistant)
        .length;
  }

  // Get user messages count
  int get userMessagesCount {
    return _messages
        .where((msg) => msg.type == PublicMessageType.user)
        .length;
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _openRouterService.dispose();
    super.dispose();
  }
}
