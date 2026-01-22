import 'package:auto_posting_web/presentation/provider/main/main_provider.dart';
import 'package:auto_posting_web/presentation/view/main/sections/widgets/common_radio_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../viewmodel/main/main_enums.dart';

class PostingMethodSettingSection extends ConsumerWidget {
  const PostingMethodSettingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postingType = ref.watch(
      mainViewModelProvider.select((s) => s.postingType),
    );
    final postingCycleController = ref.watch(postingCycleControllerProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("발행 주기 (분)", style: context.bodyLarge),
            SizedBox(height: 6),
            _input(
              context: context,
              inputHint: "Ex) 30",
              controller: postingCycleController,
              align: Alignment.center,
            ),
            SizedBox(height: 4),
            Text("여러 글을 발행할 경우, 설정된 시간 간격으로 순차 발행/예약됩니다."),
            SizedBox(height: 20),
            CommonRadioGroup<PostingType>(
              groupValue: postingType,
              items: [
                CommonRadioItem(
                  label: '즉시 발행 시작',
                  value: PostingType.immediately,
                ),
                CommonRadioItem(label: '예약 발행', value: PostingType.reservation),
              ],
              onChanged: (value) => notifier.changePostingType(value),
            ),
          ],
        ),
      ),
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
