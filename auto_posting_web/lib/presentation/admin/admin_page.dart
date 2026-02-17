import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_provider.dart';
import 'data/models/admin_user_info.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 뷰모델의 상태(AdminState)를 관찰합니다.
    final adminState = ref.watch(adminViewModelProvider);
    final userList = adminState.userList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "관리자 페이지",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black12,
      ),
      body: ListView.separated(
        itemCount: userList.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final user = userList[index];
          return ListTile(
            leading: _buildStatusChip(user.status),
            title: Text("${user.fullName} (${user.userId})"),
            subtitle: const Text("가입일: 2024-05-20"),
            trailing: DropdownButton<int>(
              value: user.status,
              items: const [
                DropdownMenuItem(value: 0, child: Text("대기")),
                DropdownMenuItem(value: 1, child: Text("승인")),
                DropdownMenuItem(value: 2, child: Text("정지")),
              ],
              onChanged: (newStatus) {
                if (newStatus != null && newStatus != user.status) {
                  // 2. 다이얼로그 호출 시 ref를 전달합니다.
                  _showConfirmDialog(context, ref, user, newStatus);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    AdminUserInfo user,
    int newStatus,
  ) {
    String statusName = newStatus == 1 ? "승인" : (newStatus == 2 ? "정지" : "대기");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("상태 변경 확인"),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "${user.fullName}님의 상태를 ["),
              TextSpan(
                text: statusName,
                style: const TextStyle(
                  color: Colors.red, // 빨간색으로 지정
                  fontWeight: FontWeight.bold, // 강조를 위해 볼드 처리
                ),
              ),
              const TextSpan(text: "](으)로 변경하시겠습니까?"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          ElevatedButton(
            onPressed: () async {
              bool response = await ref
                  .read(adminViewModelProvider.notifier)
                  .sendToServer(id: user.id, status: user.status);

              if (response) {
                ref
                    .read(adminViewModelProvider.notifier)
                    .updateUserStatus(user.id, newStatus);
              } else {
                _errorDialog(context);
              }

              Navigator.pop(context);
            },
            child: const Text("변경하기"),
          ),
        ],
      ),
    );
  }

  void _errorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("상태 변경 확인"),
        content: Text("알수없는 오류가 발생하였습니다."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(int status) {
    String label;
    Color color;
    switch (status) {
      case 1:
        label = "승인";
        color = Colors.green;
        break;
      case 2:
        label = "정지";
        color = Colors.red;
        break;
      default:
        label = "대기";
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }
}
