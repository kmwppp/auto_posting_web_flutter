import 'package:auto_posting_web/presentation/view/main/sections/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/main/main_provider.dart';

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
    );
  }
}
