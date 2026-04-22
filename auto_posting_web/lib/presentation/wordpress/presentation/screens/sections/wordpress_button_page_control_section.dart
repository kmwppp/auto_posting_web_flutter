import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../providers/wordpress_state.dart';
import '../../providers/wordpress_viewmodel.dart';

class WordpressButtonPageControlSection extends ConsumerStatefulWidget {
  const WordpressButtonPageControlSection({super.key});

  @override
  ConsumerState<WordpressButtonPageControlSection> createState() =>
      _WordpressButtonPageControlSectionState();
}

class _WordpressButtonPageControlSectionState
    extends ConsumerState<WordpressButtonPageControlSection> {
  late TextEditingController buttonUrlController;
  late TextEditingController buttonIdController;
  late TextEditingController buttonPwController;

  late ProviderSubscription<WordpressState> _subscription;

  @override
  void initState() {
    super.initState();

    final state = ref.read(wordpressViewModelProvider);

    buttonUrlController = TextEditingController(text: state.buttonPageUrl);
    buttonIdController = TextEditingController(text: state.buttonPageId);
    buttonPwController = TextEditingController(text: state.buttonPagePw);

    /// 여기 수정
    _subscription = ref.listenManual<WordpressState>(
      wordpressViewModelProvider,
      (prev, next) {
        if (buttonUrlController.text != next.buttonPageUrl) {
          buttonUrlController.text = next.buttonPageUrl;
        }

        if (buttonIdController.text != next.buttonPageId) {
          buttonIdController.text = next.buttonPageId;
        }

        if (buttonPwController.text != next.buttonPagePw) {
          buttonPwController.text = next.buttonPagePw;
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.close();
    buttonUrlController.dispose();
    buttonIdController.dispose();
    buttonPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonPage = ref.watch(
      wordpressViewModelProvider.select((s) => s.buttonPage),
    );

    final vm = ref.read(wordpressViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            context: context,
            title: "버튼페이지 사용",
            trailing: Switch(
              value: buttonPage,
              activeColor: Colors.blueGrey[800],
              onChanged: (value) {
                vm.changeButtonPageChange(value);
              },
            ),
          ),

          if (buttonPage) ...[
            const SizedBox(height: 16),
            _label("버튼페이지 사이트 주소"),
            _input(
              controller: buttonUrlController,
              context: context,
              inputHint: "https://your-wordpress-site.com",
              onChanged: vm.updateButtonUrl,
              align: Alignment.centerLeft,
            ),

            const SizedBox(height: 16),
            _label("버튼페이지 사이트 아이디"),
            _input(
              controller: buttonIdController,
              context: context,
              inputHint: "ID",
              onChanged: vm.updateButtonId,
              align: Alignment.centerLeft,
            ),

            const SizedBox(height: 16),
            _label("버튼페이지 사이트 비밀번호"),
            _input(
              controller: buttonPwController,
              context: context,
              inputHint: "**** **** **** ****",
              onChanged: vm.updateButtonPw,
              align: Alignment.centerLeft,
              isPassword: true,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  // --- 통일된 섹션 스타일 헬퍼 메서드 ---
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
              style: context.title.copyWith(
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
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
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.black87,
      ),
    ),
  );

  Widget _input({
    required BuildContext context,
    required TextEditingController controller,
    required String inputHint,
    required Function(String) onChanged,
    double boxHeight = 0,
    required AlignmentGeometry align,
    bool isPassword = false,
  }) {
    final isMultiLine = boxHeight > 0;

    return Container(
      height: isMultiLine ? boxHeight : 50,
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
        obscureText: isPassword,
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
