import 'package:auto_posting_web/presentation/register/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';

class RegisterButtonSection extends ConsumerWidget {
  const RegisterButtonSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () async {
            // 0: 회원가입 성공 / 1: 이미가입한 아이디 존재 / 2: 에러
            final status = await notifier.sendToServer();
            String msg = "";
            switch (status) {
              case 0:
                msg = "회원가입 신청을 완료했습니다. 관리자에게 연락하여 승인을 받아주세요.";
                break;
              case 1:
                msg = "이미 가입된 정보가 있습니다.";
                break;
              case 2:
                msg = "알 수 없는 에러가 발생하였습니다.";
                break;
            }

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("회원가입"),
                content: Text(msg),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("확인"),
                  ),
                ],
              ),
            );
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
