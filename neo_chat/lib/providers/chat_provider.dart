import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/openrouter_service.dart';

class ChatProvider extends ChangeNotifier {
  final OpenRouterService _openRouterService = OpenRouterService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String _currentModel = 'deepseek/deepseek-r1-0528:free';

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentModel => _currentModel;
  bool get hasMessages => _messages.isNotEmpty;

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Set current model
  void setModel(String model) {
    _currentModel = model;
    notifyListeners();
  }

  // Add a message to the chat
  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  // Update a specific message
  void updateMessage(String messageId, ChatMessage updatedMessage) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = updatedMessage;
      notifyListeners();
    }
  }

  // Remove a message
  void removeMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }

  // Send a message and get AI response
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Clear any previous errors
    _error = null;

    // Add user message
    final userMessage = ChatMessage.user(content: content.trim());
    addMessage(userMessage);

    // Add loading message for AI response
    final loadingMessage = ChatMessage.loading();
    addMessage(loadingMessage);

    _isLoading = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _openRouterService.sendMessage(
        messages: _messages.where((msg) => !msg.isLoading).toList(),
        model: _currentModel,
      );

      // Remove loading message and add actual response
      removeMessage(loadingMessage.id);
      final assistantMessage = ChatMessage.assistant(content: response);
      addMessage(assistantMessage);

    } catch (e) {
      // Remove loading message and add error message
      removeMessage(loadingMessage.id);
      final errorMessage = ChatMessage.assistant(
        content: 'Sorry, I encountered an error. Please try again.',
        error: e.toString(),
      );
      addMessage(errorMessage);
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
  void clearMessages() {
    _messages.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
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

  @override
  void dispose() {
    _openRouterService.dispose();
    super.dispose();
  }
}
