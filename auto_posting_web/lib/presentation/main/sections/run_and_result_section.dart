import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class RunAndResultSection extends StatelessWidget {
  const RunAndResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "자동 포스팅 발행 시작",
                style: context.title.copyWith(color: Colors.white),
              ),
            ),
          ),
          Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("작업 결과 로그", style: context.bodyLarge),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: BoxBorder.all(color: Colors.black),
                ),
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("테스트 텍스트\n테스트 텍스트\n테스트 텍스트\n테스트 텍스트"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
