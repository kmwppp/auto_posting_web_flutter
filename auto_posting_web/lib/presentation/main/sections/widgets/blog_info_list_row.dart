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
                            "메인 키워드:",
                            style: context.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            state.titleList[index].main_keyword,
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
                      "제목:",
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.titleList[index].posting_title,
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
