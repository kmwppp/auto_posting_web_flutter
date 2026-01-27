class MainUserInfoModel {
  final bool isPostingCheck;
  final String userId;
  final String userPassword;
  final int postingCount;
  final String proxy_id;
  final String proxy_pw;
  final String port;

  const MainUserInfoModel({
    required this.userId,
    required this.userPassword,
    required this.postingCount,
    required this.isPostingCheck,
    required this.proxy_id,
    required this.proxy_pw,
    required this.port,
  });

  MainUserInfoModel copyWith({
    bool? isPostingCheck,
    String? userId,
    String? userPassword,
    int? postingCount,
    String? proxy_id,
    String? proxy_pw,
    String? port,
  }) {
    return MainUserInfoModel(
      userId: userId ?? this.userId,
      userPassword: userPassword ?? this.userPassword,
      postingCount: postingCount ?? this.postingCount,
      isPostingCheck: isPostingCheck ?? this.isPostingCheck,
      proxy_id: proxy_id ?? this.proxy_id,
      proxy_pw: proxy_pw ?? this.proxy_pw,
      port: port ?? this.port,
    );
  }

  Map<String, dynamic> toJson() => {
    "current_user_id": "1", // 지금은 쓸일 없는데 다음을위해 일단 넣어둠
    "site_name": "Naver", // 지금은 쓸일 없는데 다음을위해 일단 넣어둠
    "external_id": userId,
    "external_pw": userPassword,
    "postingCount": postingCount,
    "proxy_id": proxy_id,
    "proxy_pw": proxy_pw,
    "port": port,
  };
}
