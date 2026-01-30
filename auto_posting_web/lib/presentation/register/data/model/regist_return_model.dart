class RegistReturnModel {
  final String msg;
  final int errorCode;

  const RegistReturnModel({required this.msg, required this.errorCode});

  RegistReturnModel copyWith({String? msg, int? errorCode}) {
    return RegistReturnModel(
      msg: msg ?? this.msg,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
