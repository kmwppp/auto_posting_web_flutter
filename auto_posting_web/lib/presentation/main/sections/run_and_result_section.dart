import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/auth_provider.dart';
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
    // 1-2. 데이터 유효성 검증
    final validation = notifier.isChkValidation();
    if (!validation.isValid) {
      await _showAlertDialog(context, message: validation.message);
      return;
    }

    // 1-3. 최종 서버 전송
    final response = await notifier.sendToServer();
    await _showAlertDialog(context, message: response.msg);
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
          if (!state.isRunning)
            _buildStartButton(context, ref, notifier, state),
          if (state.isRunning) _buildStopButton(context, ref, notifier, state),

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
      // onTap: () {
      //   print(state.postTitleType);
      //   print("state.titleKeywordList: ${state.titleKeywordList}");
      //   print("state.titleUrlList: ${state.titleUrlList}");
      // },
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

  Widget _buildStopButton(
    BuildContext context,
    WidgetRef ref,
    MainViewModel notifier,
    MainState state,
  ) {
    return InkWell(
      // 중단 로딩 중이면 클릭 방지
      onTap: state.isStopLoading
          ? null
          : () async {
              final authState = ref.read(authStateProvider);
              final int? userIdInt = authState.userCurrentId;

              if (userIdInt == null) return;

              // 중단 API 호출
              final bool isStopped = await notifier.postStopWorking(
                userIdInt.toString(),
              );

              if (!context.mounted) return;

              if (isStopped) {
                // true일 때: 성공 팝업
                _showResultDialog(
                  context,
                  "작업 중단 요청 성공",
                  "작업 중단 요청을 했습니다. 작업 결과 로그에서 확인해주세요.",
                );
              } else {
                // false일 때: 실패/종료 팝업
                _showResultDialog(
                  context,
                  "중단 불가",
                  "현재 실행 중인 작업이 없거나 이미 종료되었습니다.",
                );
              }
            },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: state.isStopLoading ? Colors.grey : Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: state.isStopLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "자동 포스팅 중단",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildResultLog(BuildContext context, WidgetRef ref) {
    // 1. ViewModel의 상태 중 logList만 감시합니다.
    final logList = ref.watch(mainViewModelProvider.select((s) => s.logList));
    final isRunning = ref.watch(
      mainViewModelProvider.select((s) => s.isRunning),
    );

    final notifier = ref.read(mainViewModelProvider.notifier);

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
        Row(
          spacing: 10,
          children: [
            Text("작업 결과 로그", style: context.bodyLarge),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // 배경색
                foregroundColor: Colors.white, // 글자색 및 아이콘 색상
              ),
              onPressed: () {
                final authState = ref.read(authStateProvider);
                final int? userIdInt = authState.userCurrentId;

                _showModalBottomSheet(context, notifier, userIdInt);
              },
              child: Text(
                "작업 로그 히스토리",
                style: context.bodyLarge.copyWith(
                  color: Colors.white,
                ), // 텍스트 스타일에도 컬러 명시
              ),
            ),
          ],
        ),
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

  Future<dynamic> _showModalBottomSheet(
    BuildContext context,
    MainViewModel notifier,
    int? userIdInt,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(width: 40, height: 4, color: Colors.grey[300]),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "작업 로그 히스토리",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                  // 11번 아이디 예시, 실제로는 변수를 넣으세요.
                  future: notifier.getHistoryDateList(userIdInt!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final dates = snapshot.data ?? [];

                    if (dates.isEmpty) {
                      return const Center(child: Text("저장된 로그 날짜가 없습니다."));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          tileColor: Colors.blueAccent.withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: const Icon(
                            Icons.history,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            dates[index],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // 1. 날짜 선택 팝업 닫기
                            Navigator.pop(context);

                            // 2. 상세 메시지 리스트 팝업 띄우기
                            _historyList(
                              context,
                              dates,
                              index,
                              notifier,
                              userIdInt,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _historyList(
    BuildContext context,
    List<String> dates,
    int index,
    MainViewModel notifier,
    int userIdInt,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        // 상세 로그는 좀 더 길게(80%) 보여주는 게 좋습니다.
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(width: 40, height: 4, color: Colors.grey[300]),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_note, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      "${dates[index]} 상세 로그",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: FutureBuilder<List<String>>(
                  // 뷰모델의 상세 로그 조회 함수 호출
                  future: notifier.getHistoryList(userIdInt!, dates[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data ?? [];

                    if (messages.isEmpty) {
                      return const Center(child: Text("해당 날짜에 기록된 메시지가 없습니다."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, mIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "• ",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  messages[mIndex],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
