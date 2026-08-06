/// Route name constants.
///
/// Centralized route names to avoid string duplication across the app.
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String register = 'register';
  static const String waitingApproval = 'waitingApproval';
  static const String chatList = 'chatList';
  static const String chatRoom = 'chatRoom';
}

/// Route path constants.
class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String register = '/register';
  static const String waitingApproval = '/waiting-approval';
  static const String chatList = '/chat';
  static const String chatRoom = 'room/:id';
}
