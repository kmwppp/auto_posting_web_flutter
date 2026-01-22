import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CommonRadioItem<T> {
  final String label;
  final T value;

  CommonRadioItem({required this.label, required this.value});
}

class CommonRadioGroup<T> extends StatelessWidget {
  final T groupValue;
  final List<CommonRadioItem<T>> items;
  final ValueChanged<T> onChanged;

  const CommonRadioGroup({
    super.key,
    required this.groupValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: InkWell(
            // 1. 클릭 시 물결 효과가 둥글게 퍼지도록 설정 (선택사항)
            borderRadius: BorderRadius.circular(8),
            // 2. 전체 Row 클릭 시 onChanged 호출
            onTap: () => onChanged(item.value),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ), // 클릭 영역 확보
              child: Row(
                children: [
                  Radio<T>(
                    value: item.value,
                    groupValue: groupValue,
                    onChanged: (value) {
                      if (value != null) onChanged(value);
                    },
                  ),
                  // 3. 텍스트 영역도 클릭 범위에 포함됨
                  Text(item.label, style: context.bodyLarge),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
