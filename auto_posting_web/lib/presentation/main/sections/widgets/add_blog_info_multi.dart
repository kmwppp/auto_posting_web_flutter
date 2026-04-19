import 'package:auto_posting_web/presentation/main/sections/widgets/blog_info_row.dart';
import 'package:flutter/material.dart';

class AddBlogInfoMulti extends StatelessWidget {
  const AddBlogInfoMulti({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _label("새 메인키워드 및 제목 일괄 추가"),
        const BlogInfoRow(),
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
