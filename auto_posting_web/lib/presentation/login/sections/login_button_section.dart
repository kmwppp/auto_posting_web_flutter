import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/auth_provider.dart';

class LoginButtonSection extends ConsumerWidget {
  const LoginButtonSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final state = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () async {
            // ref.read(authStateProvider).login(userCurrentId: 1);
            if (!isAdmin) {
              final response = await notifier.sendToServer(isAdmin: isAdmin);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("로그인"),
                  content: Text(response.msg),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (response.errorCode == 0) {
                          ref
                              .read(authStateProvider)
                              .login(
                                userCurrentId: response.userCurrentId,
                                isAdmin: isAdmin,
                              );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("확인"),
                    ),
                  ],
                ),
              );
            } else {
              ref
                  .read(authStateProvider)
                  .login(userCurrentId: 1, isAdmin: isAdmin);
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
                    "로그인",
                    textAlign: TextAlign.center,
                    style: context.bodyLarge.copyWith(color: Colors.white),
                  ),
          ),
        ),

        if (!isAdmin)
          GestureDetector(
            onTap: () {
              context.push('/register');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              child: Text(
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
