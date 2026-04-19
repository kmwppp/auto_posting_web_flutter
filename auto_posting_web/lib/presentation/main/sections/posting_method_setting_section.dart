import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/common_radio_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../main_enums.dart';

class PostingMethodSettingSection extends ConsumerWidget {
  const PostingMethodSettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postingType = ref.watch(
      mainViewModelProvider.select((s) => s.postingType),
    );
    final postingTermType = ref.watch(
      mainViewModelProvider.select((s) => s.postingTermType),
    );
    final postingCycleController = ref.watch(postingCycleControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 섹션 타이틀
          _sectionTitle(context: context, title: "발행 방식 설정"),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. 발행/저장 선택
                _label("작업 유형"),
                CommonRadioGroup<PostingType>(
                  groupValue: postingType,
                  items: [
                    CommonRadioItem(
                      label: '즉시 발행',
                      value: PostingType.publication,
                    ),
                    CommonRadioItem(label: '임시 저장', value: PostingType.storage),
                  ],
                  onChanged: (value) => notifier.changePostingType(value),
                ),

                const SizedBox(height: 16),

                // 3. 타입별 상세 설정
                if (postingType == PostingType.storage)
                  _infoBox("임시 저장은 3~5분 사이의 랜덤한 간격으로 안전하게 저장됩니다.")
                else if (postingType == PostingType.publication)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("발행 주기 (분)"),
                      _input(
                        context: context,
                        inputHint: "예: 30 (숫자만 입력)",
                        controller: postingCycleController,
                        align: Alignment.centerLeft,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "여러 글을 발행할 경우, 설정된 시간 간격으로 순차 발행/예약됩니다.",
                        style: context.body.copyWith(
                          color: Colors.blueGrey[400],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _label("발행 시점"),
                      CommonRadioGroup<PostingTermType>(
                        groupValue: postingTermType,
                        items: [
                          CommonRadioItem(
                            label: '즉시 발행 시작',
                            value: PostingTermType.immediately,
                          ),
                          CommonRadioItem(
                            label: '예약 발행',
                            value: PostingTermType.reservation,
                          ),
                        ],
                        onChanged: (value) =>
                            notifier.changePostingTermType(value),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _infoBox(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.black12),
    ),
    child: Text(
      text,
      style: TextStyle(color: Colors.blueGrey[600], fontSize: 13),
    ),
  );

  Widget _input({
    required BuildContext context,
    required String inputHint,
    required TextEditingController controller,
    required AlignmentGeometry align,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        style: context.body,
      ),
    );
  }
}
