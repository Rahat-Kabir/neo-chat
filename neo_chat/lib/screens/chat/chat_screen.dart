import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/chat_composer.dart';
import '../../widgets/typing_bubble.dart';
import '../../config/api_config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<String> _composerPrefill = ValueNotifier<String>('');

  @override
  void dispose() {
    _scrollController.dispose();
    _composerPrefill.dispose();
    super.dispose();
  }

  void _prefillComposer(String text) {
    // Re-emit even when value is unchanged so a second tap still focuses.
    _composerPrefill.value = '';
    _composerPrefill.value = text;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend(String text) {
    context.read<ChatProvider>().sendMessage(text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _toggleModel(ChatProvider chatProvider) {
    final currentModel = chatProvider.currentModel;
    final quickToggleModels = ApiConfig.getQuickToggleModelsForProvider(chatProvider.currentProvider);
    final otherModel = quickToggleModels
        .firstWhere((model) => model != currentModel);
    chatProvider.setModel(otherModel);
  }

  void _showProviderDialog(ChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select AI Provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProviderTile(ApiProvider.openRouter, chatProvider),
            const SizedBox(height: 8),
            _buildProviderTile(ApiProvider.openAI, chatProvider),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderTile(
    ApiProvider provider,
    ChatProvider chatProvider,
  ) {
    final isSelected = chatProvider.currentProvider == provider;
    return ListTile(
      leading: Icon(
        provider == ApiProvider.openAI ? Icons.psychology : Icons.hub,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        ApiConfig.getProviderDisplayName(provider),
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        if (provider != chatProvider.currentProvider) {
          chatProvider.setProvider(provider);
        }
        Navigator.pop(context);
        _showModelDialog(chatProvider);
      },
    );
  }

  void _showModelDialog(ChatProvider chatProvider) {
    final models = ApiConfig.getModelsForProvider(chatProvider.currentProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${ApiConfig.getProviderDisplayName(chatProvider.currentProvider)} Model'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: models.length,
            itemBuilder: (context, index) {
              final modelEntry = models.entries.elementAt(index);
              final modelId = modelEntry.value;
              final isSelected = chatProvider.currentModel == modelId;

              return ListTile(
                title: Text(
                  ApiConfig.getModelDisplayName(modelId),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  chatProvider.setModel(modelId);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NeoChat AI'),
                Text(
                  '${ApiConfig.getProviderDisplayName(chatProvider.currentProvider)} • ${ApiConfig.getModelDisplayName(chatProvider.currentModel)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'select_provider':
                      _showProviderDialog(chatProvider);
                      break;
                    case 'select_model':
                      _showModelDialog(chatProvider);
                      break;
                    case 'toggle_model':
                      _toggleModel(chatProvider);
                      break;
                    case 'clear':
                      chatProvider.clearMessages();
                      break;
                    case 'retry':
                      chatProvider.retryLastMessage();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'select_provider',
                    child: Row(
                      children: [
                        const Icon(Icons.cloud),
                        const SizedBox(width: 8),
                        Text('Change Provider (${ApiConfig.getProviderDisplayName(chatProvider.currentProvider)})'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'select_model',
                    child: Row(
                      children: [
                        const Icon(Icons.tune),
                        const SizedBox(width: 8),
                        const Text('Change Model'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle_model',
                    child: Row(
                      children: [
                        const Icon(Icons.swap_horiz),
                        const SizedBox(width: 8),
                        Text('Quick Toggle'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all),
                        SizedBox(width: 8),
                        Text('Clear Chat'),
                      ],
                    ),
                  ),
                  if (chatProvider.hasMessages)
                    const PopupMenuItem(
                      value: 'retry',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text('Retry Last'),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty && !chatProvider.isLoading) {
                  return _buildEmptyState();
                }

                final messages = chatProvider.messages;
                final showTyping = chatProvider.isLoading;
                final itemCount = messages.length + (showTyping ? 1 : 0);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (showTyping && index == messages.length) {
                      return const TypingBubble();
                    }
                    final message = messages[index];
                    return MessageBubble(
                      message: message,
                      onRetry: message.error != null
                          ? () => chatProvider.retryLastMessage()
                          : null,
                    );
                  },
                );
              },
            ),
          ),

          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.error == null) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        chatProvider.error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                    IconButton(
                      onPressed: chatProvider.clearError,
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                    ),
                  ],
                ),
              );
            },
          ),

          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return ChatComposer(
                isSending: chatProvider.isLoading,
                onSend: _handleSend,
                prefill: _composerPrefill,
              );
            },
          ),
        ],
      ),
    );
  }

  static const _suggestions = <_Suggestion>[
    _Suggestion(
      icon: Icons.code,
      label: 'Explain a code snippet',
      prompt: 'Explain what this code does, step by step:\n\n',
    ),
    _Suggestion(
      icon: Icons.summarize_outlined,
      label: 'Summarize text',
      prompt: 'Summarize the following in 5 bullet points:\n\n',
    ),
    _Suggestion(
      icon: Icons.lightbulb_outline,
      label: 'Brainstorm ideas',
      prompt: 'Brainstorm 10 creative ideas for ',
    ),
    _Suggestion(
      icon: Icons.school_outlined,
      label: 'Teach me something',
      prompt: 'Teach me the basics of ',
    ),
  ];

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 56,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'How can I help today?',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pick a suggestion or type your own message',
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _suggestions
                  .map((s) => ActionChip(
                        avatar: Icon(s.icon, size: 18),
                        label: Text(s.label),
                        onPressed: () => _prefillComposer(s.prompt),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Suggestion {
  final IconData icon;
  final String label;
  final String prompt;
  const _Suggestion({
    required this.icon,
    required this.label,
    required this.prompt,
  });
}
