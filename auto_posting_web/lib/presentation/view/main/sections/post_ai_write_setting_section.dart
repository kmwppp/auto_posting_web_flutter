import 'package:auto_posting_web/presentation/provider/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';

class PostAIWriteSettingSection extends ConsumerWidget {
  const PostAIWriteSettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiWriteOrderController = ref.watch(aiwriteOrderControllerProvider);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AI 모델 선택", style: context.bodyLarge),
            Text(
              "* AI 모델 선택란이었으나, 초기는 Chatgpt 4.0 mini로 우선 제작",
              style: context.body.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 14),
            Text("AI 글쓰기 지침", style: context.bodyLarge),
            _input(
              context: context,
              inputHint:
                  "모든 글(상업성, 정보성) 작성 시 AI가 공통으로 따라야 할 지침을 입력하세요. (예: 친근한 말투, 각 문단은 3문장 이내 등)",
              controller: aiWriteOrderController,
              align: Alignment.topLeft,
              boxHeight: 200,
            ),
          ],
        ),
      ),
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
