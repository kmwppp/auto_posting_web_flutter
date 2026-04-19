import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';

class PostAIWriteSettingSection extends ConsumerWidget {
  const PostAIWriteSettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiWriteOrderController = ref.watch(aiwriteOrderControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 섹션 타이틀 (Beanz 통일 스타일)
          _sectionTitle(
            context: context,
            title: "AI 글쓰기 지침 설정",
            trailing: Text(
              "Model: GPT-4o",
              style: TextStyle(color: Colors.blueGrey[400], fontSize: 12),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. 입력 라벨 및 가이드
                _label("공통 글쓰기 지침"),
                Text(
                  "모든 포스팅 작성 시 AI가 공통으로 준수할 스타일이나 제약사항을 입력하세요.",
                  style: context.body.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. 멀티라인 입력창
                _input(
                  context: context,
                  inputHint: "예: 친근한 말투 사용, 각 문단은 3문장 이내, 전문적인 용어 지양 등",
                  controller: aiWriteOrderController,
                  align: Alignment.topLeft,
                  boxHeight: 200,
                ),
                const SizedBox(height: 8),
                Text(
                  "지침이 구체적일수록 원하는 결과물에 가까운 글이 생성됩니다.",
                  style: context.body.copyWith(
                    color: Colors.blueGrey[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );

  Widget _input({
    required BuildContext context,
    required String inputHint,
    required TextEditingController controller,
    double boxHeight = 0,
    required AlignmentGeometry align,
  }) {
    final isMultiLine = boxHeight > 0;
    return Container(
      height: isMultiLine ? boxHeight : 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: align,
      padding: const EdgeInsets.all(14),
      child: TextField(
        controller: controller,
        maxLines: isMultiLine ? null : 1,
        minLines: isMultiLine ? null : 1,
        expands: isMultiLine,
        keyboardType: isMultiLine
            ? TextInputType.multiline
            : TextInputType.text,
        textAlignVertical: isMultiLine
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        style: context.body,
      ),
    );
  }
}
