import 'package:auto_posting_web/presentation/admin/data/models/admin_user_info.dart';

class AdminState {
  final List<AdminUserInfo> userList;

  const AdminState({required this.userList});

  AdminState copyWith({List<AdminUserInfo>? userList}) {
    return AdminState(userList: userList ?? this.userList);
  }

  factory AdminState.initial() {
    return AdminState(userList: []);
  }
}
