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
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "메인 키워드: ${state.titleList[index].main_keyword}",
                  style: context.bodyLarge,
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
          Text(
            "제목: ${state.titleList[index].posting_title}",
            style: context.bodyLarge,
          ),

          SizedBox(width: 20),

          Divider(),
        ],
      ),
    );
  }
}
