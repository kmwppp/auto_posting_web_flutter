import 'package:auto_posting_web/presentation/login/sections/login_button_section.dart';
import 'package:auto_posting_web/presentation/login/sections/login_input_section.dart';
import 'package:auto_posting_web/presentation/login/widgets/login_appbar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: LoginAppbar(),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [LoginInputSection(), Divider(), LoginButtonSection()],
            ),
          ),
        ),
      ),
    );
  }
}
