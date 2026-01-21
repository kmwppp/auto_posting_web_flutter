import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../provider/main/main_provider.dart';

class UserInfoRow extends ConsumerWidget {
  const UserInfoRow({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final user = state.userInfoList[index];
    final notifier = ref.read(mainViewModelProvider.notifier);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: user.isPostingCheck,
                onChanged: (v) {
                  // 3. 체크박스를 누르면 Notifier의 상태 변경 함수를 호출합니다.
                  // null 체크(v!) 후, index를 전달합니다.
                  notifier.userCheckChange(index: index);
                },
              ),
              Text(
                "ID: ${state.userInfoList[index].userId} / PW: ${state.userInfoList[index].userPassword}",
                style: context.bodyLarge,
              ),
            ],
          ),
        ),
        Row(
          spacing: 10,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 100,
                height: 40,
                color: Colors.white,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: context.bodyLarge,
                ),
              ),
            ),
            Text("개", style: context.bodyLarge),
          ],
        ),
      ],
    );
  }
}
