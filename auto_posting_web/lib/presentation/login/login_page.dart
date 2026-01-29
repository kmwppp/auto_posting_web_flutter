import 'package:auto_posting_web/presentation/login/login_provider.dart';
import 'package:auto_posting_web/presentation/login/sections/login_button_section.dart';
import 'package:auto_posting_web/presentation/login/sections/login_input_section.dart';
import 'package:auto_posting_web/presentation/login/widgets/login_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black12,
          appBar: LoginAppbar(),
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoginInputSection(),
                    Divider(),
                    LoginButtonSection(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // if (state.isLoading) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // 화면을 어둡게 함
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white, // 인디케이터 색상
        ),
      ),
    );
  }
}
