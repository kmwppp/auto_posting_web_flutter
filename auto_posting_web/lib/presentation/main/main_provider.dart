import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_state.dart';
import 'main_viewmodel.dart';

// 실제 뷰모델과 연결한 프로바이더
final mainViewModelProvider = NotifierProvider<MainViewModel, MainState>(
  MainViewModel.new,
);

final proxyUrlControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

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

// 포트 번호 컨트롤러
final portControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 블로그 메인 키워드 컨트롤러
final mainKeyWordControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 블로그 제목 컨트롤러
final postingTitleWordControllerProvider = Provider.autoDispose((ref) {
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

// 링크 상단 문구 컨트롤러
final linkTopTextControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController(text: "자세한 정보는 아래에서 확인해보세요.");
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
  final controller = TextEditingController(
    text:
        "글 구성은 아래 구조를 반드시 따른다. 1. 서론 (약 300~400자) 2. 본문 섹션 4~5개   - 각 섹션마다 소제목 포함   - 섹션당 400~500자 분량   - 각 섹션에 어울리는 이미지 묘사 문장 1~2줄 포함3. 결론 (약 300~400자) 문체는 정보형 블로그 스타일로, 검색 유입을 고려해 자연스럽게 핵심 키워드를 반복 사용한다. 불필요한 군더더기 표현은 줄이고, 실제 사람이 쓴 글처럼 작성한다.",
  );
  ref.onDispose(() => controller.dispose());
  return controller;
});

// 발행 주기 컨트롤러
final postingCycleControllerProvider = Provider.autoDispose((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
