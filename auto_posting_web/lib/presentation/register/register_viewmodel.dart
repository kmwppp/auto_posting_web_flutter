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
}
