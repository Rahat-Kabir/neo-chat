/// API configuration. Keys are NOT stored here — they come in at build
/// time via `--dart-define-from-file=env.json`. See CLAUDE.md "First-run setup".

enum ApiProvider { openRouter, openAI }

class ApiConfig {
  // Keys are injected at build time via --dart-define-from-file=env.json.
  // env.json lives at the repo root, is gitignored, and is NOT shipped.
  // Empty default means the app still compiles without env.json, but AI
  // calls will fail with 401 until a key is provided.

  // OpenRouter API Configuration
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String openRouterApiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: '',
  );

  // OpenAI API Configuration
  static const String openAIBaseUrl = 'https://api.openai.com/v1';
  static const String openAIApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  // Default provider and model
  static const ApiProvider defaultProvider = ApiProvider.openRouter;
  static const String defaultModel = 'openai/gpt-oss-20b:free';

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
    'gpt-oss-20b-free': 'openai/gpt-oss-20b:free',
    'llama-3.3-70b-free': 'meta-llama/llama-3.3-70b-instruct:free',
    'gemini-2.5-flash': 'google/gemini-2.5-flash',
    'claude-haiku-4.5': 'anthropic/claude-haiku-4.5',
    'claude-sonnet-4.5': 'anthropic/claude-sonnet-4.5',
    'gpt-4o': 'openai/gpt-4o',
    'gpt-4.1': 'openai/gpt-4.1',
  };

  // OpenAI available models
  static const Map<String, String> openAIModels = {
    'gpt-4o': 'gpt-4o',
    'gpt-4o-mini': 'gpt-4o-mini',
    'gpt-4.1': 'gpt-4.1',
    'gpt-4.1-mini': 'gpt-4.1-mini',
  };

  // Quick toggle models for each provider
  static const List<String> openRouterQuickToggle = [
    'openai/gpt-oss-20b:free',
    'anthropic/claude-haiku-4.5',
  ];

  static const List<String> openAIQuickToggle = [
    'gpt-4o-mini',
    'gpt-4o',
  ];

  // Get display name for model
  static String getModelDisplayName(String modelId) {
    switch (modelId) {
      case 'openai/gpt-oss-20b:free':
        return 'GPT OSS 20B (Free)';
      case 'meta-llama/llama-3.3-70b-instruct:free':
        return 'Llama 3.3 70B (Free)';
      case 'google/gemini-2.5-flash':
        return 'Gemini 2.5 Flash';
      case 'anthropic/claude-haiku-4.5':
        return 'Claude Haiku 4.5';
      case 'anthropic/claude-sonnet-4.5':
        return 'Claude Sonnet 4.5';
      case 'openai/gpt-4o':
      case 'gpt-4o':
        return 'GPT-4o';
      case 'gpt-4o-mini':
        return 'GPT-4o mini';
      case 'openai/gpt-4.1':
      case 'gpt-4.1':
        return 'GPT-4.1';
      case 'gpt-4.1-mini':
        return 'GPT-4.1 mini';
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
