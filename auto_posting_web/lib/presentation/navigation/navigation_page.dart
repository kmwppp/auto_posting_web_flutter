// lib/presentation/navigation/navigation_page.dart
import 'package:auto_posting_web/presentation/wordpress/presentation/screens/wordpress_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/auth_provider.dart';
import '../main/main_page.dart';
import 'navigation_controller.dart';

class NavigationPage extends ConsumerWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 페이지 상태 구독
    final currentPage = ref.watch(navigationProvider);
    final notifier = ref.read(navigationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentPage == NavPage.naver ? "네이버 포스팅 자동화" : "워드프레스 포스팅 자동화",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[900]),
              accountName: const Text(
                "시피 자동화 시스템",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text("v1.1.0 (Active)"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.auto_awesome, color: Colors.blueGrey),
              ),
            ),
            // 네이버 메뉴
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("네이버 포스팅 자동화"),
              selected: currentPage == NavPage.naver,
              onTap: () {
                notifier.setPage(NavPage.naver);
                Navigator.pop(context); // Drawer 닫기
              },
            ),
            // 워드프레스 메뉴
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("워드프레스 포스팅 자동화"),
              selected: currentPage == NavPage.wordpress,
              onTap: () {
                final authState = ref.read(authStateProvider);
                final int? userIdInt = authState.userCurrentId;
                if ([11, 12, 29, 30].contains(userIdInt)) {
                  notifier.setPage(NavPage.wordpress);
                  Navigator.pop(context); // Drawer 닫기
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("워드프레스"),
                      content: Text("테스트 중입니다."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("확인"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      // ✨ IndexedStack: 페이지를 메모리에 유지하면서 화면만 전환
      body: IndexedStack(
        index: currentPage.index,
        children: [
          const MainPage(), // index 0
          WordpressPage(), // index 1
        ],
      ),
    );
  }
}
