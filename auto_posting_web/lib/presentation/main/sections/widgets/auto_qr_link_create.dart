import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class AutoQRLinkCreate extends ConsumerWidget {
  const AutoQRLinkCreate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 상태 읽기 (isAiEnabled만 감시)
    final isQRLinkChange = ref.watch(
      mainViewModelProvider.select((s) => s.isQRLinkChange),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text("QR 링크 자동 변환", style: context.bodyLarge)),
            // 2. Switch 위젯 배치
            Switch(
              value: isQRLinkChange,
              activeColor: Colors.blueAccent, // 켜졌을 때 색상
              onChanged: (value) {
                // 3. 상태 변경 요청
                notifier.changeisQRLinkChange(value);
              },
            ),
          ],
        ),
        Text(
          "워드프레스 링크를 네이버 QR 링크로 바꿔 저품질 위험을 줄입니다.",
          style: context.body.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
