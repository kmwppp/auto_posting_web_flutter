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
}
