import 'package:flutter/material.dart';

class PostingCountField extends StatefulWidget {
  final int initialValue;
  final Function(String) onChanged;

  const PostingCountField({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PostingCountField> createState() => _PostingCountFieldState();
}

class _PostingCountFieldState extends State<PostingCountField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(PostingCountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부(State)에서 값이 강제로 바뀌었을 때만 컨트롤러 텍스트 업데이트
    if (widget.initialValue.toString() != _controller.text &&
        widget.initialValue.toString() != "0") {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textAlign: TextAlign.center,
      onChanged: widget.onChanged, // 여기서 부모의 notifier 호출
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.number,
    );
  }
}
