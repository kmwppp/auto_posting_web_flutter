import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../provider/main/main_provider.dart';

class PostImageCountWidget extends ConsumerWidget {
  const PostImageCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiImgCount = ref.watch(
      mainViewModelProvider.select((s) => s.aiImgCount),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("포스팅 당 사진 개수 ($aiImgCount개)", style: context.bodyLarge),
        Slider(
          value: aiImgCount,
          min: 0,
          max: 10,
          divisions: 10, // 0~10까지 10칸으로 나눔 (딱딱 끊기게 설정)
          label: aiImgCount.toInt().toString(), // 옮길 때 위에 뜨는 숫자 노출
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.grey.shade300,
          onChanged: (value) {
            notifier.updateAIImgCount(value);
          },
        ),
      ],
    );
  }
}
