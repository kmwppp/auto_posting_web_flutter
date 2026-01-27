import 'package:flutter/material.dart';

class LoginAppbar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(backgroundColor: Colors.grey, title: Text("네이버 포스팅 자동화 시스템"));
  }
}
