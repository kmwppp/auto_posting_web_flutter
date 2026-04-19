import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/main/main_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_provider.dart';

class BlogInfoColumn extends ConsumerWidget {
  const BlogInfoColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final mainKeyController = ref.watch(mainKeyWordControllerProvider);
    final blogTitleController = ref.watch(blogTitleControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    // 타입에 따른 힌트 텍스트 분기
    final String firstHint = state.postTitleType == PostTitleType.keyword
        ? "메인 키워드"
        : "블로그 제목";
    final String secondHint = state.postTitleType == PostTitleType.keyword
        ? "블로그 제목"
        : "URL";

    return Column(
      children: [
        _input(
          context: context,
          inputHint: firstHint,
          controller: mainKeyController,
        ),
        const SizedBox(height: 12),
        _input(
          context: context,
          inputHint: secondHint,
          controller: blogTitleController,
        ),
        const SizedBox(height: 16),

        // 추가 버튼 (Beanz 테마 적용)
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
              notifier.addBlogInfoSingle(
                first: mainKeyController.text,
                second: blogTitleController.text,
              );
            },
            child: const Text(
              "글 내용 추가",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // --- 통일된 입력 폼 스타일 ---
  Widget _input({
    required BuildContext context,
    required String inputHint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
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
