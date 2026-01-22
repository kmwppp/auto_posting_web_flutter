import 'package:flutter/material.dart';

import 'widgets/login_input_widget.dart';

class LoginInputSection extends StatelessWidget {
  const LoginInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        LoginInputWidget(inputTitle: "아이디", inputHint: "아이디를 입력해주세요."),
        LoginInputWidget(inputTitle: "비밀번호", inputHint: "비밀번호를 입력해주세요."),
      ],
    );
  }
}
