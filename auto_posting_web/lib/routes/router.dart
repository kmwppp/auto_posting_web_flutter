import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/description/proxy_description_page.dart';
import '../presentation/login/login_page.dart';
import '../presentation/main/main_page.dart';
import 'auth_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authStateProvider); // AuthProvider 감시

  return GoRouter(
    refreshListenable: authNotifier,
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';

      if (isLoggedIn && isLoggingIn) return '/main';
      if (!isLoggedIn && !isLoggingIn) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/main', builder: (context, state) => const MainPage()),
      GoRoute(
        path: '/proxy_description',
        builder: (context, state) => const ProxyDescriptionPage(),
      ),
    ],
  );
});
