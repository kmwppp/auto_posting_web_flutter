import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavPage { naver, wordpress }

class NavigationController extends Notifier<NavPage> {
  @override
  NavPage build() => NavPage.naver; // 초기값: 네이버

  void setPage(NavPage page) {
    state = page;
  }
}

// 프로바이더 선언
final navigationProvider = NotifierProvider<NavigationController, NavPage>(() {
  return NavigationController();
});
