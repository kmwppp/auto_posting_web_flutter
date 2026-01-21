import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../provider/main/main_provider.dart';

class AddAuth extends ConsumerWidget {
  const AddAuth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idController = ref.watch(idControllerProvider);
    final pwController = ref.watch(pwControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("1. 블로그 계정 관리", style: context.title),
        Divider(),
        Text("새 계정 추가", style: context.bodyLarge),
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: _inputUserInfo(
                context: context,
                inputHint: "네이버 아이디",
                controller: idController,
              ),
            ),
            Expanded(
              child: _inputUserInfo(
                context: context,
                inputHint: "네이버 비밀번호",
                controller: pwController,
              ),
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
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text("계정 추가", textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ClipRRect _inputUserInfo({
    required BuildContext context,
    required String inputHint,
    required TextEditingController controller,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: inputHint,
          ),
          style: context.body,
        ),
      ),
    );
  }
}
