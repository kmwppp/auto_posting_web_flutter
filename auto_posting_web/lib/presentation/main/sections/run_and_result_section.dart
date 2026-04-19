import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/auth_provider.dart';
import '../main_state.dart';
import '../main_viewmodel.dart';

class RunAndResultSection extends ConsumerWidget {
  const RunAndResultSection({super.key});

  // 검증 및 시작 로직
  Future<void> _handleStartPosting(
    BuildContext context,
    WidgetRef ref,
    MainViewModel notifier,
    MainState state,
  ) async {
    final validation = notifier.isChkValidation();
    if (!validation.isValid) {
      await _showAlertDialog(context, message: validation.message);
      return;
    }

    final response = await notifier.sendToServer();
    if (context.mounted) {
      await _showAlertDialog(context, message: response.msg);
    }
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
          // 1. 섹션 헤더 (Beanz 통일 스타일)
          _sectionTitle(context: context, title: "프로그램 실행 및 결과"),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // 2. 메인 액션 버튼 (전체 너비)
                SizedBox(
                  width: double.infinity,
                  child: state.isRunning
                      ? _buildStopButton(context, ref, notifier, state)
                      : _buildStartButton(context, ref, notifier, state),
                ),
                const SizedBox(height: 32),

                // 3. 로그 헤더 영역
                _buildLogHeader(context, ref, notifier),
                const SizedBox(height: 12),

                // 4. 터미널 스타일 로그창
                _buildTerminalView(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI 컴포넌트 구성 요소 ---

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

  Widget _buildStartButton(
    BuildContext context,
    WidgetRef ref,
    MainViewModel notifier,
    MainState state,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
      ),
      onPressed: state.isLoading
          ? null
          : () => _handleStartPosting(context, ref, notifier, state),
      child: state.isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                "자동 포스팅 발행 시작",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
      ),
      onPressed: state.isStopLoading
          ? null
          : () async {
              final userIdInt = ref.read(authStateProvider).userCurrentId;
              if (userIdInt == null) return;
              final isStopped = await notifier.postStopWorking(
                userIdInt.toString(),
              );
              if (context.mounted) {
                _showResultDialog(
                  context,
                  isStopped ? "작업 중단 요청 성공" : "중단 불가",
                  isStopped
                      ? "중단 요청을 완료했습니다. 로그를 확인해주세요."
                      : "실행 중인 작업이 없거나 이미 종료되었습니다.",
                );
              }
            },
      child: state.isStopLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                "자동 포스팅 중단",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget _buildLogHeader(
    BuildContext context,
    WidgetRef ref,
    MainViewModel notifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.terminal, size: 20, color: Colors.blueGrey[800]),
            const SizedBox(width: 8),
            Text(
              "작업 결과 로그",
              style: context.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            final userIdInt = ref.read(authStateProvider).userCurrentId;
            _showModalBottomSheet(context, notifier, userIdInt);
          },
          icon: const Icon(Icons.history, size: 18),
          label: const Text("과거 로그 조회"),
          style: TextButton.styleFrom(foregroundColor: Colors.blueGrey[600]),
        ),
      ],
    );
  }

  Widget _buildTerminalView(BuildContext context, WidgetRef ref) {
    final logList = ref.watch(mainViewModelProvider.select((s) => s.logList));
    final scrollController = ScrollController();

    // 로그 추가 시 부드러운 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), // 조금 더 부드럽게
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.all(12),
      child: logList.isEmpty
          ? const Center(
              child: Text(
                "대기 중... 작업을 시작하면 로그가 표시됩니다.",
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            )
          : ListView.builder(
              controller: scrollController,
              itemCount: logList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        // 화살표 기호에 포인트를 줌
                        const TextSpan(
                          text: "> ",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: logList[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // --- 헬퍼 메서드 (기존 로직 유지하되 스타일 소폭 수정) ---

  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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

  Future<dynamic> _showModalBottomSheet(
    BuildContext context,
    MainViewModel notifier,
    int? userIdInt,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 투명 배경을 통해 하단 시트 곡선 강조
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // 상단 드래그 핸들
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  "작업 로그 히스토리",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238), // blueGrey[900] 계열
                  ),
                ),
              ),

              Expanded(
                child: FutureBuilder<List<String>>(
                  future: notifier.getHistoryDateList(userIdInt!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
                      );
                    }

                    final dates = snapshot.data ?? [];

                    if (dates.isEmpty) {
                      return Center(
                        child: Text(
                          "저장된 로그 내역이 없습니다.",
                          style: TextStyle(color: Colors.blueGrey[300]),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: dates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          // Beanz 테마색 적용 (연한 blueGrey)
                          tileColor: Colors.blueGrey[50],
                          hoverColor: Colors.blueGrey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.blueGrey[100]!.withOpacity(0.5),
                            ),
                          ),
                          leading: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.blueGrey[700],
                            size: 20,
                          ),
                          title: Text(
                            dates[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[900],
                              fontSize: 15,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.blueGrey[400],
                          ),
                          onTap: () {
                            Navigator.pop(context);
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
              const SizedBox(height: 24),
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
      backgroundColor: Colors.transparent, // 배경 투명 처리로 둥근 모서리 유지
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // 상단 핸들 바
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_note, color: Colors.blueGrey[800]),
                    const SizedBox(width: 12),
                    Text(
                      "${dates[index]} 상세 로그",
                      style: context.title.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              Expanded(
                child: FutureBuilder<List<String>>(
                  future: notifier.getHistoryList(userIdInt, dates[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
                      );
                    }

                    final messages = snapshot.data ?? [];

                    if (messages.isEmpty) {
                      return Center(
                        child: Text(
                          "기록된 로그 메시지가 없습니다.",
                          style: TextStyle(color: Colors.blueGrey[300]),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, mIndex) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 전문적인 느낌의 불렛 포인트
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                messages[mIndex],
                                style: context.body.copyWith(
                                  color: Colors.blueGrey[900],
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
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

  Future<void> _showAlertDialog(
    BuildContext context, {
    required String message,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
            SizedBox(width: 8),
            Text(
              "알림",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
        actions: [
          SizedBox(
            width: double.infinity, // 버튼을 꽉 차게 배치하여 모바일/웹 최적화
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ),
        ],
      ),
    );
  }
}
