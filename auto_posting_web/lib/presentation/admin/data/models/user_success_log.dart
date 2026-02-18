class UserSuccessLog {
  final String date;
  final int count;

  UserSuccessLog({required this.date, required this.count});

  factory UserSuccessLog.fromJson(Map<String, dynamic> json) {
    return UserSuccessLog(date: json['date'], count: json['count']);
  }
}
