import 'package:auto_posting_web/presentation/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/login_input_widget.dart';

class LoginInputSection extends ConsumerWidget {
  const LoginInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(loginViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        LoginInputWidget(
          inputTitle: "아이디",
          inputHint: "아이디를 입력해주세요.",
          onChanged: (value) {
            notifier.changeUserId(value);
          },
        ),
        SizedBox(height: 6),
        LoginInputWidget(
          inputTitle: "비밀번호",
          inputHint: "비밀번호를 입력해주세요.",
          onChanged: (value) {
            notifier.changeUserPassword(value);
          },
        ),
      ],
    );
  }
}
