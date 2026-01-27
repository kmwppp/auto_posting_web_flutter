import 'package:auto_posting_web/presentation/main/sections/blog_auth_manage_section.dart';
import 'package:auto_posting_web/presentation/main/sections/post_ai_write_setting_section.dart';
import 'package:auto_posting_web/presentation/main/sections/post_type_and_contents_section.dart';
import 'package:auto_posting_web/presentation/main/sections/posting_method_setting_section.dart';
import 'package:auto_posting_web/presentation/main/sections/run_and_result_section.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
