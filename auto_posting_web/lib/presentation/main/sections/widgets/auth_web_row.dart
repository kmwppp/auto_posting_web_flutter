import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_provider.dart';
import 'input_widget.dart';

class AuthWebRow extends ConsumerWidget {
  const AuthWebRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              notifier.addUserInfo(
                userId: idController.text,
                userPassword: pwController.text,
              );
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
