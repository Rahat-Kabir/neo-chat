import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/chat_message.dart';

/// A single client for any OpenAI-compatible chat completions endpoint.
/// Behavior is parameterized by [ApiProvider] — URL, headers, and default
/// model are read from [ApiConfig].
class OpenAICompatibleService {
  final http.Client _client;

  OpenAICompatibleService({http.Client? client})
      : _client = client ?? http.Client();

  Future<String> sendMessage({
    required ApiProvider provider,
    required List<ChatMessage> messages,
    String? model,
    double? temperature,
    int? maxTokens,
  }) async {
    final url = ApiConfig.getChatCompletionsUrl(provider);
    final headers = ApiConfig.getHeaders(provider);

    final requestBody = {
      'model': model ?? _defaultModelFor(provider),
      'messages': messages
          .where((msg) => msg.error == null)
          .map(_toApiMessage)
          .toList(),
      'temperature': temperature ?? ApiConfig.temperature,
      'max_tokens': maxTokens ?? ApiConfig.maxTokens,
    };

    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'];
        if (choices is List && choices.isNotEmpty) {
          return choices[0]['message']?['content'] ?? 'No response content';
        }
        throw 'Invalid response format from API';
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ??
            'API request failed with status ${response.statusCode}';
        debugPrint('API error (${provider.name}): $errorMessage');
        throw errorMessage;
      }
    } on http.ClientException {
      throw 'Network error occurred. Please try again.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw 'Request timed out. Please try again.';
      }
      if (e.toString().contains('SocketException')) {
        throw 'No internet connection. Please check your network and try again.';
      }
      rethrow;
    }
  }

  Future<List<String>> getAvailableModels(ApiProvider provider) async {
    final baseUrl = provider == ApiProvider.openAI
        ? ApiConfig.openAIBaseUrl
        : ApiConfig.openRouterBaseUrl;

    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl/models'),
            headers: ApiConfig.getHeaders(provider),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['data'] as List;
        return models.map((m) => m['id'] as String).toList();
      }
      throw 'Failed to fetch available models';
    } catch (_) {
      return ApiConfig.getModelsForProvider(provider).values.toList();
    }
  }

  Future<bool> testConnection(ApiProvider provider) async {
    try {
      await sendMessage(
        provider: provider,
        messages: [ChatMessage.user(content: 'Hello')],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Maps a domain [ChatMessage] to the OpenAI wire format.
  /// This is where vision/multimodal content will be emitted as a content array.
  Map<String, dynamic> _toApiMessage(ChatMessage msg) {
    final role = switch (msg.type) {
      MessageType.user => 'user',
      MessageType.assistant => 'assistant',
      MessageType.system => 'system',
    };
    return {'role': role, 'content': msg.content};
  }

  String _defaultModelFor(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return ApiConfig.defaultModel;
      case ApiProvider.openAI:
        return 'gpt-4o-mini';
    }
  }

  void dispose() => _client.close();
}
