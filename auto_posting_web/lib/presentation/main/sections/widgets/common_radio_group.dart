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
        final bool isSelected = groupValue == item.value;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0), // 아이템 간 간격
            child: InkWell(
              onTap: () => onChanged(item.value),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  // 선택 시 연한 배경색, 미선택 시 흰색
                  color: isSelected ? Colors.blueGrey[50] : Colors.white,
                  border: Border.all(
                    // 선택 시 진한 테두리, 미선택 시 연한 테두리
                    color: isSelected ? Colors.blueGrey[800]! : Colors.black12,
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Radio<T>(
                        value: item.value,
                        groupValue: groupValue,
                        // Beanz 테마 컬러 적용
                        activeColor: Colors.blueGrey[800],
                        onChanged: (value) {
                          if (value != null) onChanged(value);
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: context.body.copyWith(
                        color: isSelected
                            ? Colors.blueGrey[900]
                            : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
