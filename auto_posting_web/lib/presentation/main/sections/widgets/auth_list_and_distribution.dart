import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/user_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../main_enums.dart';
import '../../main_state.dart';
import 'common_radio_group.dart';

class AuthListAndDistribution extends ConsumerWidget {
  const AuthListAndDistribution({super.key, required this.state});

  final MainState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distributionType = ref.watch(
      mainViewModelProvider.select((s) => s.distributionType),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 섹션 타이틀 (통일된 스타일)
        _sectionTitle(context: context, title: "계정 목록 & 포스트 분배"),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "포스팅에 사용할 계정을 체크하고, 분배 방식을 선택하세요.",
                style: context.body.copyWith(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // 2. 계정 목록 리스트 박스
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black12,
                  ), // 검정 두꺼운 선에서 연한 선으로 변경
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: state.userInfoList.isEmpty
                      ? const Center(
                          child: Text(
                            "추가된 계정이 없습니다.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Column(
                          children: state.userInfoList.asMap().entries.map((
                            entry,
                          ) {
                            return UserInfoRow(index: entry.key);
                          }).toList(),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. 분배 방식 선택 (라벨 추가)
              _label("분배 방식 선택"),
              CommonRadioGroup<DistributionType>(
                groupValue: distributionType,
                items: [
                  CommonRadioItem(label: '자동 분배', value: DistributionType.auto),
                  CommonRadioItem(
                    label: '수동 분배',
                    value: DistributionType.manual,
                  ),
                ],
                onChanged: (value) => notifier.changeDistributionType(value!),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // --- 통일된 섹션 스타일 헬퍼 메서드 ---
  Widget _sectionTitle({required BuildContext context, required String title}) {
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
        child: Text(
          title,
          style: context.title.copyWith(
            color: Colors.blueGrey[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );
}
