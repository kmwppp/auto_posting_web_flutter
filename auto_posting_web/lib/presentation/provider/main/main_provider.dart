import 'package:auto_posting_web/presentation/viewmodel/main/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/main/main_viewmodel.dart';

// 실제 뷰모델과 연결한 프로바이더
final mainViewModelProvider = NotifierProvider<MainViewModel, MainState>(
  MainViewModel.new,
);

// 단순히 계정과 연결하여 추적하기 편하기 위하여 만든 프로바이더
// 아이디 컨트롤러
final idControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 비밀번호 컨트롤러
final pwControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 워드 프레스 URL 컨트롤러
final wordpressURLControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 블로그 제목 컨트롤러
final blogTitleControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// AI 글쓰기 지침 컨트롤러
final aiwriteOrderControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 발행 주기 컨트롤러
final postingCycleControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
