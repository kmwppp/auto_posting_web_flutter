import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class InsertProxy extends ConsumerWidget {
  const InsertProxy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proxyController = ref.watch(proxyUrlControllerProvider);
    // final notifier = ref.read(mainViewModelProvider.notifier); // 필요 시 사용

    return Column(
      children: [
        // 섹션 타이틀 (WordpressPage 스타일 적용)
        _sectionTitle(
          context: context,
          title: "프록시 설정",
          trailing: _helpButton(context),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("구매하신 프록시 IP 입력"),
              _input(
                context: context,
                inputHint: "프록시 IP를 입력하세요.",
                controller: proxyController,
                align: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              Text(
                "프록시 IP는 발행 시 자동으로 저장되며, 변동될 경우 자동으로 갱신됩니다.",
                style: context.body.copyWith(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // 도움말 버튼 (물음표 아이콘)
  Widget _helpButton(BuildContext context) {
    return InkWell(
      onTap: () => context.push("/proxy_description"),
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.question_mark, color: Colors.white, size: 14),
      ),
    );
  }

  // --- Wordpress 섹션 스타일 헬퍼 메서드 ---

  Widget _sectionTitle({
    required BuildContext context,
    required String title,
    Widget? trailing,
  }) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.title.copyWith(color: Colors.blueGrey[900]),
            ),
            if (trailing != null) trailing,
          ],
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
    TextEditingController? controller,
    Function(String)? onChanged,
    double boxHeight = 0,
    required AlignmentGeometry align,
  }) {
    final isMultiLine = boxHeight > 0;
    return Container(
      height: isMultiLine ? boxHeight : null,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
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
