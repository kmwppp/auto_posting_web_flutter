class LoginReturnModel {
  final String msg;
  final int errorCode;
  final int userCurrentId;

  const LoginReturnModel({
    required this.msg,
    required this.errorCode,
    required this.userCurrentId,
  });

  LoginReturnModel copyWith({String? msg, int? errorCode, int? userCurrentId}) {
    return LoginReturnModel(
      msg: msg ?? this.msg,
      errorCode: errorCode ?? this.errorCode,
      userCurrentId: userCurrentId ?? this.userCurrentId,
    );
  }
}
