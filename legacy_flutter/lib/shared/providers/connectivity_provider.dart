import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/connectivity_service.dart';

/// Provider for the connectivity service instance.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService.instance;
});

/// Stream provider for connectivity state changes.
final connectivityStateProvider =
    StreamProvider<ConnectivityState>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onStateChanged;
});

/// Provider for the current connectivity state.
final isOnlineProvider = Provider<bool>((ref) {
  final asyncState = ref.watch(connectivityStateProvider);
  return asyncState.whenOrNull(data: (state) => state == ConnectivityState.online) ?? true;
});
