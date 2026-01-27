import 'package:auto_posting_web/presentation/main/sections/widgets/blog_info_row.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';

class AddBlogInfoMulti extends StatelessWidget {
  const AddBlogInfoMulti({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("새 메인키워드 및 제목 추가", style: context.bodyLarge),
        BlogInfoRow(),
      ],
    );
  }
}
