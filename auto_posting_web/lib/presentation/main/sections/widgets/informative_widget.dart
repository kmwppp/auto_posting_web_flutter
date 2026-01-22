import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class InformativeWidget extends ConsumerWidget {
  const InformativeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogTitleController = ref.watch(blogTitleControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 26),
        _input(
          context: context,
          inputHint: "AI가 정보성 글을 작성할 주제를 한 줄에 하나씩 입력하세요.",
          controller: blogTitleController,
          boxHeight: 250,
          align: Alignment.topLeft,
        ),
        SizedBox(height: 16),
        Divider(),
      ],
    );
  }

  Widget _input({
    required BuildContext context,
    required String inputHint,
    required TextEditingController controller,
    double boxHeight = 0,
    required AlignmentGeometry align,
  }) {
    // 높이가 설정되어 있다면 여러 줄 입력 모드로 간주합니다.
    final isMultiLine = boxHeight > 0;

    return Container(
      height: isMultiLine ? boxHeight : null,
      decoration: BoxDecoration(
        color: Colors.white,
        // BoxBorder.all 대신 Border.all을 사용해야 에러가 나지 않습니다.
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: align,
      padding: const EdgeInsets.all(14),
      child: TextField(
        controller: controller,
        // 1. 엔터 키를 줄바꿈으로 동작하게 만드는 핵심 설정
        maxLines: isMultiLine ? null : 1,
        minLines: isMultiLine ? null : 1,
        // 2. 컨테이너 높이에 맞춰 텍스트 필드를 확장 (isMultiLine일 때만)
        expands: isMultiLine,
        // 3. 멀티라인용 키보드 타입 설정
        keyboardType: isMultiLine
            ? TextInputType.multiline
            : TextInputType.text,
        // 4. 높은 박스일 경우 텍스트 시작 위치를 상단으로 고정
        textAlignVertical: isMultiLine
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
        ),
        style: context.bodyLarge,
      ),
    );
  }
}

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
