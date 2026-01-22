import 'package:auto_posting_web/presentation/main/main_provider.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/add_auth.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/auth_list_and_distribution.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/insert_proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogAuthManageSection extends ConsumerWidget {
  BlogAuthManageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InsertProxy(),
            Divider(),
            AddAuth(),
            Divider(),
            AuthListAndDistribution(state: state),
          ],
        ),
      ),
    );
  }
}
