import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class AutoQRLinkCreate extends ConsumerWidget {
  const AutoQRLinkCreate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 감시
    final isQRLinkChange = ref.watch(
      mainViewModelProvider.select((s) => s.isQRLinkChange),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 섹션 타이틀 (통일된 스타일)
        _sectionTitle(
          context: context,
          title: "QR 링크 자동 변환",
          trailing: Switch(
            value: isQRLinkChange,
            activeColor: Colors.blueGrey[800], // 테마 컬러와 통일
            onChanged: (value) {
              notifier.changeisQRLinkChange(value);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. 설명 문구 스타일링
              Text(
                "워드프레스 링크를 네이버 QR 링크로 자동 변환하여 포스팅의 저품질 위험을 최소화합니다.",
                style: context.body.copyWith(
                  color: Colors.blueGrey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "※ 이 설정은 발행 시 모든 워드프레스 링크에 일괄 적용됩니다.",
                style: context.body.copyWith(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // --- 통일된 섹션 스타일 헬퍼 메서드 ---
  Widget _sectionTitle({
    required BuildContext context,
    required String title,
    Widget? trailing,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border(
          left: BorderSide(color: Colors.blueGrey[800]!, width: 6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.title.copyWith(
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
