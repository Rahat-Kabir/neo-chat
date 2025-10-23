import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';
import '../../config/api_config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(message);
      _messageController.clear();
      _focusNode.requestFocus();
      
      // Scroll to bottom after a short delay to allow for message to be added
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _toggleModel(ChatProvider chatProvider) {
    final currentModel = chatProvider.currentModel;
    final quickToggleModels = ApiConfig.getQuickToggleModelsForProvider(chatProvider.currentProvider);
    final otherModel = quickToggleModels
        .firstWhere((model) => model != currentModel);
    chatProvider.setModel(otherModel);
  }

  String _getOtherModelName(String currentModel, ApiProvider currentProvider) {
    final quickToggleModels = ApiConfig.getQuickToggleModelsForProvider(currentProvider);
    final otherModel = quickToggleModels
        .firstWhere((model) => model != currentModel);
    return ApiConfig.getModelDisplayName(otherModel);
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
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
          // Messages list
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
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

          // Error display
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.error != null) {
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
              }
              return const SizedBox.shrink();
            },
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return FloatingActionButton(
                      onPressed: chatProvider.isLoading ? null : _sendMessage,
                      mini: true,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      child: chatProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to begin chatting with AI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
