import 'package:auto_posting_web/presentation/admin/data/models/admin_user_info.dart';
import 'package:auto_posting_web/presentation/admin/data/models/user_success_log.dart';

class AdminState {
  final List<AdminUserInfo> userList;
  final List<UserSuccessLog> userSuccessLogs;

  const AdminState({required this.userList, required this.userSuccessLogs});

  AdminState copyWith({
    List<AdminUserInfo>? userList,
    List<UserSuccessLog>? userSuccessLogs,
  }) {
    return AdminState(
      userList: userList ?? this.userList,
      userSuccessLogs: userSuccessLogs ?? this.userSuccessLogs,
    );
  }

  factory AdminState.initial() {
    return AdminState(userList: [], userSuccessLogs: []);
  }
}
