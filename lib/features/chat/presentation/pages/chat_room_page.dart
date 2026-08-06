import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../application/chat_presence_service.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_room.dart';
import '../viewmodels/chat_room_viewmodel.dart';

class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.roomId,
    required this.room,
  });

  final String roomId;
  final ChatRoom room;

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTyping);
    
    // Start listening to presence and typing immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final presenceService = ref.read(chatPresenceServiceProvider);
      presenceService.joinPresence(widget.room.ownerId);
      presenceService.listenTyping(widget.roomId, widget.room.ownerId);
    });
  }

  void _onTyping() {
    final viewModel = ref.read(chatRoomViewModelProvider(widget.roomId).notifier);
    viewModel.setTyping(_messageController.text.isNotEmpty);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTyping);
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    ref.read(chatRoomViewModelProvider(widget.roomId).notifier)
       .sendMessage(_messageController.text, widget.room.ownerId);
    
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatRoomViewModelProvider(widget.roomId));
    final currentUser = ref.watch(authUserProvider);
    final isOnline = ref.watch(presenceStateProvider(widget.room.ownerId));
    final isTyping = ref.watch(typingStateProvider(widget.roomId));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                widget.room.ownerName?.substring(0, 1).toUpperCase() ?? 'O',
                style: AppTextStyles.labelMedium,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.room.ownerName ?? 'Pemilik', style: AppTextStyles.headingSmall),
                Text(
                  isTyping ? 'Sedang mengetik...' : (isOnline ? 'Online' : 'Offline'),
                  style: AppTextStyles.caption.copyWith(
                    color: isOnline ? AppColors.successLight : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == currentUser?.id;

                return _buildMessageBubble(message, isMe);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    final timeFormat = DateFormat('HH:mm');
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryDark : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : null,
            bottomLeft: !isMe ? const Radius.circular(0) : null,
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeFormat.format(message.createdAt),
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status == MessageStatus.read
                        ? Icons.done_all
                        : (message.status == MessageStatus.delivered
                            ? Icons.done_all
                            : (message.status == MessageStatus.pending 
                                ? Icons.access_time 
                                : Icons.check)),
                    size: 14,
                    color: message.status == MessageStatus.read 
                        ? AppColors.infoLight 
                        : AppColors.textTertiary,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
