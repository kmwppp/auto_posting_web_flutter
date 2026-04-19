import 'dart:async';

import 'package:auto_posting_web/presentation/wordpress/presentation/providers/wordpress_provider.dart';
import 'package:auto_posting_web/presentation/wordpress/presentation/providers/wordpress_state.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/auth_provider.dart';

/// 유효성 검사 결과 모델
class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult(this.isValid, this.message);
}

final wordpressViewModelProvider =
    NotifierProvider<WordpressViewModel, WordpressState>(() {
      return WordpressViewModel();
    });

class WordpressViewModel extends Notifier<WordpressState> {
  StreamSubscription? _sseSubscription;

  @override
  WordpressState build() {
    return const WordpressState();
  }

  // 필드 업데이트
  void updateSiteUrl(String value) => state = state.copyWith(siteUrl: value);

  void updateAdminId(String value) => state = state.copyWith(adminId: value);

  void updateAdminPassword(String value) =>
      state = state.copyWith(adminPassword: value);

  void updateAdSenseCode(String value) =>
      state = state.copyWith(adSenseCode: value);

  /// 제목 리스트 생성
  void generateContents(String rawTitles) {
    final titles = rawTitles
        .split('\n')
        .where((t) => t.trim().isNotEmpty)
        .toList();

    final newContents = titles
        .map((title) => Content(title: title.trim()))
        .toList();

    state = state.copyWith(contents: newContents);
  }

  void updateContentUrl(int index, String url) {
    final newList = [...state.contents];
    newList[index] = newList[index].copyWith(buttonUrl: url);
    state = state.copyWith(contents: newList);
  }

  void removeContent(int index) {
    final newList = [...state.contents];
    newList.removeAt(index);
    state = state.copyWith(contents: newList);
  }

  /// 로그 추가
  void addLog(String log) {
    state = state.copyWith(logs: [...state.logs, log]);
  }

  /// 유효성 검사
  ValidationResult validateForPosting() {
    if (state.siteUrl.trim().isEmpty) {
      return ValidationResult(false, "워드프레스 사이트 주소를 입력해주세요.");
    }

    if (state.adminId.trim().isEmpty) {
      return ValidationResult(false, "관리자 아이디를 입력해주세요.");
    }

    if (state.adminPassword.trim().isEmpty) {
      return ValidationResult(false, "관리자 비밀번호를 입력해주세요.");
    }

    if (state.contents.isEmpty) {
      return ValidationResult(false, "발행할 포스트 내용이 없습니다.");
    }

    return ValidationResult(true, "");
  }

  Future<void> loadCredentials() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final authState = ref.read(authStateProvider);
      final int? userIdInt = authState.userCurrentId;
      final dataSource = ref.read(wordpressRemoteDataSourceProvider);
      final response = await dataSource.getCredentials(userIdInt!);

      print(response);
      state = state.copyWith(
        isLoading: false,
        siteUrl: response["wp_url"]?.toString() ?? "",
        adminId: response["wp_id"]?.toString() ?? "",
        adminPassword: response["wp_pw"]?.toString() ?? "",
        adSenseCode: response["adsence_code"]?.toString() ?? "",
      );
    } catch (e) {
      print(e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: "워드프레스 정보를 불러오지 못했습니다.",
      );
    }
  }

  /// 포스팅 시작
  Future<Map<String, dynamic>> startPosting(bool isReservation) async {
    state = state.copyWith(isLoading: true);

    final authState = ref.read(authStateProvider);
    final int? userIdInt = authState.userCurrentId;

    final dataSource = ref.read(wordpressRemoteDataSourceProvider);

    try {
      final payload = {
        "user_id": userIdInt,
        "wp_url": state.siteUrl,
        "wp_id": state.adminId,
        "wp_pw": state.adminPassword,
        "adsence_code": state.adSenseCode,
        "isReservation": isReservation,
        "posts": state.contents
            .map((e) => {"title": e.title, "button_url": e.buttonUrl})
            .toList(),
      };

      final response = await dataSource.postPostingData(payload);
      state = state.copyWith(isLoading: false);

      if (response["status"] == "success") {
        final streamUrl = response["streamUrl"];
        if (streamUrl != null && streamUrl.isNotEmpty) {
          final fullUrl = "https://hntrack.co.kr$streamUrl";
          connectStream(fullUrl);
        }

        return {
          "success": true,
          "message": response["message"] ?? "자동 포스팅 요청 완료",
        };
      }

      return {"success": false, "message": response["message"] ?? "요청 실패"};
    } catch (e) {
      state = state.copyWith(isLoading: false);

      return {"success": false, "message": "발행 요청 실패: $e"};
    }
  }

  void connectStream(String url) {
    print("🚀 SSE 연결 시작: $url");

    _sseSubscription?.cancel();

    state = state.copyWith(isRunning: true, logs: []);

    _sseSubscription =
        SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: url,
          header: {},
        ).listen(
          (event) {
            final data = event.data ?? "";
            print("📩 SSE 데이터: $data");

            /// 서버 종료 신호
            if (data.contains("close") || data.contains("작업이 모두 완료되었습니다")) {
              print("✅ 작업 완료 - 스트림 종료");
              stopStream();
              return;
            }

            if (data.isNotEmpty) {
              addLog(data);
            }
          },

          /// 에러 처리
          onError: (error) {
            print("❌ SSE 오류: $error");
            addLog("연결 오류: $error");
            state = state.copyWith(isRunning: false);
          },

          /// 서버가 스트림 닫음
          onDone: () {
            print("📡 SSE 스트림 종료됨");
            state = state.copyWith(isRunning: false);
          },
        );
  }

  /// 스트림 종료
  void stopStream() {
    print("🛑 SSE 스트림 중지");
    _sseSubscription?.cancel();
    _sseSubscription = null;
    state = state.copyWith(isRunning: false);
  }
}
