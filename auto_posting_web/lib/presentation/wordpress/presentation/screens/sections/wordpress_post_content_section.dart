import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../providers/wordpress_viewmodel.dart';

class WordpressPostContentSection extends ConsumerStatefulWidget {
  const WordpressPostContentSection({super.key});

  @override
  ConsumerState<WordpressPostContentSection> createState() =>
      _WordpressPostContentSectionState();
}

class _WordpressPostContentSectionState
    extends ConsumerState<WordpressPostContentSection> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordpressViewModelProvider);
    final vm = ref.read(wordpressViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 섹션 헤더
        _sectionTitle(context: context, title: "2. 포스트 내용 설정"),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("글 제목 대량 입력 (줄바꿈으로 구분)"),
              _input(
                context: context,
                inputHint: "예시:\n오늘의 커피 추천\n서울 카페 투어 베스트 5\n홈카페 원두 고르는 법...",
                controller: _titleController,
                boxHeight: 180,
                // 가독성을 위해 높이 소폭 조정
                align: Alignment.topLeft,
              ),
              const SizedBox(height: 16),

              // 2. 글 내용 생성 버튼 (Beanz 액션 스타일)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => vm.generateContents(_titleController.text),
                  icon: const Icon(Icons.add_task, size: 18),
                  label: const Text("목록에 글 내용 추가"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    foregroundColor: Colors.white,
                    // height 대신 minimumSize를 사용합니다.
                    // Size(너비, 높이) 순서이며, 가로를 꽉 채우려면 너비에 double.infinity를 넣어도 됩니다.
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              if (state.contents.isNotEmpty) ...[
                const SizedBox(height: 40),
                Row(
                  children: [
                    Icon(
                      Icons.format_list_bulleted,
                      size: 18,
                      color: Colors.blueGrey[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "생성된 포스트 목록 (${state.contents.length}개)",
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. 생성된 리스트 출력 (카드 스타일)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.contents.length,
                  itemBuilder: (context, index) {
                    final item = state.contents[index];
                    return _contentItemWidget(context, index, item, vm);
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // 리스트의 각 항목 위젯 (카드 형태)
  Widget _contentItemWidget(
    BuildContext context,
    int index,
    dynamic item,
    dynamic vm,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카드 상단 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blueGrey[800],
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 12),

                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: Colors.blueGrey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    vm.removeContent(index);
                  },
                ),
              ],
            ),
          ),

          // 카드 내용 (URL 입력부)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("이동할 버튼 URL (선택 사항)"),
                _input(
                  context: context,
                  inputHint: "https://example.com/product-link",
                  onChanged: (val) => vm.updateContentUrl(index, val),
                  align: Alignment.centerLeft,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 통일된 UI 헬퍼 메서드 ---
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
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.black87,
      ),
    ),
  );

  Widget _input({
    required BuildContext context,
    required String inputHint,
    TextEditingController? controller,
    Function(String)? onChanged,
    double boxHeight = 0,
    required AlignmentGeometry align,
  }) {
    final isMultiLine = boxHeight > 0;
    return Container(
      height: isMultiLine ? boxHeight : 50,
      // 일반 필드 높이 고정
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey[100]!),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: isMultiLine ? null : 1,
        minLines: isMultiLine ? null : 1,
        expands: isMultiLine,
        textAlignVertical: isMultiLine
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
          hintStyle: TextStyle(color: Colors.blueGrey[200], fontSize: 14),
        ),
      ),
    );
  }
}
