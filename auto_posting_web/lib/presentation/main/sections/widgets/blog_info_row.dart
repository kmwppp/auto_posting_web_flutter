import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class BlogInfoRow extends ConsumerWidget {
  const BlogInfoRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainKeyController = ref.watch(mainKeyWordControllerProvider);
    final blogTitleController = ref.watch(blogTitleControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: _input(
                context: context,
                inputHint: "메인 키워드",
                controller: mainKeyController,
                align: Alignment.topLeft,
                boxHeight: 300,
              ),
            ),
            Expanded(
              child: _input(
                context: context,
                inputHint: "블로그 제목",
                controller: blogTitleController,
                align: Alignment.topLeft,
                boxHeight: 300,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            notifier.addBlogInfoMulti(
              mainKeyword: mainKeyController.text,
              postingTitle: blogTitleController.text,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              "글 내용 추가",
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
            ),
          ),
        ),
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
