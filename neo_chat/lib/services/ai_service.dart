import '../config/api_config.dart';
import '../models/chat_message.dart';
import 'openai_compatible_service.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final OpenAICompatibleService _client = OpenAICompatibleService();

  Future<String> sendMessage({
    required ApiProvider provider,
    required List<ChatMessage> messages,
    String? model,
    double? temperature,
    int? maxTokens,
  }) {
    return _client.sendMessage(
      provider: provider,
      messages: messages,
      model: model,
      temperature: temperature,
      maxTokens: maxTokens,
    );
  }

  Future<List<String>> getAvailableModels(ApiProvider provider) =>
      _client.getAvailableModels(provider);

  Future<bool> testConnection(ApiProvider provider) =>
      _client.testConnection(provider);

  String getDefaultModel(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return ApiConfig.defaultModel;
      case ApiProvider.openAI:
        return 'gpt-3.5-turbo';
    }
  }

  void dispose() => _client.dispose();
}
