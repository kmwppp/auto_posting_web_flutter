import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';
import 'auth_web_row.dart';

class AddAuth extends StatelessWidget {
  const AddAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 섹션 타이틀 (Wordpress 스타일 적용)
        _sectionTitle(
          context: context,
          title: "새 계정 추가",
          trailing: Text(
            "※ 이 계정은 2차 로그인이 없어야 합니다.",
            style: context.body.copyWith(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. 안내 문구 스타일링
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  "계정은 추가 시 즉시 저장되며, 아래 리스트에서 삭제 시 서버 데이터도 함께 삭제됩니다.",
                  style: context.body.copyWith(
                    color: Colors.blueGrey[600],
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. 계정 입력 로우 (기존 AuthWebRow 유지)
              const AuthWebRow(),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // --- 통일된 섹션 스타일 헬퍼 메서드 ---
  Widget _sectionTitle({
    required BuildContext context,
    required String title,
    Widget? trailing,
  }) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.title.copyWith(
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
