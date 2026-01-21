import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginButtonSection extends StatelessWidget {
  const LoginButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () {
            context.go("/main");
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Text("로그인", textAlign: TextAlign.center),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          height: 40,
          alignment: Alignment.center,
          child: Text("회원가입", textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
