import 'package:auto_posting_web/presentation/wordpress/presentation/screens/sections/wordpress_account_section.dart';
import 'package:auto_posting_web/presentation/wordpress/presentation/screens/sections/wordpress_button_page_control_section.dart';
import 'package:auto_posting_web/presentation/wordpress/presentation/screens/sections/wordpress_post_content_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/wordpress_state.dart';
import '../providers/wordpress_viewmodel.dart';

class WordpressPage extends ConsumerWidget {
  const WordpressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wordpressViewModelProvider);
    final vm = ref.read(wordpressViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Stack을 사용하여 기본 화면 위에 Dim 레이어를 올립니다.
      body: SafeArea(
        child: Stack(
          children: [
            // [기본 화면]: 스크롤 뷰와 콘텐츠
            SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WordpressAccountSection(),
                        const WordpressButtonPageControlSection(),
                        const SizedBox(height: 32),
                        const WordpressPostContentSection(),
                        const SizedBox(height: 40),
                        _buildActionSection(context, vm, state),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // [Dim 레이어]: state.isLoading이 true일 때만 표시
            if (state.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3), // 반투명 Dim 처리
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF263238), // blueGrey[900]
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "작업 처리 중...",
                            style: TextStyle(
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(
    BuildContext context,
    WordpressViewModel vm,
    WordpressState state,
  ) {
    return Column(
      children: [
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        const SizedBox(height: 32),

        Row(
          children: [
            // 즉시 발행
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final validation = vm.validateForPosting();
                  if (!validation.isValid) {
                    _showSnackBar(context, validation.message, isError: true);
                    return;
                  }

                  final result = await vm.startPosting(false); // 즉시 발행

                  if (context.mounted) {
                    _showSnackBar(
                      context,
                      result['message'],
                      isError: !result['success'],
                    );
                  }
                },
                icon: const Icon(Icons.rocket_launch, size: 20),
                label: const Text(
                  "즉시 발행",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF263238),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 임시 저장
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final validation = vm.validateForPosting();
                  if (!validation.isValid) {
                    _showSnackBar(context, validation.message, isError: true);
                    return;
                  }

                  final result = await vm.startPosting(true); // 임시 저장

                  if (context.mounted) {
                    _showSnackBar(
                      context,
                      result['message'],
                      isError: !result['success'],
                    );
                  }
                },
                icon: const Icon(Icons.save_alt, size: 20),
                label: const Text(
                  "임시 저장",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF263238),
                  side: const BorderSide(color: Color(0xFF263238)),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),

        Container(
          width: double.infinity,
          height: 300,
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
          child: state.logs.isEmpty
              ? const Center(
                  child: Text(
                    "대기 중... 작업을 시작하면 로그가 표시됩니다.",
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.logs.map((log) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "> ",
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: log,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "monospace",
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.blueGrey[800],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
