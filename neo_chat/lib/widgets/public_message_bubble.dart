import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/public_chat_message.dart';

class PublicMessageBubble extends StatelessWidget {
  final PublicChatMessage message;
  final bool canDelete;
  final VoidCallback? onDelete;

  const PublicMessageBubble({
    super.key,
    required this.message,
    this.canDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isCurrentUser = message.userId == currentUserId;
    final isAI = message.type == PublicMessageType.assistant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isCurrentUser && !isAI 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        children: [
          // User info (for non-current users and AI)
          if (!isCurrentUser || isAI)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isAI 
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    backgroundImage: message.photoURL != null 
                        ? NetworkImage(message.photoURL!)
                        : null,
                    child: message.photoURL == null
                        ? Icon(
                            isAI ? Icons.smart_toy : Icons.person,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  
                  // User name and timestamp
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.displayNameOrFallback,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isAI 
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Message bubble
          Row(
            mainAxisAlignment: isCurrentUser && !isAI 
                ? MainAxisAlignment.end 
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: GestureDetector(
                  onLongPress: canDelete ? () => _showDeleteDialog(context) : null,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _getBubbleColor(context, isCurrentUser, isAI),
                      borderRadius: BorderRadius.circular(18).copyWith(
                        topLeft: !isCurrentUser || isAI 
                            ? const Radius.circular(4) 
                            : const Radius.circular(18),
                        topRight: isCurrentUser && !isAI 
                            ? const Radius.circular(4) 
                            : const Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message content
                        if (message.isLoading)
                          _buildLoadingIndicator(context)
                        else
                          _buildMessageContent(context, isCurrentUser, isAI),

                        // Error indicator
                        if (message.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 16,
                                  color: Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Failed to send',
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Timestamp for current user messages
                        if (isCurrentUser && !isAI)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _formatTimestamp(message.timestamp),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBubbleColor(BuildContext context, bool isCurrentUser, bool isAI) {
    if (isAI) {
      return Theme.of(context).colorScheme.secondaryContainer;
    } else if (isCurrentUser) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Theme.of(context).colorScheme.surfaceVariant;
    }
  }

  Widget _buildMessageContent(BuildContext context, bool isCurrentUser, bool isAI) {
    final textColor = isAI
        ? Theme.of(context).colorScheme.onSecondaryContainer
        : isCurrentUser
            ? Colors.white
            : Theme.of(context).colorScheme.onSurfaceVariant;

    return Text(
      message.content,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: textColor,
        height: 1.3,
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'AI is typing...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showDeleteDialog(BuildContext context) {
    if (onDelete == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete!();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
