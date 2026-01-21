import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/main/main_provider.dart';
import '../../../../viewmodel/main/main_state.dart';

class SelectDistributionType extends ConsumerWidget {
  const SelectDistributionType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distributionType = ref.watch(
      mainViewModelProvider.select((s) => s.distributionType),
    );
    final notifier = ref.read(mainViewModelProvider.notifier);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Radio<DistributionType>(
                groupValue: distributionType,
                // onchange의 value는 Distribution.auto로 설정함
                value: DistributionType.auto,
                onChanged: (value) => notifier.changeDistributionType(value!),
              ),
              const Text('자동 분배'),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<DistributionType>(
                groupValue: distributionType,
                // onchange의 value는 Distribution.manual 설정함
                value: DistributionType.manual,
                onChanged: (value) => notifier.changeDistributionType(value!),
              ),
              const Text('수동 분배'),
            ],
          ),
        ),
      ],
    );
  }
}
