import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_provider.dart';
import 'input_widget.dart';

class AuthMobileColumn extends ConsumerWidget {
  const AuthMobileColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ],
    );
  }
}
