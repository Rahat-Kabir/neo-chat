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

enum ApiProvider { openRouter, openAI }

class ApiConfig {
  // OpenRouter API Configuration
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String openRouterApiKey =
      'your-openrouter-api-key-here';

  // OpenAI API Configuration
  static const String openAIBaseUrl = 'https://api.openai.com/v1';
  static const String openAIApiKey =
      'your-openai-api-key-here';

  // Default provider and model
  static const ApiProvider defaultProvider = ApiProvider.openRouter;
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

  // OpenRouter available models
  static const Map<String, String> openRouterModels = {
    'deepseek-r1-free': 'deepseek/deepseek-r1-0528:free',
    'gpt-oss-20b-free': 'openai/gpt-oss-20b:free',
    'gpt-3.5-turbo': 'openai/gpt-3.5-turbo',
    'gpt-4': 'openai/gpt-4',
    'claude-3-haiku': 'anthropic/claude-3-haiku',
  };

  // OpenAI available models
  static const Map<String, String> openAIModels = {
    'gpt-4': 'gpt-4',
    'gpt-4-turbo': 'gpt-4-turbo',
    'gpt-3.5-turbo': 'gpt-3.5-turbo',
    'gpt-4o': 'gpt-4o',
  };

  // Quick toggle models for each provider
  static const List<String> openRouterQuickToggle = [
    'deepseek/deepseek-r1-0528:free',
    'openai/gpt-oss-20b:free',
  ];

  static const List<String> openAIQuickToggle = [
    'gpt-4',
    'gpt-3.5-turbo',
  ];

  // Get display name for model
  static String getModelDisplayName(String modelId) {
    switch (modelId) {
      case 'deepseek/deepseek-r1-0528:free':
        return 'DeepSeek R1 (Free)';
      case 'openai/gpt-oss-20b:free':
        return 'GPT OSS 20B (Free)';
      case 'gpt-4':
        return 'GPT-4';
      case 'gpt-4-turbo':
        return 'GPT-4 Turbo';
      case 'gpt-3.5-turbo':
        return 'GPT-3.5 Turbo';
      case 'gpt-4o':
        return 'GPT-4o';
      default:
        return modelId;
    }
  }

  // Get provider display name
  static String getProviderDisplayName(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return 'OpenRouter';
      case ApiProvider.openAI:
        return 'OpenAI';
    }
  }

  // Get available models for provider
  static Map<String, String> getModelsForProvider(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return openRouterModels;
      case ApiProvider.openAI:
        return openAIModels;
    }
  }

  // Get quick toggle models for provider
  static List<String> getQuickToggleModelsForProvider(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return openRouterQuickToggle;
      case ApiProvider.openAI:
        return openAIQuickToggle;
    }
  }

  // Get full API URL for provider
  static String getChatCompletionsUrl(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return '$openRouterBaseUrl$chatCompletionsEndpoint';
      case ApiProvider.openAI:
        return '$openAIBaseUrl$chatCompletionsEndpoint';
    }
  }

  // Get headers for API requests by provider
  static Map<String, String> getHeaders(ApiProvider provider) {
    switch (provider) {
      case ApiProvider.openRouter:
        return {
          'Authorization': 'Bearer $openRouterApiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': siteUrl,
          'X-Title': siteName,
        };
      case ApiProvider.openAI:
        return {
          'Authorization': 'Bearer $openAIApiKey',
          'Content-Type': 'application/json',
        };
    }
  }
}
