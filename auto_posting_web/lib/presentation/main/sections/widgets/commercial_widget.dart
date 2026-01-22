import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../main_enums.dart';
import '../../main_provider.dart';
import 'auto_qr_link_create.dart';
import 'common_radio_group.dart';

class CommercialWidget extends ConsumerWidget {
  const CommercialWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPostType = ref.watch(
      mainViewModelProvider.select((s) => s.createPostType),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);
    final urlController = ref.watch(wordpressURLControllerProvider);
    final blogTitleController = ref.watch(blogTitleControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 26),
        Text("상업성 글 생성 방식", style: context.bodyLarge),
        CommonRadioGroup<CreatePostType>(
          groupValue: createPostType,
          items: [
            CommonRadioItem(label: '제목으로 글 찾기', value: CreatePostType.title),
            CommonRadioItem(label: 'URL로 글 가져오기', value: CreatePostType.url),
          ],
          onChanged: (value) => notifier.changeCreatePostType(value),
        ),
        SizedBox(height: 16),
        Text("워드프레스 사이트 URL", style: context.bodyLarge),
        SizedBox(height: 6),
        _input(
          context: context,
          inputHint: "https://example.com",
          controller: urlController,
          align: Alignment.center,
        ),
        SizedBox(height: 6),
        Text(
          "프로그램이 이 사이트에서 제목과 가장 유사한 글을 찾습니다.",
          style: context.body.copyWith(color: Colors.grey),
        ),

        SizedBox(height: 16),

        _input(
          context: context,
          inputHint: "발행할 포스트 제목을 한 줄에 하나씩 입력하세요.",
          controller: blogTitleController,
          boxHeight: 250,
          align: Alignment.topLeft,
        ),
        SizedBox(height: 16),
        Divider(),

        AutoQRLinkCreate(),
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
        style: context.body,
      ),
    );
  }
}
