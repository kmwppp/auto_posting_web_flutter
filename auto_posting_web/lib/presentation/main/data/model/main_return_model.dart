class MainReturnModel {
  final String msg;
  final int errorCode;

  const MainReturnModel({required this.msg, required this.errorCode});

  MainReturnModel copyWith({String? msg, int? errorCode}) {
    return MainReturnModel(
      msg: msg ?? this.msg,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
