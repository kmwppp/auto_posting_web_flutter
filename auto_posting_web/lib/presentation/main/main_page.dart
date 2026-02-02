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

  void _checkStatusOnEntry() async {
    final authState = ref.read(authStateProvider);
    final int? userIdInt = authState.userCurrentId;

    if (userIdInt != null) {
      // 1. 상태 체크 실행 및 결과 받기
      final bool isWorking = await ref
          .read(mainViewModelProvider.notifier)
          .postIsWorking(userIdInt.toString());

      // 2. 결과가 true라면 다이얼로그 표시
      if (isWorking) {
        // ViewModel에 미리 세팅해둔 메세지 가져오기
        final msg = ref.read(mainViewModelProvider.notifier).dialogMsg;

        if (mounted) {
          // 💡 비동기 작업 후 컨텍스트가 유효한지 확인하는 습관!
          _showWorkingDialog(context, msg);
          // 메세지 초기화
          ref.read(mainViewModelProvider.notifier).dialogMsg = "";
        }
      }
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
