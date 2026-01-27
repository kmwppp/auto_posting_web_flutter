import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';
import 'auth_web_row.dart';

class AddAuth extends StatelessWidget {
  const AddAuth({super.key});

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("새 계정 추가", style: context.bodyLarge),
        // screenWidth > 600 ? AuthWebRow() : AuthMobileColumn(),
        AuthWebRow(),
      ],
    );
  }
}
