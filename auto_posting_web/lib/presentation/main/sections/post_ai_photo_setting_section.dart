import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/ai_photo_style_spinner.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/post_image_count_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostAIPhotoSettingSection extends ConsumerWidget {
  const PostAIPhotoSettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostImageCountWidget(),
            SizedBox(height: 20),
            Text("사진 스타일 선택", style: context.bodyLarge),
            AIPhotoStyleSpinner(),
          ],
        ),
      ),
    );
  }
}
