import 'package:freezed_annotation/freezed_annotation.dart';

part 'wordpress_state.freezed.dart';

@freezed
class WordpressState with _$WordpressState {
  const factory WordpressState({
    @Default(false) bool isLoading,
    @Default(false) bool isRunning, // 작업 실행 여부
    @Default([]) List<String> logs, // SSE 로그 리스트

    @Default('') String siteUrl,
    @Default('') String adminId,
    @Default('') String adminPassword,
    @Default('') String adSenseCode,
    @Default([]) List<Content> contents,
    String? errorMessage,
  }) = _WordpressState;
}

@freezed
class Content with _$Content {
  const factory Content({
    required String title,
    @Default('') String buttonUrl,
  }) = _Content;
}
