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
            onTap: () async {
              // 1. 서버에서 데이터 먼저 가져오기
              await ref
                  .read(adminViewModelProvider.notifier)
                  .getUserSuccessLogs(id: user.id);

              // 2. 바텀 시트 열기 (이제 ref.watch(adminViewModelProvider).successLogs를 사용)
              if (context.mounted) {
                showSuccessHistory(context, user.fullName);
              }
            },
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
                  .sendToServer(id: user.id, status: newStatus);

              if (response) {
                ref
                    .read(adminViewModelProvider.notifier)
                    .updateUserStatus(user.id, newStatus);

                // (선택사항) 성공 메시지 알림
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("상태가 정상적으로 변경되었습니다.")),
                  );
                }
              } else {
                // 3. 실패 시 에러 다이얼로그
                if (context.mounted) _errorDialog(context);
              }

              if (context.mounted) Navigator.pop(context);
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

  void showSuccessHistory(BuildContext context, String fullName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 스크롤 가능하게 높이 조절 허용
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // 1. Consumer 위젯을 사용하여 바텀 시트 안에서 ref를 사용합니다.
        return Consumer(
          builder: (context, ref, child) {
            // 2. ViewModel의 상태를 watch 합니다.
            final adminState = ref.watch(adminViewModelProvider);
            final logs = adminState.userSuccessLogs;
            final maxCount = logs
                .map((e) => e.count)
                .fold(0, (prev, curr) => curr > prev ? curr : prev);
            final displayMax = maxCount > 50
                ? maxCount
                : 50; // 최소 기준은 50으로 잡고, 넘어가면 그에 맞춤

            return FractionallySizedBox(
              heightFactor: 0.7, // 화면 높이의 70% 차지
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 핸들 바 (디자인 요소)
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      "$fullName님의 작업 통계",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. 데이터가 비어있을 때와 있을 때 처리
                    Expanded(
                      child: logs.isEmpty
                          ? const Center(child: Text("작업 기록이 없습니다."))
                          : ListView.separated(
                              itemCount: logs.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                // 최대값 대비 비율 (예: 20건 기준)
                                double progress = (log.count / displayMax)
                                    .clamp(0.0, 1.0);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          log.date,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${log.count}건",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey[200],
                                      color: Colors.blueAccent,
                                      minHeight: 10,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
