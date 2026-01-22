import 'package:auto_posting_web/presentation/main/sections/widgets/commercial_widget.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/common_radio_group.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/informative_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../main_enums.dart';
import '../main_provider.dart';

class PostTypeAndContentsSection extends ConsumerWidget {
  const PostTypeAndContentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postType = ref.watch(mainViewModelProvider.select((s) => s.postType));
    final notifier = ref.read(mainViewModelProvider.notifier);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonRadioGroup<PostType>(
              groupValue: postType,
              items: [
                CommonRadioItem(
                  label: '상업성 글 (워드프레스 연동)',
                  value: PostType.commercial,
                ),
                CommonRadioItem(
                  label: '정보성 글 (링크 없음)',
                  value: PostType.informative,
                ),
              ],
              onChanged: (value) => notifier.changePostType(value),
            ),
            Divider(),
            postType == PostType.commercial
                ? CommercialWidget()
                : InformativeWidget(),

            SizedBox(height: 20),
            Center(
              child: Text(
                "* 분배 방식에 따라 포스트가 선택된 블로그에 발행됩니다.",
                style: context.body.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
