import 'package:auto_posting_web/presentation/provider/main/main_provider.dart';
import 'package:auto_posting_web/presentation/view/main/sections/widgets/add_auth.dart';
import 'package:auto_posting_web/presentation/view/main/sections/widgets/auth_list_and_distribution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogAuthManageSection extends ConsumerWidget {
  BlogAuthManageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    return Container(
      width: double.infinity,
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddAuth(),
            Divider(),
            AuthListAndDistribution(state: state),
          ],
        ),
      ),
    );
  }
}
