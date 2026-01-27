class LoginState {
  final String userId;
  final String userPassword;
  final bool isLoading;

  const LoginState({
    required this.userId,
    required this.userPassword,
    required this.isLoading,
  });

  LoginState copyWith({String? userId, String? userPassword, bool? isLoading}) {
    return LoginState(
      userId: userId ?? this.userId,
      userPassword: userPassword ?? this.userPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory LoginState.initial() {
    return LoginState(userId: "", userPassword: "", isLoading: false);
  }
}
