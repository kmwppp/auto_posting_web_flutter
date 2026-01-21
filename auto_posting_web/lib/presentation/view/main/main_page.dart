import 'package:auto_posting_web/presentation/view/main/sections/blog_auth_manage_section.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("네이버 포스팅 자동화 시스템")),
      body: SafeArea(
        child: Column(
          children: [
            BlogAuthManageSection(),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blueGrey,
              child: Column(children: [Text("계정 목록 및 자동분배, 수동분배 입력 섹션")]),
            ),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blueAccent,
              child: Column(children: [Text("포스트 유형 선택 및 내용 입력 섹션")]),
            ),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blueGrey,
              child: Column(children: [Text("AI 글쓰기 설정 섹션")]),
            ),
          ],
        ),
      ),
    );
  }
}
