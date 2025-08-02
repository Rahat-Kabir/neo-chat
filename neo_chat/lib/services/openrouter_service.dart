import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/chat_message.dart';

class OpenRouterService {
  static final OpenRouterService _instance = OpenRouterService._internal();
  factory OpenRouterService() => _instance;
  OpenRouterService._internal();

  final http.Client _client = http.Client();

  /// Send a chat completion request to OpenRouter API
  Future<String> sendMessage({
    required List<ChatMessage> messages,
    String? model,
    double? temperature,
    int? maxTokens,
  }) async {
    try {
      // Prepare the request body
      final requestBody = {
        'model': model ?? ApiConfig.defaultModel,
        'messages': messages
            .where((msg) => !msg.isLoading && msg.error == null)
            .map((msg) => msg.toJson())
            .toList(),
        'temperature': temperature ?? ApiConfig.temperature,
        'max_tokens': maxTokens ?? ApiConfig.maxTokens,
      };

      // Make the API request
      final response = await _client
          .post(
            Uri.parse(ApiConfig.chatCompletionsUrl),
            headers: ApiConfig.headers,
            body: jsonEncode(requestBody),
          )
          .timeout(
            Duration(seconds: ApiConfig.requestTimeoutSeconds),
          );

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Extract the message content from the response
        if (responseData['choices'] != null && 
            responseData['choices'].isNotEmpty) {
          final choice = responseData['choices'][0];
          final message = choice['message'];
          return message['content'] ?? 'No response content';
        } else {
          throw 'Invalid response format from API';
        }
      } else {
        // Handle API errors
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 
                           'API request failed with status ${response.statusCode}';
        throw errorMessage;
      }
    } on SocketException {
      throw 'No internet connection. Please check your network and try again.';
    } on http.ClientException {
      throw 'Network error occurred. Please try again.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw 'Request timed out. Please try again.';
      }
      throw e.toString();
    }
  }

  /// Get available models from OpenRouter
  Future<List<String>> getAvailableModels() async {
    try {
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.openRouterBaseUrl}/models'),
            headers: ApiConfig.headers,
          )
          .timeout(
            Duration(seconds: ApiConfig.requestTimeoutSeconds),
          );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final models = responseData['data'] as List;
        return models.map((model) => model['id'] as String).toList();
      } else {
        throw 'Failed to fetch available models';
      }
    } catch (e) {
      // Return default models if API call fails
      return ApiConfig.availableModels.values.toList();
    }
  }

  /// Test API connection
  Future<bool> testConnection() async {
    try {
      final testMessages = [
        ChatMessage.user(content: 'Hello'),
      ];
      
      await sendMessage(messages: testMessages);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
