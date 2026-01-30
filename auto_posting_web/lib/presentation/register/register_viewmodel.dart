import 'dart:convert';

import 'package:auto_posting_web/core/di/provider_container.dart';
import 'package:auto_posting_web/presentation/register/data/model/regist_return_model.dart';
import 'package:auto_posting_web/presentation/register/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/util/util.dart';

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

  RegistReturnModel _inputEmptyValidation({
    required String userId,
    required String password,
    required String userName,
    required String phoneNum,
  }) {
    if (userId == "") {
      return RegistReturnModel(msg: "아이디를 입력해주세요.", errorCode: 1);
    }

    if (password == "") {
      return RegistReturnModel(msg: "비밀번호를 입력해주세요.", errorCode: 1);
    }

    if (state.userPasswordConfirm == "") {
      return RegistReturnModel(msg: "비밀번호 확인을 입력해주세요.", errorCode: 1);
    }

    if (userName == "") {
      return RegistReturnModel(msg: "이름을 입력해주세요.", errorCode: 1);
    }

    if (phoneNum == "") {
      return RegistReturnModel(msg: "전화번호를 입력해주세요.", errorCode: 1);
    }

    if (phoneNum.length != 11) {
      return RegistReturnModel(msg: "전화번호가 11자리가 아닙니다.", errorCode: 1);
    }

    if (!state.isSamePassword) {
      return RegistReturnModel(msg: "비밀번호가 일치하지 않습니다.", errorCode: 1);
    }

    return RegistReturnModel(msg: "서버로 전송합니다.", errorCode: 0);
  }

  // 서버로 보낼 JSON 매핑 메소드
  Future<RegistReturnModel> sendToServer() async {
    state = state.copyWith(isLoading: true);
    final userId = state.userId;
    final password = state.userPassword;
    final userName = state.userName;
    var phoneNumber = state.phoneNumber;

    phoneNumber = Util.phoneNumberSet(phoneNumber);

    final valid = _inputEmptyValidation(
      userId: userId,
      password: password,
      userName: userName,
      phoneNum: phoneNumber,
    );

    if (valid.errorCode == 1) {
      state = state.copyWith(isLoading: false);
      return valid;
    }

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
          return RegistReturnModel(
            msg: "회원가입 신청을 하였습니다. 관리자에게 문의하여 승인을 받아주세요.",
            errorCode: 0,
          );
        case "fail":
          return RegistReturnModel(msg: "현재 가입된 아이디가 있습니다.", errorCode: 1);
        case "error":
          return RegistReturnModel(msg: "알 수 없는 에러가 발생하였습니다.", errorCode: 1);
      }
    } on Exception catch (e) {
      // 3. 로그인 실패 처리 (서버에서 401, 404, 500 등을 던진 경우)
      print("❌ 회원가입 실패: $e");
    }
    state = state.copyWith(isLoading: false);
    return RegistReturnModel(msg: "알 수 없는 에러가 발생하였습니다.", errorCode: 1);
  }
}
