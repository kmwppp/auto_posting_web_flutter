import 'package:auto_posting_web/presentation/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../routes/auth_provider.dart';

class RegisterButtonSection extends ConsumerWidget {
  const RegisterButtonSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () {
            if (notifier.isLoginValid()) {
              // 이제 context 에러(ProviderNotFoundException)에서 완전히 해방됩니다.
              ref.read(authStateProvider).login();
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("회원가입"),
                  content: Text("회원가입을 신청했습니다."),
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
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: state.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "회원가입",
                    textAlign: TextAlign.center,
                    style: context.bodyLarge.copyWith(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
