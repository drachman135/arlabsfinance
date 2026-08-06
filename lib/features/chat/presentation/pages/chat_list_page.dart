import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../viewmodels/chat_list_viewmodel.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsAsync = ref.watch(chatListStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Chat', style: AppTextStyles.headingLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: chatRoomsAsync.when(
        data: (rooms) {
          if (rooms.isEmpty) {
            return Center(
              child: Text(
                'Belum ada percakapan',
                style: AppTextStyles.bodyLarge,
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              final timeFormat = DateFormat('HH:mm');
              final formattedTime = room.lastMessageTime != null 
                  ? timeFormat.format(room.lastMessageTime!)
                  : '';

              return AppCard(
                backgroundColor: AppColors.surface,
                borderColor: AppColors.border,
                margin: const EdgeInsets.only(bottom: 8),
                onTap: () {
                  context.push('/chat/${room.id}', extra: room);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primarySurface,
                      child: Text(
                        room.ownerName?.substring(0, 1).toUpperCase() ?? 'O',
                        style: AppTextStyles.headingMedium,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                room.ownerName ?? 'Owner',
                                style: AppTextStyles.headingSmall,
                              ),
                              Text(
                                formattedTime,
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  room.lastMessage ?? 'Belum ada pesan',
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (room.unreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${room.unreadCount}',
                                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
        ),
      ),
    );
  }
}
