import '../config/api_config.dart';
import '../models/chat_message.dart';
import 'openrouter_service.dart';
import 'openai_service.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final OpenRouterService _openRouterService = OpenRouterService();
  final OpenAIService _openAIService = OpenAIService();

  /// Send a chat completion request using the specified provider
  Future<String> sendMessage({
    required ApiProvider provider,
    required List<ChatMessage> messages,
    String? model,
    double? temperature,
    int? maxTokens,
  }) async {
    switch (provider) {
      case ApiProvider.openRouter:
        return await _openRouterService.sendMessage(
          messages: messages,
          model: model,
          temperature: temperature,
          maxTokens: maxTokens,
        );
      case ApiProvider.openAI:
        return await _openAIService.sendMessage(
          messages: messages,
          model: model,
          temperature: temperature,
          maxTokens: maxTokens,
        );
    }
  }

  /// Get available models for the specified provider
  Future<List<String>> getAvailableModels(ApiProvider provider) async {
    switch (provider) {
      case ApiProvider.openRouter:
        return await _openRouterService.getAvailableModels();
      case ApiProvider.openAI:
        return await _openAIService.getAvailableModels();
    }
  }

  /// Test API connection for the specified provider
  Future<bool> testConnection(ApiProvider provider) async {
    switch (provider) {
      case ApiProvider.openRouter:
        return await _openRouterService.testConnection();
      case ApiProvider.openAI:
        return await _openAIService.testConnection();
    }
  }

  /// Get default model for the specified provider
  String getDefaultModel(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return ApiConfig.defaultModel;
      case ApiProvider.openAI:
        return 'gpt-3.5-turbo';
    }
  }

  /// Dispose resources
  void dispose() {
    _openRouterService.dispose();
    _openAIService.dispose();
  }
}