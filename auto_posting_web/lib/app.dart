import 'package:auto_posting_web/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidget으로 변경하여 ref를 쓸 수 있게 만듭니다.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 라우터를 리버팟 프로바이더로부터 읽어옵니다.
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router, // 전역 goRouter 대신 프로바이더의 router 사용
    );
  }
}
