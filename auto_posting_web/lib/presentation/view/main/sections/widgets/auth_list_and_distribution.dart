import 'package:auto_posting_web/presentation/view/main/sections/widgets/select_distribution_type.dart';
import 'package:auto_posting_web/presentation/view/main/sections/widgets/user_info_row.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../viewmodel/main/main_state.dart';

class AuthListAndDistribution extends StatelessWidget {
  const AuthListAndDistribution({super.key, required this.state});

  final MainState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("계정 목록 & 포스트 분배", style: context.bodyLarge),
        Text("포스팅에 사용할 계정을 체크하고, 분배 방식을 선택하세요.", style: context.body),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: state.userInfoList.isEmpty
                  ? [Center(child: Text("추가된 계정이 없습니다."))]
                  : state.userInfoList.asMap().entries.map((entry) {
                      int index = entry.key; // 여기에 index가 들어있습니다.

                      return UserInfoRow(index: index);
                    }).toList(),
            ),
            // child: Center(child: Text("추가된 계정이 없습니다.")),
          ),
        ),
        SelectDistributionType(),
      ],
    );
  }
}
