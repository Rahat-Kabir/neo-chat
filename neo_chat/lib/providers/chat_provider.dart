import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/firestore_service.dart';
import '../config/api_config.dart';

class ChatProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  final FirestoreService _firestoreService = FirestoreService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  ApiProvider _currentProvider = ApiConfig.defaultProvider;
  String _currentModel = ApiConfig.defaultModel;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;
  bool _isInitialized = false;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  ApiProvider get currentProvider => _currentProvider;
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
        if (profile != null) {
          if (profile['preferredModel'] != null) {
            _currentModel = profile['preferredModel'];
          }
          if (profile['preferredProvider'] != null) {
            final providerString = profile['preferredProvider'] as String;
            _currentProvider = providerString == 'openAI' ? ApiProvider.openAI : ApiProvider.openRouter;
          }
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

  // Set current provider and save to Firestore
  Future<void> setProvider(ApiProvider provider) async {
    _currentProvider = provider;
    // Set default model for the new provider
    _currentModel = _aiService.getDefaultModel(provider);
    notifyListeners();

    try {
      final providerString = provider == ApiProvider.openAI ? 'openAI' : 'openRouter';
      // Update both provider and model
      final userId = _firestoreService.currentUserId;
      if (userId != null) {
        await _firestoreService.updateUserProfile(userId, {
          'preferredProvider': providerString,
          'preferredModel': _currentModel,
        });
      }
    } catch (e) {
      // Don't show error to user for preference updates
      debugPrint('Failed to save preferred provider: $e');
    }
  }

  // Set both provider and model
  Future<void> setProviderAndModel(ApiProvider provider, String model) async {
    _currentProvider = provider;
    _currentModel = model;
    notifyListeners();

    try {
      final providerString = provider == ApiProvider.openAI ? 'openAI' : 'openRouter';
      final userId = _firestoreService.currentUserId;
      if (userId != null) {
        await _firestoreService.updateUserProfile(userId, {
          'preferredProvider': providerString,
          'preferredModel': model,
        });
      }
    } catch (e) {
      // Don't show error to user for preference updates
      debugPrint('Failed to save preferences: $e');
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
      // Get AI response using the current provider
      final response = await _aiService.sendMessage(
        provider: _currentProvider,
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

  // Test API connection for current provider
  Future<bool> testConnection() async {
    try {
      return await _aiService.testConnection(_currentProvider);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Test API connection for specific provider
  Future<bool> testConnectionForProvider(ApiProvider provider) async {
    try {
      return await _aiService.testConnection(provider);
    } catch (e) {
      return false;
    }
  }

  // Get available models for current provider
  Future<List<String>> getAvailableModels() async {
    try {
      return await _aiService.getAvailableModels(_currentProvider);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Get available models for specific provider
  Future<List<String>> getAvailableModelsForProvider(ApiProvider provider) async {
    try {
      return await _aiService.getAvailableModels(provider);
    } catch (e) {
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
    _aiService.dispose();
    super.dispose();
  }
}
