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
  // ✨ 스크롤 제어를 위한 컨트롤러 생성
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✨ 페이지가 메모리에 로드되자마자 실행됩니다.
    // 화면이 그려진 직후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStatusOnEntry();
    });
  }

  // 1. 진입점 (EntryPoint)
  void _checkStatusOnEntry() async {
    final authState = ref.read(authStateProvider);
    final int? userIdInt = authState.userCurrentId;

    if (userIdInt == null) return;

    // 데이터와 상태 체크를 순차적으로 실행
    await _loadSavedUserCredentials(userIdInt);
    await _checkActivePostingJob(userIdInt);
  }

  // 2. 저장된 계정 정보 로드 전용
  Future<void> _loadSavedUserCredentials(int userId) async {
    final bool hasData = await ref
        .read(mainViewModelProvider.notifier)
        .fetchSavedCredentials(userId);

    if (hasData && mounted) {
      debugPrint("✅ DB 계정 정보 로드 완료");

      // 불러온 계정 개수 확인
      final count = ref.read(mainViewModelProvider).userInfoList.length;

      // 스낵바 호출 (이미 로직이 수행되어 UI에 반영된 후 하단에 알림)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장된 계정 정보 $count건을 불러왔습니다."),
          duration: const Duration(seconds: 2),
          // 2초간 표시
          backgroundColor: Colors.blueGrey[800],
          // 배경색 살짝 어둡게
          behavior: SnackBarBehavior.floating,
          // 플로팅 스타일 (둥근 모서리)
          action: SnackBarAction(
            label: "확인",
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  // 3. 현재 진행 중인 작업 체크 및 다이얼로그 전용
  Future<void> _checkActivePostingJob(int userId) async {
    final bool isWorking = await ref
        .read(mainViewModelProvider.notifier)
        .postIsWorking(userId.toString());

    if (isWorking && mounted) {
      final msg = ref.read(mainViewModelProvider.notifier).dialogMsg;
      _showWorkingDialog(context, msg);

      // 알림 후 메세지 초기화
      ref.read(mainViewModelProvider.notifier).dialogMsg = "";
    }
  }

  void _showWorkingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // 확인을 눌러야만 닫히도록 설정
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
              // 1. 다이얼로그 닫기
              Navigator.pop(context);

              // 2. 스크롤을 최하단으로 부드럽게 이동 (약간의 딜레이를 주어 자연스럽게 처리)
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "네이버 포스팅 자동화 시스템",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController, // ✨ 컨트롤러 연결
          // 1. 스크롤 뷰로 감싸기
          padding: const EdgeInsets.symmetric(vertical: 20), // 전체적인 여백 설정 가능
          child: Column(
            // spacing: 20, // Flutter 최신 버전(3.24+)에서 사용 가능한 속성
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(context: context, title: "1. 블로그 계정 관리"),
              const SizedBox(height: 16),
              BlogAuthManageSection(),
              const SizedBox(height: 20),
              _sectionTitle(context: context, title: "2. 포스트 유형 및 내용"),
              const SizedBox(height: 16),
              PostTypeAndContentsSection(),
              const SizedBox(height: 20),
              _sectionTitle(context: context, title: "3. AI 글쓰기 설정"),
              const SizedBox(height: 16),
              PostAIWriteSettingSection(),
              const SizedBox(height: 20),
              // _sectionTitle(context: context, title: "4. AI 사진 생성 설정"),
              // const SizedBox(height: 16),
              // PostAIPhotoSettingSection(),
              const SizedBox(height: 20),
              _sectionTitle(context: context, title: "4. 발행 방식 설정"),
              const SizedBox(height: 16),
              PostingMethodSettingSection(),
              const SizedBox(height: 20),
              _sectionTitle(context: context, title: "5. 실행 및 결과"),
              const SizedBox(height: 16),
              RunAndResultSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Container _sectionTitle({
    required BuildContext context,
    required String title,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 50,
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text("$title", style: context.title),
      ),
    );
  }
}
