import 'package:go_router/go_router.dart';

import '../presentation/view/main_page.dart';

final goRouter = GoRouter(
  initialLocation: '/main',
  routes: [
    GoRoute(path: '/main', builder: (context, state) => MainPage()),
  ],
);