class RegisterState {
  final String userId;
  final String userPassword;
  final String userPasswordConfirm;
  final bool isSamePassword;
  final String userName;
  final String phoneNumber;
  final String openAiKey;
  final bool isLoading;

  const RegisterState({
    required this.userId,
    required this.userPassword,
    required this.userPasswordConfirm,
    required this.isSamePassword,
    required this.userName,
    required this.phoneNumber,
    required this.openAiKey,
    required this.isLoading,
  });

  RegisterState copyWith({
    String? userId,
    String? userPassword,
    String? userPasswordConfirm,
    bool? isSamePassword,
    String? userName,
    String? phoneNumber,
    String? openAiKey,
    bool? isLoading,
  }) {
    return RegisterState(
      userId: userId ?? this.userId,
      userPassword: userPassword ?? this.userPassword,
      userPasswordConfirm: userPasswordConfirm ?? this.userPasswordConfirm,
      isSamePassword: isSamePassword ?? this.isSamePassword,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      openAiKey: openAiKey ?? this.openAiKey,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory RegisterState.initial() {
    return RegisterState(
      userId: '',
      userPassword: '',
      userPasswordConfirm: '',
      isSamePassword: true,
      userName: '',
      phoneNumber: '',
      openAiKey: '',
      isLoading: false,
    );
  }
}
