import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onRetry;

  const MessageBubble({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondary,
              child: const Icon(
                Icons.smart_toy,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.error != null)
                    _buildErrorContent(context)
                  else
                    _buildMessageContent(context, isUser),
                  
                  const SizedBox(height: 4),
                  
                  // Timestamp
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Colors.white.withOpacity(0.7)
                          : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.error_outline,
              size: 16,
              color: Colors.red.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              'Error',
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          message.content,
          style: const TextStyle(color: Colors.black87),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    final theme = Theme.of(context);
    final fg = isUser ? Colors.white : theme.colorScheme.onSurfaceVariant;

    if (isUser) {
      return GestureDetector(
        onLongPress: () => _copyToClipboard(context),
        child: SelectableText(
          message.content,
          style: TextStyle(color: fg, fontSize: 16),
        ),
      );
    }

    final codeBg = theme.colorScheme.surface;
    return GestureDetector(
      onLongPress: () => _copyToClipboard(context),
      child: MarkdownBody(
        data: message.content,
        selectable: true,
        onTapLink: (text, href, title) {
          if (href != null) Clipboard.setData(ClipboardData(text: href));
        },
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          p: TextStyle(color: fg, fontSize: 16, height: 1.4),
          listBullet: TextStyle(color: fg, fontSize: 16),
          strong: TextStyle(color: fg, fontWeight: FontWeight.bold),
          em: TextStyle(color: fg, fontStyle: FontStyle.italic),
          a: TextStyle(
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
          code: TextStyle(
            color: fg,
            fontFamily: 'monospace',
            fontSize: 14,
            backgroundColor: codeBg,
          ),
          codeblockDecoration: BoxDecoration(
            color: codeBg,
            borderRadius: BorderRadius.circular(8),
          ),
          codeblockPadding: const EdgeInsets.all(12),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: theme.colorScheme.primary, width: 3),
            ),
          ),
          blockquotePadding: const EdgeInsets.only(left: 12),
          h1: TextStyle(color: fg, fontSize: 22, fontWeight: FontWeight.bold),
          h2: TextStyle(color: fg, fontSize: 20, fontWeight: FontWeight.bold),
          h3: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
