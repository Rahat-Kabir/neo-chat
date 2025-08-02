/// API Configuration Template
/// 
/// IMPORTANT: This is a template file. Copy this to api_config.dart
/// and replace the placeholder values with your actual API keys.
/// 
/// To set up your API configuration:
/// 1. Copy this file to api_config.dart
/// 2. Replace 'your-openrouter-api-key-here' with your actual OpenRouter API key
/// 3. Never commit api_config.dart to version control
/// 
/// The api_config.dart file is gitignored for security reasons.

class ApiConfig {
  // OpenRouter API Configuration
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String openRouterApiKey = 'your-openrouter-api-key-here';
  
  // Default model to use
  static const String defaultModel = 'deepseek/deepseek-r1-0528:free';
  
  // Optional headers for OpenRouter leaderboards
  static const String siteUrl = 'https://github.com/Rahat-Kabir/neo-chat';
  static const String siteName = 'NeoChat';
  
  // API endpoints
  static const String chatCompletionsEndpoint = '/chat/completions';
  
  // Request configuration
  static const int requestTimeoutSeconds = 30;
  static const int maxTokens = 1000;
  static const double temperature = 0.7;
  
  // Available models (can be expanded)
  static const Map<String, String> availableModels = {
    'deepseek-r1-free': 'deepseek/deepseek-r1-0528:free',
    'gpt-3.5-turbo': 'openai/gpt-3.5-turbo',
    'gpt-4': 'openai/gpt-4',
    'claude-3-haiku': 'anthropic/claude-3-haiku',
  };
  
  // Get full API URL
  static String get chatCompletionsUrl => '$openRouterBaseUrl$chatCompletionsEndpoint';
  
  // Get headers for API requests
  static Map<String, String> get headers => {
    'Authorization': 'Bearer $openRouterApiKey',
    'Content-Type': 'application/json',
    'HTTP-Referer': siteUrl,
    'X-Title': siteName,
  };
}
