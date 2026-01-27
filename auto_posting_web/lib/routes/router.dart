import 'package:go_router/go_router.dart';

import '../presentation/description/proxy_description_page.dart';
import '../presentation/login/login_page.dart';
import '../presentation/main/main_page.dart';

final goRouter = GoRouter(
  initialLocation: '/main',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/main', builder: (context, state) => MainPage()),
    GoRoute(
      path: '/proxy_description',
      builder: (context, state) => ProxyDescriptionPage(),
    ),
  ],
);
