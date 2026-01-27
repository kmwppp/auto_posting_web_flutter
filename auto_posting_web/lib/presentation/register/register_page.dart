import 'package:auto_posting_web/presentation/register/sections/register_button_section.dart';
import 'package:auto_posting_web/presentation/register/sections/register_input_section.dart';
import 'package:flutter/material.dart';

import '../login/widgets/login_appbar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: LoginAppbar(),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RegisterInputSection(),
                Divider(),
                RegisterButtonSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
