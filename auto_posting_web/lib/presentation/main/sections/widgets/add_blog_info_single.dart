import 'package:auto_posting_web/presentation/main/sections/widgets/blog_info_column.dart';
import 'package:flutter/material.dart';

class AddBlogInfoSingle extends StatelessWidget {
  const AddBlogInfoSingle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // 소제목 라벨 스타일 적용
        _label("새 메인키워드 및 제목 추가"),
        const BlogInfoColumn(),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );
}
