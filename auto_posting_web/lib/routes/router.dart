import 'package:auto_posting_web/presentation/register/register_page.dart';
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

      // 현재 가려는 페이지가 어디인지 확인
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register'; // 회원가입 페이지 체크

      // 1. 로그인된 상태인데 로그인이나 회원가입 페이지에 가려고 하면 -> 메인으로
      if (isLoggedIn) {
        if (isLoggingIn || isRegistering) return '/main';
      }

      // 2. 로그인 안 된 상태인데
      if (!isLoggedIn) {
        // 로그인 페이지도 아니고, 회원가입 페이지도 아니면 -> 로그인으로 튕겨라
        // (즉, 회원가입 페이지는 그냥 통과시켜줌)
        if (!isLoggingIn && !isRegistering) {
          return '/login';
        }
      }

      // 그 외에는 가려던 길 가게 둠 (null 반환)
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/main', builder: (context, state) => const MainPage()),
      GoRoute(
        path: '/proxy_description',
        builder: (context, state) => const ProxyDescriptionPage(),
      ),
    ],
  );
});
