import 'package:auto_posting_web/presentation/main/sections/blog_auth_manage_section.dart';
import 'package:auto_posting_web/presentation/main/sections/post_ai_write_setting_section.dart';
import 'package:auto_posting_web/presentation/main/sections/post_type_and_contents_section.dart';
import 'package:auto_posting_web/presentation/main/sections/posting_method_setting_section.dart';
import 'package:auto_posting_web/presentation/main/sections/run_and_result_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_text_styles.dart';
import '../../routes/auth_provider.dart';
import 'main_provider.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStatusOnEntry();
    });
  }

  void _checkStatusOnEntry() async {
    final authState = ref.read(authStateProvider);
    final int? userIdInt = authState.userCurrentId;
    if (userIdInt == null) return;

    await _loadSavedUserCredentials(userIdInt);
    await _checkActivePostingJob(userIdInt);
  }

  Future<void> _loadSavedUserCredentials(int userId) async {
    final bool hasData = await ref
        .read(mainViewModelProvider.notifier)
        .fetchSavedCredentials(userId);
    if (hasData && mounted) {
      final count = ref.read(mainViewModelProvider).userInfoList.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장된 정보와 계정 정보 $count건을 불러왔습니다."),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blueGrey[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _checkActivePostingJob(int userId) async {
    final bool isWorking = await ref
        .read(mainViewModelProvider.notifier)
        .postIsWorking(userId.toString());
    if (isWorking && mounted) {
      final msg = ref.read(mainViewModelProvider.notifier).dialogMsg;
      _showWorkingDialog(context, msg);
      ref.read(mainViewModelProvider.notifier).dialogMsg = "";
    }
  }

  void _showWorkingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sync, color: Colors.blue),
            SizedBox(width: 10),
            Text("작업 재개"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold 제거, 상위 NavigationPage의 body로 들어감
    return SafeArea(
      // 1. 스크롤 뷰를 최상단으로 빼서 브라우저 전체 스크롤 사용
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          // 2. 내부 콘텐츠만 최대 1000px로 제한하여 중앙 정렬
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              // 가로/세로 여백은 여기서 관리
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section("1. 블로그 계정 관리", BlogAuthManageSection()),
                  _section(
                    "2. 포스트 유형 및 내용",
                    const PostTypeAndContentsSection(),
                  ),
                  _section("3. AI 글쓰기 설정", const PostAIWriteSettingSection()),
                  _section("4. 발행 방식 설정", const PostingMethodSettingSection()),
                  _section("5. 실행 및 결과", const RunAndResultSection()),

                  // 하단 여유 공간 (스크롤 끝자락 확보)
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget sectionWidget) {
    return Column(
      children: [
        _sectionTitle(title: title),
        const SizedBox(height: 16),
        sectionWidget,
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _sectionTitle({required String title}) {
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
}
