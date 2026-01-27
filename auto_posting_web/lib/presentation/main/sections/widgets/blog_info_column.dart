import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_provider.dart';
import 'input_widget.dart';

class BlogInfoColumn extends ConsumerWidget {
  const BlogInfoColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainKeyController = ref.watch(mainKeyWordControllerProvider);
    final blogTitleController = ref.watch(blogTitleControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      spacing: 10,
      children: [
        InputWidget(inputHint: "메인 키워드", controller: mainKeyController),
        InputWidget(inputHint: "블로그 제목", controller: blogTitleController),
        GestureDetector(
          onTap: () {
            notifier.addBlogInfoSingle(
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
}
