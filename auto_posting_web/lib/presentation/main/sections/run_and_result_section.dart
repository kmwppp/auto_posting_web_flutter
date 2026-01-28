import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main_state.dart';
import '../main_viewmodel.dart';

class RunAndResultSection extends ConsumerWidget {
  const RunAndResultSection({super.key});

  // 1. 검증 및 전송 로직을 별도 함수로 분리
  Future<void> _handleStartPosting(
    BuildContext context,
    WidgetRef ref,
    MainViewModel notifier,
    MainState state,
  ) async {
    // 1-1. 프록시 미설정 시 컨펌 다이얼로그
    // if (!state.isProxySetting) {
    //   final bool confirm =
    //       await _showConfirmDialog(
    //         context,
    //         title: "주의",
    //         content: "프록시를 설정하지 않고 진행하시겠습니까?",
    //       ) ??
    //       false;
    //   if (!confirm) return;
    // }

    // 1-2. 데이터 유효성 검증
    final validation = notifier.isChkValidation();
    if (!validation.isValid) {
      await _showAlertDialog(context, message: validation.message);
      return;
    }

    // 1-3. 최종 서버 전송
    await notifier.sendToServer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // 발행 시작 버튼
          _buildStartButton(context, ref, notifier, state),
          const SizedBox(height: 20),
          // 결과 로그 섹션
          _buildResultLog(context, ref),
        ],
      ),
    );
  }

  // --- 소형 위젯 및 다이얼로그 함수들 ---

  Widget _buildStartButton(
    BuildContext context,
    WidgetRef ref,
    MainViewModel notifier,
    MainState state,
  ) {
    return InkWell(
      // 로딩 중이면 클릭이 안 되도록 null 처리
      onTap: state.isLoading
          ? null
          : () => _handleStartPosting(context, ref, notifier, state),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: state.isLoading ? Colors.grey : Colors.blueAccent, // 로딩 중엔 회색
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "자동 포스팅 발행 시작",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildResultLog(BuildContext context, WidgetRef ref) {
    // 1. ViewModel의 상태 중 logList만 감시합니다.
    final logList = ref.watch(mainViewModelProvider.select((s) => s.logList));

    // 2. 자동 스크롤을 위한 컨트롤러 (StatefulWidget의 필드나 Provider로 관리하는 것이 좋지만,
    // 여기서는 위젯 내에서 사용할 수 있도록 예시를 구성합니다.)
    final ScrollController scrollController = ScrollController();

    // 로그가 추가될 때마다 최하단으로 스크롤 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("작업 결과 로그", style: context.bodyLarge),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 250,
          // 로그가 많아질 것을 대비해 높이를 조금 키웠습니다.
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05), // 로그창 배경을 살짝 어둡게
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          padding: const EdgeInsets.all(8.0),
          child: logList.isEmpty
              ? const Center(child: Text("작업을 시작하면 로그가 여기에 표시됩니다."))
              : ListView.builder(
                  controller: scrollController,
                  itemCount: logList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        "> ${logList[index]}",
                        style: const TextStyle(
                          fontFamily: 'monospace', // 터미널 느낌의 폰트
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("아니오"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("예"),
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(
    BuildContext context, {
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("확인 필요"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }
}
