import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/app_logger.dart';

/// Network connectivity state.
enum ConnectivityState {
  online,
  offline,
}

/// Service that monitors internet connectivity.
///
/// Wraps Connectivity Plus to provide a stream of online/offline states.
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService _instance = ConnectivityService._();
  static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  final StreamController<ConnectivityState> _controller =
      StreamController<ConnectivityState>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream of connectivity state changes.
  Stream<ConnectivityState> get onStateChanged => _controller.stream;

  ConnectivityState _currentState = ConnectivityState.online;

  /// Current connectivity state.
  ConnectivityState get currentState => _currentState;

  /// Whether the device is currently online.
  bool get isOnline => _currentState == ConnectivityState.online;

  /// Initialize connectivity monitoring.
  Future<void> init() async {
    // Check initial state
    final results = await _connectivity.checkConnectivity();
    _updateState(results);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateState,
      onError: (error) {
        AppLogger.error('Connectivity monitoring error', error: error);
      },
    );

    AppLogger.info('Connectivity service initialized: $_currentState');
  }

  void _updateState(List<ConnectivityResult> results) {
    final newState = _mapToState(results);

    if (newState != _currentState) {
      _currentState = newState;
      _controller.add(_currentState);
      AppLogger.info('Connectivity changed: $_currentState');
    }
  }

  ConnectivityState _mapToState(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return ConnectivityState.offline;
    }
    return ConnectivityState.online;
  }

  /// Check current connectivity (one-shot).
  Future<ConnectivityState> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    return _mapToState(results);
  }

  /// Dispose the subscription.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
