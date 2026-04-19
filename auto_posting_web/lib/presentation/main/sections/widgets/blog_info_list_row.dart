import 'package:auto_posting_web/presentation/main/main_enums.dart';
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

    // 데이터 추출 분기
    final String firstLabel = state.postTitleType == PostTitleType.keyword
        ? "메인 키워드"
        : "블로그 제목";
    final String secondLabel = state.postTitleType == PostTitleType.keyword
        ? "포스팅 제목"
        : "연결 URL";

    final String firstValue = state.postTitleType == PostTitleType.keyword
        ? state.titleKeywordList[index].main_keyword
        : state.titleUrlList[index].posting_title;

    final String secondValue = state.postTitleType == PostTitleType.keyword
        ? state.titleKeywordList[index].posting_title
        : state.titleUrlList[index].url;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50], // 연한 배경으로 항목 구분
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 순번 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "${index + 1}",
              style: context.body.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 콘텐츠 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(
                  label: firstLabel,
                  value: firstValue,
                  context: context,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  label: secondLabel,
                  value: secondValue,
                  context: context,
                ),
              ],
            ),
          ),

          // 삭제 버튼
          IconButton(
            onPressed: () => notifier.removeBlogInfo(index: index),
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.redAccent.withOpacity(0.7),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            hoverColor: Colors.red[50],
          ),
        ],
      ),
    );
  }

  // 내부 정보 행 위젯
  Widget _infoRow({
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80, // 라벨 너비 고정으로 정렬 유지
          child: Text(
            label,
            style: context.body.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[700],
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.body.copyWith(color: Colors.black87),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
