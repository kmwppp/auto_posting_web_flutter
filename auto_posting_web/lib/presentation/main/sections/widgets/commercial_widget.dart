import 'package:auto_posting_web/presentation/main/main_enums.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/add_blog_info_multi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';
import 'add_blog_info_single.dart';
import 'auto_qr_link_create.dart';
import 'blog_info_list_row.dart';
import 'common_radio_group.dart';

class CommercialWidget extends ConsumerWidget {
  const CommercialWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final urlController = ref.watch(wordpressURLControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 26),
        // Text("상업성 글 생성 방식", style: context.bodyLarge),
        // CommonRadioGroup<CreatePostType>(
        //   groupValue: createPostType,
        //   items: [
        //     CommonRadioItem(label: '제목으로 글 찾기', value: CreatePostType.title),
        //     CommonRadioItem(label: 'URL로 글 가져오기', value: CreatePostType.url),
        //   ],
        //   onChanged: (value) => notifier.changeCreatePostType(value),
        // ),
        // SizedBox(height: 16),
        Text("워드프레스 사이트 URL", style: context.bodyLarge),
        SizedBox(height: 6),
        _input(
          context: context,
          inputHint: "https://example.com/ (당신의 워드프레스 메인 주소 입력)",
          controller: urlController,
          align: Alignment.center,
        ),
        SizedBox(height: 6),
        Text(
          "프로그램이 이 사이트에서 제목과 가장 유사한 글을 찾습니다.",
          style: context.body.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
        Text("블로그 메인 키워드 및 제목", style: context.bodyLarge),
        SizedBox(height: 6),
        CommonRadioGroup<BlogInsertType>(
          groupValue: state.blogInsertType,
          items: [
            CommonRadioItem(label: '한개씩 입력', value: BlogInsertType.single),
            CommonRadioItem(label: '여러개 입력', value: BlogInsertType.multi),
          ],
          onChanged: (value) => notifier.changeBlogInsertType(value),
        ),
        if (state.blogInsertType == BlogInsertType.single) AddBlogInfoSingle(),
        if (state.blogInsertType == BlogInsertType.multi) AddBlogInfoMulti(),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            notifier.resetBlogInfoModel();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              "글 내용 초기화",
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 4,
              children: state.titleList.isEmpty
                  ? [
                      Center(
                        child: Text(
                          "추가된 블로그 주제가 없습니다.",
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),
                    ]
                  : state.titleList.asMap().entries.map((entry) {
                      int index = entry.key; // 여기에 index가 들어있습니다.
                      return BlogInfoListRow(index: index);
                    }).toList(),
            ),
            // child: Center(child: Text("추가된 계정이 없습니다.")),
          ),
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
