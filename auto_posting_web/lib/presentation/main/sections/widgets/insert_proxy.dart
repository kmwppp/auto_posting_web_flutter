import 'package:auto_posting_web/presentation/main/sections/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class InsertProxy extends ConsumerWidget {
  const InsertProxy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 상태 읽기 (isAiEnabled만 감시)
    final isProxySetting = ref.watch(
      mainViewModelProvider.select((s) => s.isProxySetting),
    );

    final proxyController = ref.watch(proxyUrlControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text("프록시 설정", style: context.bodyLarge)),
            // 2. Switch 위젯 배치
            Switch(
              value: isProxySetting,
              activeColor: Colors.blueAccent, // 켜졌을 때 색상
              onChanged: (value) {
                // 3. 상태 변경 요청
                notifier.changeIsProxySetting(value);
              },
            ),
          ],
        ),

        if (isProxySetting)
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "구매하신 프록시의 IP를 입력하세요.",
                style: context.body.copyWith(color: Colors.grey),
              ),
              InputWidget(
                inputHint: "프록시 IP을 입력하세요.",
                controller: proxyController,
              ),
            ],
          ),
      ],
    );
  }
}
