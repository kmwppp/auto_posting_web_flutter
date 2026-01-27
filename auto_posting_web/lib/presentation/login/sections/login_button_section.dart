import 'package:auto_posting_web/presentation/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/auth_provider.dart';

class LoginButtonSection extends ConsumerWidget {
  const LoginButtonSection({super.key});

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
                  title: const Text("로그인"),
                  content: Text("로그인 정보가 없습니다."),
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
                : Text("로그인", textAlign: TextAlign.center),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 40,
          alignment: Alignment.center,
          child: Text("회원가입", textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
