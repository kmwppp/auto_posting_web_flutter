class MainUserInfoModel {
  final bool isPostingCheck;
  final String userId;
  final String userPassword;
  final int postingCount;

  const MainUserInfoModel({
    required this.userId,
    required this.userPassword,
    required this.postingCount,
    required this.isPostingCheck,
  });

  MainUserInfoModel copyWith({
    bool? isPostingCheck,
    String? userId,
    String? userPassword,
    int? postingCount,
  }) {
    return MainUserInfoModel(
      userId: userId ?? this.userId,
      userPassword: userPassword ?? this.userPassword,
      postingCount: postingCount ?? this.postingCount,
      isPostingCheck: isPostingCheck ?? this.isPostingCheck,
    );
  }
}
