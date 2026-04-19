import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  int? userCurrentId;
  bool _isAdmin = false;

  bool get isLoggedIn => _isLoggedIn;

  bool get isAdmin => _isAdmin;

  // 앱 시작 시 로그인 상태 초기화 (예: SharedPreferences에서 토큰 읽기)
  Future<void> checkLoginStatus() async {
    // 임시로 딜레이 후 로직 처리 (실제로는 로컬 DB나 SecureStorage 확인)
    await Future.delayed(Duration(seconds: 1));
    // _isLoggedIn = 토큰이 있으면 true;
    notifyListeners();
  }

  // 로그인 성공 시 호출
  void login({required int userCurrentId, required bool isAdmin}) {
    _isLoggedIn = true;
    _isAdmin = isAdmin;
    this.userCurrentId = userCurrentId;
    notifyListeners(); // 중요: 이걸 호출해야 라우터가 반응함
  }

  // 로그아웃 시 호출
  void logout() {
    _isLoggedIn = false;
    _isAdmin = false; // ★ 로그아웃 시 초기화
    notifyListeners();
  }
}

// 💡 리버팟용 전역 프로바이더 선언
final authStateProvider = ChangeNotifierProvider((ref) => AuthProvider());
