class BlogCredentialModel {
  final int currentUserId;
  final String loginId;
  final String loginPw;
  final String proxyId;
  final String proxyPw;
  final String proxyPort;

  BlogCredentialModel({
    required this.currentUserId,
    required this.loginId,
    required this.loginPw,
    required this.proxyId,
    required this.proxyPw,
    required this.proxyPort,
  });

  factory BlogCredentialModel.fromJson(Map<String, dynamic> json) {
    return BlogCredentialModel(
      // 서버에서 내려오는 키값(owner_id)을 모델의 변수명과 매핑
      currentUserId: json['owner_id'] ?? 0,
      loginId: json['login_id'] ?? '',
      loginPw: json['login_pw'] ?? '',
      proxyId: json['proxy_id'] ?? '',
      proxyPw: json['proxy_pw'] ?? '',
      proxyPort: json['proxy_port'] ?? '',
    );
  }
}
