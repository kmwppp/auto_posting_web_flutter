import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.inputHint,
    required this.controller,
  });

  final String inputHint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: inputHint,
        ),
        style: context.body,
      ),
    );
  }
}
