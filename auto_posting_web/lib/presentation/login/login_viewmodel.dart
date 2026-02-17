import 'dart:convert';

import 'package:auto_posting_web/core/di/provider_container.dart';
import 'package:auto_posting_web/presentation/login/data/model/login_return_model.dart';
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
  Future<LoginReturnModel> sendToServer({required bool isAdmin}) async {
    state = state.copyWith(isLoading: true);
    final user_id = state.userId;
    final password = state.userPassword;

    if (user_id == "") {
      state = state.copyWith(isLoading: false);
      return LoginReturnModel(
        msg: "아이디를 입력해주세요.",
        errorCode: 5,
        userCurrentId: 0,
      );
    }

    if (password == "") {
      state = state.copyWith(isLoading: false);
      return LoginReturnModel(
        msg: "비밀번호를 입력해주세요.",
        errorCode: 5,
        userCurrentId: 0,
      );
    }

    final Map<String, dynamic> requestData = {
      "user_id": user_id,
      "password": password,
    };

    try {
      final useCase = ref.read(loginDataUseCaseProvider);
      // 1. 서버 통신 실행
      final result = await useCase.execute(requestData, isAdmin);

      // 2. 응답 데이터 처리 (성공 시 보통 200 OK)
      Map<String, dynamic> response;
      if (result is String) {
        response = jsonDecode(result);
      } else {
        response = Map<String, dynamic>.from(result);
      }
      state = state.copyWith(isLoading: false);
      if (response['status'] == 'success') {
        print("✅ 로그인 성공: ${response['message']}");
        // 1. 서버 응답에서 ID 추출
        final rawId = response['user_id'];
        // 2. int로 변환 (안전하게 tryParse 사용)
        final int userCurrentId = int.tryParse(rawId.toString()) ?? 0;
        return LoginReturnModel(
          msg: "로그인에 성공하였습니다.",
          errorCode: 0,
          userCurrentId: userCurrentId,
        );
      } else {
        // fail / error 인 경우 error code를 보고 리턴
        // 등록된 계정이 없는 경우
        final errorCode = response['error_code'];
        switch (errorCode) {
          case '01':
            return LoginReturnModel(
              msg: "등록된 계정이 없습니다.",
              errorCode: 1,
              userCurrentId: 0,
            );
          case '02':
            return LoginReturnModel(
              msg: "아이디 또는 비밀번호가 일치하지 않습니다.",
              errorCode: 2,
              userCurrentId: 0,
            );
          case '03':
            return LoginReturnModel(
              msg: "해당 계정은 가입 승인 대기중입니다.",
              errorCode: 3,
              userCurrentId: 0,
            );
          case '04':
            return LoginReturnModel(
              msg: "해당 계정은 사용 정지중입니다.",
              errorCode: 4,
              userCurrentId: 0,
            );
        }
        return LoginReturnModel(
          msg: "등록된 계정이 없습니다.",
          errorCode: 1,
          userCurrentId: 0,
        );
      }
    } on Exception catch (e) {
      print("❌ 로그인 실패: $e");
      state = state.copyWith(isLoading: false);
      return LoginReturnModel(
        msg: "알 수 없는 오류가 발생하였습니다.",
        errorCode: 5,
        userCurrentId: 0,
      );
    }
  }
}
