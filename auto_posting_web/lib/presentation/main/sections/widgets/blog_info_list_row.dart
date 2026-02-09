import 'package:auto_posting_web/presentation/main/main_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class BlogInfoListRow extends ConsumerWidget {
  const BlogInfoListRow({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${index + 1}.", style: context.titleMideum),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.postTitleType == PostTitleType.keyword
                                ? "메인 키워드:"
                                : "블로그 글 제목",
                            style: context.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            state.postTitleType == PostTitleType.keyword
                                ? state.titleKeywordList[index].main_keyword
                                : state.titleUrlList[index].posting_title,
                            style: context.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        notifier.removeBlogInfo(index: index);
                      },
                      icon: Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      state.postTitleType == PostTitleType.keyword
                          ? "제목:"
                          : "URL",
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.postTitleType == PostTitleType.keyword
                            ? state.titleKeywordList[index].posting_title
                            : state.titleUrlList[index].url,
                        style: context.bodyLarge,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 20),

                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
