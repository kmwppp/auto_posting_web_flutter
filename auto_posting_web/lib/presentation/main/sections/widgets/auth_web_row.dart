import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/auth_provider.dart';
import '../../main_provider.dart';

class AuthWebRow extends ConsumerWidget {
  const AuthWebRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.userCurrentId;
    final idController = ref.watch(idControllerProvider);
    final pwController = ref.watch(pwControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 네이버 아이디 입력
        Expanded(
          child: _input(
            context: context,
            inputHint: "네이버 아이디",
            controller: idController,
            align: Alignment.centerLeft,
          ),
        ),
        const SizedBox(width: 12),

        // 네이버 비밀번호 입력
        Expanded(
          child: _input(
            context: context,
            inputHint: "네이버 비밀번호",
            controller: pwController,
            align: Alignment.centerLeft,
            isPassword: true, // 비밀번호 숨김 처리
          ),
        ),
        const SizedBox(width: 12),

        // 계정 추가 버튼
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              onPressed: () {
                int isAdded = notifier.addUserInfo(
                  userId: idController.text,
                  userPassword: pwController.text,
                  currentUserId: currentUserId,
                );

                if (isAdded != 0) {
                  final String msg = switch (isAdded) {
                    1 => "아이디 혹은 비밀번호가 비어있습니다.",
                    2 => "중복된 아이디가 있습니다.",
                    _ => "알 수 없는 오류가 발생했습니다.",
                  };
                  _showErrorDialog(context, msg);
                }
              },
              child: const Text(
                "계정 추가",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- 에러 알림창 ---
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          "계정 추가 실패",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인", style: TextStyle(color: Colors.blueGrey)),
          ),
        ],
      ),
    );
  }

  // --- 통일된 입력 폼 헬퍼 메서드 ---
  Widget _input({
    required BuildContext context,
    required String inputHint,
    TextEditingController? controller,
    required AlignmentGeometry align,
    bool isPassword = false,
  }) {
    return Container(
      height: 50,
      // 다른 버튼들과 높이 통일
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        style: context.body,
      ),
    );
  }
}
