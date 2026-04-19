import 'package:auto_posting_web/presentation/main/main_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class BlogInfoRow extends ConsumerWidget {
  const BlogInfoRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final mainKeyController = ref.watch(mainKeyWordControllerProvider);
    final blogTitleController = ref.watch(blogTitleControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _input(
                context: context,
                inputHint: state.postTitleType == PostTitleType.keyword
                    ? "메인 키워드 (줄바꿈으로 구분)"
                    : "블로그 제목 (줄바꿈으로 구분)",
                controller: mainKeyController,
                align: Alignment.topLeft,
                boxHeight: 300,
              ),
            ),
            const SizedBox(width: 12), // 간격 통일
            Expanded(
              child: _input(
                context: context,
                inputHint: state.postTitleType == PostTitleType.keyword
                    ? "블로그 제목 (줄바꿈으로 구분)"
                    : "URL (줄바꿈으로 구분)",
                controller: blogTitleController,
                align: Alignment.topLeft,
                boxHeight: 300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 추가 버튼 (Beanz 테마 스타일)
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            onPressed: () {
              notifier.addBlogInfoMulti(
                first: mainKeyController.text,
                second: blogTitleController.text,
              );
            },
            child: const Text(
              "글 내용 일괄 추가",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // --- 통일된 멀티라인 입력 폼 스타일 ---
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
        border: Border.all(color: Colors.black12), // 연한 테두리로 변경
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
        style: context.body, // 기존 bodyLarge에서 통일된 body 스타일로 변경
      ),
    );
  }
}
