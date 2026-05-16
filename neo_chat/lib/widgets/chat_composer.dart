import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Bottom message-input bar: text field + send button.
/// Owns its own [TextEditingController] and [FocusNode] so the screen
/// doesn't have to. The vision feature will plug an attach button in here.
class ChatComposer extends StatefulWidget {
  final bool isSending;
  final ValueChanged<String> onSend;

  /// Emit a value to prefill the text field and focus it. Used by the
  /// empty-state suggestion chips.
  final ValueListenable<String>? prefill;

  const ChatComposer({
    super.key,
    required this.isSending,
    required this.onSend,
    this.prefill,
  });

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.prefill?.addListener(_applyPrefill);
  }

  @override
  void didUpdateWidget(covariant ChatComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prefill != widget.prefill) {
      oldWidget.prefill?.removeListener(_applyPrefill);
      widget.prefill?.addListener(_applyPrefill);
    }
  }

  void _applyPrefill() {
    final text = widget.prefill?.value ?? '';
    if (text.isEmpty) return;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    widget.prefill?.removeListener(_applyPrefill);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: widget.isSending ? null : _submit,
            mini: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            child: widget.isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
