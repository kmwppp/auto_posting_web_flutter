import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/auth_provider.dart';
import '../../main_provider.dart';
import 'input_widget.dart';

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
      spacing: 20,
      children: [
        Expanded(
          child: InputWidget(inputHint: "네이버 아이디", controller: idController),
        ),
        Expanded(
          child: InputWidget(inputHint: "네이버 비밀번호", controller: pwController),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              int isAdded = notifier.addUserInfo(
                userId: idController.text,
                userPassword: pwController.text,
                currentUserId: currentUserId,
              );

              // 2. 결과가 false일 경우 알림창(Alert) 띄우기
              if (isAdded != 0) {
                final String msg = switch (isAdded) {
                  1 => "아이디 혹은 비밀번호가 비어있습니다.",
                  2 => "중복된 아이디가 있습니다.",
                  _ => "알 수 없는 오류가 발생했습니다.",
                };
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("계정 추가 실패"),
                    content: Text(msg),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("확인"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "계정 추가",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
