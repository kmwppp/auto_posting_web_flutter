import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class BlogAuthManageSection extends StatelessWidget {
  const BlogAuthManageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddAuth(),
            Divider(),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("계정 목록 & 포스트 분배", style: context.bodyLarge),
                Text("포스팅에 사용할 계정을 체크하고, 분배 방식을 선택하세요.", style: context.body),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: BoxBorder.all(color: Colors.black, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(child: Text("추가된 계정이 없습니다.")),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddAuth extends StatelessWidget {
  const AddAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("1. 블로그 계정 관리", style: context.title),
        Divider(),
        Text("새 계정 추가", style: context.bodyLarge),
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: _inputUserInfo(context: context, inputHint: "네이버 아이디"),
            ),
            Expanded(
              child: _inputUserInfo(context: context, inputHint: "네이버 비밀번호"),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Text("계정 추가", textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ClipRRect _inputUserInfo({
    required BuildContext context,
    required String inputHint,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          onChanged: (value) {
            // onChanged(value);
          },
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: inputHint,
          ),
          style: context.body,
        ),
      ),
    );
  }
}
