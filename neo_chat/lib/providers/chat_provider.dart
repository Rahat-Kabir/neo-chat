import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/chat_message.dart';
import '../services/openrouter_service.dart';
import '../services/firestore_service.dart';

class ChatProvider extends ChangeNotifier {
  final OpenRouterService _openRouterService = OpenRouterService();
  final FirestoreService _firestoreService = FirestoreService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String _currentModel = 'deepseek/deepseek-r1-0528:free';
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;
  bool _isInitialized = false;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentModel => _currentModel;
  bool get hasMessages => _messages.isNotEmpty;
  bool get isInitialized => _isInitialized;

  // Initialize the chat provider and start listening to Firestore
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load user's preferred model
      await _loadUserPreferences();

      // Start listening to messages from Firestore
      _startListeningToMessages();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize chat: $e';
      notifyListeners();
    }
  }

  // Load user preferences from Firestore
  Future<void> _loadUserPreferences() async {
    try {
      final userId = _firestoreService.currentUserId;
      if (userId != null) {
        final profile = await _firestoreService.getUserProfile(userId);
        if (profile != null && profile['preferredModel'] != null) {
          _currentModel = profile['preferredModel'];
        }
      }
    } catch (e) {
      // Ignore errors when loading preferences, use defaults
      debugPrint('Failed to load user preferences: $e');
    }
  }

  // Start listening to messages from Firestore
  void _startListeningToMessages() {
    _messagesSubscription?.cancel();
    _messagesSubscription = _firestoreService.getMessagesStream().listen(
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

  // Set current model and save to Firestore
  Future<void> setModel(String model) async {
    _currentModel = model;
    notifyListeners();

    try {
      await _firestoreService.updatePreferredModel(model);
    } catch (e) {
      // Don't show error to user for preference updates
      debugPrint('Failed to save preferred model: $e');
    }
  }

  // Add a message to the chat and save to Firestore
  Future<void> addMessage(ChatMessage message) async {
    // Add to local list immediately for responsive UI
    _messages.add(message);
    notifyListeners();

    // Save to Firestore (don't save loading messages)
    if (!message.isLoading) {
      try {
        await _firestoreService.saveMessage(message);
      } catch (e) {
        // If saving fails, show error but keep message in local list
        _error = 'Failed to save message: $e';
        notifyListeners();
      }
    }
  }

  // Update a specific message
  void updateMessage(String messageId, ChatMessage updatedMessage) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = updatedMessage;
      notifyListeners();
    }
  }

  // Remove a message (for loading messages, don't delete from Firestore)
  Future<void> removeMessage(String messageId) async {
    final message = _messages.firstWhere((msg) => msg.id == messageId, orElse: () => ChatMessage.user(content: ''));

    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();

    // Only delete from Firestore if it's not a loading message
    if (message.id.isNotEmpty && !message.isLoading) {
      try {
        await _firestoreService.deleteMessage(messageId);
      } catch (e) {
        // If deletion fails, add the message back
        _messages.add(message);
        _error = 'Failed to delete message: $e';
        notifyListeners();
      }
    }
  }

  // Send a message and get AI response
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Clear any previous errors
    _error = null;

    // Add user message
    final userMessage = ChatMessage.user(content: content.trim());
    await addMessage(userMessage);

    // Add loading message for AI response (don't save to Firestore)
    final loadingMessage = ChatMessage.loading();
    _messages.add(loadingMessage);
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _openRouterService.sendMessage(
        messages: _messages.where((msg) => !msg.isLoading).toList(),
        model: _currentModel,
      );

      // Remove loading message and add actual response
      _messages.removeWhere((msg) => msg.id == loadingMessage.id);
      final assistantMessage = ChatMessage.assistant(content: response);
      await addMessage(assistantMessage);

    } catch (e) {
      // Remove loading message and add error message
      _messages.removeWhere((msg) => msg.id == loadingMessage.id);
      final errorMessage = ChatMessage.assistant(
        content: 'Sorry, I encountered an error. Please try again.',
        error: e.toString(),
      );
      await addMessage(errorMessage);
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Retry last failed message
  Future<void> retryLastMessage() async {
    if (_messages.isEmpty) return;

    // Find the last user message
    ChatMessage? lastUserMessage;
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].type == MessageType.user) {
        lastUserMessage = _messages[i];
        break;
      }
    }

    if (lastUserMessage != null) {
      // Remove any assistant messages after the last user message
      _messages.removeWhere((msg) => 
        msg.type == MessageType.assistant && 
        msg.timestamp.isAfter(lastUserMessage!.timestamp));
      
      // Resend the message
      await sendMessage(lastUserMessage.content);
    }
  }

  // Clear all messages
  Future<void> clearMessages() async {
    try {
      await _firestoreService.clearAllMessages();
      _messages.clear();
      _error = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear messages: $e';
      notifyListeners();
    }
  }

  // Test API connection
  Future<bool> testConnection() async {
    try {
      return await _openRouterService.testConnection();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get available models
  Future<List<String>> getAvailableModels() async {
    try {
      return await _openRouterService.getAvailableModels();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Get chat statistics
  Future<Map<String, dynamic>> getChatStats() async {
    try {
      return await _firestoreService.getChatStats();
    } catch (e) {
      _error = 'Failed to get chat stats: $e';
      notifyListeners();
      return {};
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _openRouterService.dispose();
    super.dispose();
  }
}
