class AdminUserInfo {
  final int id;
  final String userId;
  final String fullName;
  final int status;

  AdminUserInfo({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.status,
  });

  // JSON 데이터를 객체로 변환
  factory AdminUserInfo.fromJson(Map<String, dynamic> json) {
    return AdminUserInfo(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      status: json['status'],
    );
  }
}
