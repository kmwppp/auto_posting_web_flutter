import 'dart:convert';

import 'package:auto_posting_web/core/di/provider_container.dart';
import 'package:auto_posting_web/presentation/register/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterViewModel extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    // TODO: implement build
    return RegisterState.initial();
  }

  void changeUserId(String str) {
    state = state.copyWith(userId: str);
  }

  void changeUserPassword(String str) {
    state = state.copyWith(userPassword: str);
  }

  void changeUserPasswordConfirm(String str) {
    state = state.copyWith(userPasswordConfirm: str);
    if (state.userPassword == state.userPasswordConfirm) {
      state = state.copyWith(isSamePassword: true);
    } else {
      if (state.userPasswordConfirm == "") {
        state = state.copyWith(isSamePassword: true);
        return;
      }
      state = state.copyWith(isSamePassword: false);
    }
  }

  void changeUserName(String str) {
    state = state.copyWith(userName: str);
  }

  void changePhoneNumber(String str) {
    state = state.copyWith(phoneNumber: str);
  }

  // 서버로 보낼 JSON 매핑 메소드
  Future<int> sendToServer() async {
    state = state.copyWith(isLoading: true);
    final userId = state.userId;
    final password = state.userPassword;
    final userName = state.userName;
    final phoneNumber = state.phoneNumber;

    final Map<String, dynamic> requestData = {
      "user_id": userId,
      "password": password,
      "name": userName,
      "phoneNum": phoneNumber,
    };

    try {
      final useCase = ref.read(registDataUseCaseProvider);
      // 1. 서버 통신 실행
      final result = await useCase.execute(requestData);

      // 2. 응답 데이터 처리 (성공 시 보통 200 OK)
      Map<String, dynamic> response;
      if (result is String) {
        response = jsonDecode(result);
      } else {
        response = Map<String, dynamic>.from(result);
      }

      final status = response['status'];
      final errorCode = response['error_code'];
      final message = response['message'];
      state = state.copyWith(isLoading: false);
      switch (status) {
        case "success":
          return 0;
        case "fail":
          return 1;
        case "error":
          return 2;
      }
    } on Exception catch (e) {
      // 3. 로그인 실패 처리 (서버에서 401, 404, 500 등을 던진 경우)
      print("❌ 회원가입 실패: $e");
    }
    state = state.copyWith(isLoading: false);
    return 2;
  }
}
