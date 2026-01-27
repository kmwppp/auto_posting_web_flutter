import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/register/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../login/sections/widgets/login_input_widget.dart';

class RegisterInputSection extends ConsumerWidget {
  const RegisterInputSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
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
        SizedBox(height: 6),
        LoginInputWidget(
          inputTitle: "비밀번호 확인",
          inputHint: "비밀번호를 한번 더 입력해주세요.",
          onChanged: (value) {
            notifier.changeUserPasswordConfirm(value);
          },
        ),
        if (!state.isSamePassword)
          Text(
            "비밀번호가 일치하지 않습니다.",
            style: context.caption.copyWith(color: Colors.red),
          ),

        SizedBox(height: 6),
        LoginInputWidget(
          inputTitle: "이름",
          inputHint: "이름을 입력해주세요.",
          onChanged: (value) {
            notifier.changeUserName(value);
          },
        ),
        SizedBox(height: 6),
        LoginInputWidget(
          inputTitle: "전화번호",
          inputHint: "전화번호를 입력해주세요.",
          onChanged: (value) {
            notifier.changePhoneNumber(value);
          },
        ),
      ],
    );
  }
}
