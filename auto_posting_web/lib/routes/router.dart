import 'package:auto_posting_web/presentation/admin/admin_page.dart';
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
      final isAdminUser = authNotifier.isAdmin;
      final path = state.matchedLocation;

      // 체크해야 할 페이지들
      final isLoggingIn = path == '/login' || path == '/admin/login';
      final isRegistering = state.matchedLocation == '/register'; // 회원가입 페이지 체크

      // 1. 로그인된 상태에서 로그인/회원가입 시도 시 메인으로
      if (isLoggedIn) {
        if (isLoggingIn || isRegistering) {
          // 관리자라면 관리자 메인으로, 일반 유저라면 일반 메인으로 분기
          return isAdminUser ? '/admin/main' : '/main';
        }
      }

      // 2. 로그인 안 된 상태에서 인증이 필요한 페이지 접근 시 로그인으로
      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        // return '/login';
        return path.contains('admin') ? '/admin/login' : '/login';
      }

      // 그 외에는 가려던 길 가게 둠 (null 반환)
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(isAdmin: false),
      ),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const LoginPage(isAdmin: true),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/main', builder: (context, state) => const MainPage()),
      GoRoute(
        path: '/admin/main',
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: '/proxy_description',
        builder: (context, state) => const ProxyDescriptionPage(),
      ),
    ],
  );
});
