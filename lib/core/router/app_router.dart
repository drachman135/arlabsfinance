import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_room_page.dart';
import '../../features/chat/domain/entities/chat_room.dart';
import '../../features/home/presentation/dashboard_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import 'route_names.dart';

/// Provider for the application router.
/// Rebuilds the router when authentication state changes.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateStreamProvider).value;

  return GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuth = authState?.session != null;
      final isSplash = state.matchedLocation == RoutePaths.splash;
      final isLogin = state.matchedLocation == RoutePaths.login;

      // Splash page handles its own navigation via Future.delayed.
      if (isSplash) return null;

      // If not authenticated and not on login page, redirect to login
      if (!isAuth && !isLogin) {
        return RoutePaths.login;
      }

      // If authenticated and trying to access login, redirect to dashboard
      if (isAuth && isLogin) {
        return RoutePaths.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: RoutePaths.chatList,
        name: RouteNames.chatList,
        builder: (context, state) => const ChatListPage(),
        routes: [
          GoRoute(
            path: RoutePaths.chatRoom,
            name: RouteNames.chatRoom,
            builder: (context, state) {
              final roomId = state.pathParameters['id']!;
              final room = state.extra as ChatRoom;
              return ChatRoomPage(roomId: roomId, room: room);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
});

/// Error page for invalid routes.
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
