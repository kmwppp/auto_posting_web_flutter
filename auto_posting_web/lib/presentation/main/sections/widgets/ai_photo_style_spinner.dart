import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main_enums.dart';
import '../../main_provider.dart';

class AIPhotoStyleSpinner extends ConsumerWidget {
  const AIPhotoStyleSpinner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 선택된 스타일 값만 구독
    final selectedStyle = ref.watch(
      mainViewModelProvider.select((s) => s.selectedImageStyle),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AIPhotoType>(
          value: selectedStyle,
          isExpanded: true,
          // 2. Enum.values를 바로 사용하여 아이템 리스트 생성
          items: AIPhotoType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.label, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              // 3. ViewModel의 상태 변경 함수 호출
              notifier.updateImageStyle(value);
            }
          },
        ),
      ),
    );
  }
}
