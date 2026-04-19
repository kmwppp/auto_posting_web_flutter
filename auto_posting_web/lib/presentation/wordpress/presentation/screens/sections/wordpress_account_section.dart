import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../providers/wordpress_state.dart';
import '../../providers/wordpress_viewmodel.dart';

class WordpressAccountSection extends ConsumerStatefulWidget {
  const WordpressAccountSection({super.key});

  @override
  ConsumerState<WordpressAccountSection> createState() =>
      _WordpressAccountSectionState();
}

class _WordpressAccountSectionState
    extends ConsumerState<WordpressAccountSection> {
  late TextEditingController siteController;
  late TextEditingController idController;
  late TextEditingController pwController;
  late TextEditingController adsController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(wordpressViewModelProvider.notifier).loadCredentials();
    });

    final state = ref.read(wordpressViewModelProvider);

    siteController = TextEditingController(text: state.siteUrl);
    idController = TextEditingController(text: state.adminId);
    pwController = TextEditingController(text: state.adminPassword);
    adsController = TextEditingController(text: state.adSenseCode);
  }

  @override
  void dispose() {
    siteController.dispose();
    idController.dispose();
    pwController.dispose();
    adsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordpressViewModelProvider);
    final vm = ref.read(wordpressViewModelProvider.notifier);

    /// state 변경 감지
    ref.listen<WordpressState>(wordpressViewModelProvider, (prev, next) {
      if (prev?.siteUrl != next.siteUrl) {
        siteController.text = next.siteUrl;
      }
      if (prev?.adminId != next.adminId) {
        idController.text = next.adminId;
      }
      if (prev?.adminPassword != next.adminPassword) {
        pwController.text = next.adminPassword;
      }
      if (prev?.adSenseCode != next.adSenseCode) {
        adsController.text = next.adSenseCode;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context: context, title: "1. 워드프레스 계정 관리"),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("워드프레스 사이트 주소"),
              _input(
                controller: siteController,
                context: context,
                inputHint: "https://your-wordpress-site.com",
                onChanged: vm.updateSiteUrl,
                align: Alignment.centerLeft,
              ),
              const SizedBox(height: 16),

              _label("관리자 아이디 (Application Password용)"),
              _input(
                controller: idController,
                context: context,
                inputHint: "Admin ID",
                onChanged: vm.updateAdminId,
                align: Alignment.centerLeft,
              ),
              const SizedBox(height: 16),

              _label("관리자 비밀번호 (응용 프로그램 비밀번호)"),
              _input(
                controller: pwController,
                context: context,
                inputHint: "xxxx xxxx xxxx xxxx",
                onChanged: vm.updateAdminPassword,
                align: Alignment.centerLeft,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              _label("애드센스 코드 (선택 사항)"),
              _input(
                controller: adsController,
                context: context,
                inputHint: "<script async src='...'></script>",
                onChanged: vm.updateAdSenseCode,
                boxHeight: 120,
                align: Alignment.topLeft,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  // UI helpers

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
