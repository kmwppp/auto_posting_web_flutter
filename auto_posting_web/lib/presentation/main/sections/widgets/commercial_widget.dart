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
    final linkTopTextController = ref.watch(linkTopTextControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    final blogName = state.mainBlogType == MainBlogType.wordPress
        ? "워드프레스"
        : "블로그 스팟";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 26),

        // 1. 사이트 URL 섹션
        _sectionTitle(context: context, title: "$blogName 사이트 설정"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("$blogName 메인 주소"),
              _input(
                context: context,
                inputHint: "https://example.com/ (당신의 $blogName 메인 주소 입력)",
                controller: urlController,
                align: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              Text(
                "발행 시 자동으로 저장되며, 프로그램이 제목과 가장 유사한 글을 찾습니다.",
                style: context.body.copyWith(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),

        // 2. 링크 문구 설정 섹션
        _sectionTitle(context: context, title: "링크 상단 문구 설정"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("상단 노출 문구"),
              _input(
                context: context,
                inputHint: "ex) 자세한 정보는 아래에서 확인해 보세요.",
                controller: linkTopTextController,
                align: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              Text(
                "발행 시 자동으로 저장되며 변동될 경우 갱신됩니다.",
                style: context.body.copyWith(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),

        // 3. 블로그 글쓰기 타입 섹션
        _sectionTitle(context: context, title: "블로그 글쓰기 타입 & 입력 방식"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("글쓰기 타입 선택"),
              CommonRadioGroup<PostTitleType>(
                groupValue: state.postTitleType,
                items: [
                  CommonRadioItem(
                    label: '블로그 메인 키워드 및 제목',
                    value: PostTitleType.keyword,
                  ),
                  CommonRadioItem(
                    label: '블로그 제목 및 워드프레스 링크',
                    value: PostTitleType.url,
                  ),
                ],
                onChanged: (value) => notifier.changePostTitleType(value),
              ),
              const SizedBox(height: 20),
              _label("입력 방식 선택"),
              CommonRadioGroup<BlogInsertType>(
                groupValue: state.blogInsertType,
                items: [
                  CommonRadioItem(
                    label: '한개씩 입력',
                    value: BlogInsertType.single,
                  ),
                  CommonRadioItem(label: '여러개 입력', value: BlogInsertType.multi),
                ],
                onChanged: (value) => notifier.changeBlogInsertType(value),
              ),
            ],
          ),
        ),

        // 4. 입력 폼 영역 (Single / Multi)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (state.blogInsertType == BlogInsertType.single)
                const AddBlogInfoSingle(),
              if (state.blogInsertType == BlogInsertType.multi)
                const AddBlogInfoMulti(),
              const SizedBox(height: 16),

              // 초기화 버튼
              _actionButton(
                label: "글 내용 초기화",
                color: Colors.grey[200]!,
                textColor: Colors.black87,
                onTap: () => notifier.resetBlogInfoModel(),
              ),
            ],
          ),
        ),

        // 5. 블로그 주제 리스트 섹션
        const SizedBox(height: 30),
        _sectionTitle(context: context, title: "추가된 블로그 주제 목록"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBlogList(state),
            ),
          ),
        ),

        const Divider(height: 40),
        const AutoQRLinkCreate(),
        const SizedBox(height: 40),
      ],
    );
  }

  // 리스트 빌더 분리
  Widget _buildBlogList(state) {
    final list = state.postTitleType == PostTitleType.keyword
        ? state.titleKeywordList
        : state.titleUrlList;
    if (list.isEmpty) {
      return const Center(
        child: Text("추가된 블로그 주제가 없습니다.", style: TextStyle(color: Colors.grey)),
      );
    }
    return Column(
      children: list
          .asMap()
          .entries
          .map<Widget>((entry) => BlogInfoListRow(index: entry.key))
          .toList(),
    );
  }

  // --- 통일된 UI 컴포넌트 헬퍼 ---

  Widget _sectionTitle({required BuildContext context, required String title}) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border(
          left: BorderSide(color: Colors.blueGrey[800]!, width: 6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: context.title.copyWith(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );

  Widget _input({
    required BuildContext context,
    required String inputHint,
    required TextEditingController controller,
    double boxHeight = 0,
    required AlignmentGeometry align,
  }) {
    final isMultiLine = boxHeight > 0;
    return Container(
      height: isMultiLine ? boxHeight : 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        maxLines: isMultiLine ? null : 1,
        minLines: isMultiLine ? null : 1,
        expands: isMultiLine,
        textAlignVertical: isMultiLine
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        style: context.body,
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
