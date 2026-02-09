import 'package:auto_posting_web/routes/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_provider.dart';
import 'input_widget.dart';

class AuthMobileColumn extends ConsumerWidget {
  const AuthMobileColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.userCurrentId;
    final idController = ref.watch(idControllerProvider);
    final pwController = ref.watch(pwControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      spacing: 4,
      children: [
        InputWidget(inputHint: "네이버 아이디", controller: idController),
        InputWidget(inputHint: "네이버 비밀번호", controller: pwController),
        GestureDetector(
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
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Text("계정 추가", textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }
}
