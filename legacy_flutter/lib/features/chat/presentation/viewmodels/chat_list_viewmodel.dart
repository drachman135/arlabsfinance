import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../domain/entities/chat_room.dart';
import '../../data/repositories/chat_repository_impl.dart';

/// StreamProvider exposing the list of ChatRooms for the logged-in client.
final chatListStreamProvider = StreamProvider.autoDispose<List<ChatRoom>>((ref) {
  final user = ref.watch(authUserProvider);
  if (user == null) {
    return Stream.value([]);
  }
  
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchChatRooms(user.id);
});
