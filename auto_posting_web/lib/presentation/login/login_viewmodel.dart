import 'dart:convert';

import 'package:auto_posting_web/core/di/provider_container.dart';
import 'package:auto_posting_web/presentation/login/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    // TODO: implement build
    return LoginState.initial();
  }

  void changeUserId(String str) {
    state = state.copyWith(userId: str);
  }

  void changeUserPassword(String str) {
    state = state.copyWith(userPassword: str);
  }

  bool isLoginValid() {
    state = state.copyWith(isLoading: true);
    if (state.userId == "jaeyun" || state.userId == "jaeyunTest") {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // 서버로 보낼 JSON 매핑 메소드
  Future<bool> sendToServer() async {
    state = state.copyWith(isLoading: true);
    final user_id = state.userId;
    final password = state.userPassword;

    final Map<String, dynamic> requestData = {
      "user_id": user_id,
      "password": password,
    };

    try {
      final useCase = ref.read(loginDataUseCaseProvider);
      // 1. 서버 통신 실행
      final result = await useCase.execute(requestData);

      // 2. 응답 데이터 처리 (성공 시 보통 200 OK)
      Map<String, dynamic> response;
      if (result is String) {
        response = jsonDecode(result);
      } else {
        response = Map<String, dynamic>.from(result);
      }

      if (response['status'] == 'success') {
        print("✅ 로그인 성공: ${response['message']}");
        state = state.copyWith(isLoading: false);
        return true;
      }
    } on Exception catch (e) {
      // 3. 로그인 실패 처리 (서버에서 401, 404, 500 등을 던진 경우)
      print("❌ 로그인 실패: $e");

      // 사용자에게 보여줄 에러 메시지 처리
      String errorMessage = "로그인 중 오류가 발생했습니다.";

      if (e.toString().contains('401')) {
        errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";
        state = state.copyWith(isLoading: false);
        return false;
      }
    }
    state = state.copyWith(isLoading: false);
    return false;
  }
}
