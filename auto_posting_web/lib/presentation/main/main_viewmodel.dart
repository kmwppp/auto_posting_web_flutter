import 'dart:async';
import 'dart:convert';

import 'package:auto_posting_web/data/model/blog_title_info_model.dart';
import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/provider_container.dart';
import 'main_enums.dart';
import 'main_provider.dart';
import 'main_state.dart';

class MainViewModel extends Notifier<MainState> {
  String dialogMsg = "";
  StreamSubscription<String>? _logSubscription;

  @override
  MainState build() {
    return MainState.initial();
  }

  /// 블로그를 쓰기위한 계정 추가 로직
  void addUserInfo({required String userId, required String userPassword}) {
    if (_isNullVaildChk(str1: userId, str2: userPassword)) {
      List<MainUserInfoModel> list = state.userInfoList;
      MainUserInfoModel model = MainUserInfoModel(
        userId: userId,
        userPassword: userPassword,
        postingCount: state.distributionType == DistributionType.auto ? 5 : 0,
        isPostingCheck: false,
        proxy_id: '',
        proxy_pw: '',
        port: '',
      );
      list.add(model);

      state = state.copyWith(userInfoList: list);
    }

    print("state.userInfoList: ${state.userInfoList.length}");
  }

  void updateProxyId({required int index, required String id}) {
    final newList = [...state.userInfoList];
    // 해당 인덱스의 모델만 copyWith로 포트 번호 교체
    newList[index] = newList[index].copyWith(proxy_id: id);

    state = state.copyWith(userInfoList: newList);
  }

  void updateProxyPw({required int index, required String pw}) {
    final newList = [...state.userInfoList];
    // 해당 인덱스의 모델만 copyWith로 포트 번호 교체
    newList[index] = newList[index].copyWith(proxy_pw: pw);

    state = state.copyWith(userInfoList: newList);
  }

  void updatePort({required int index, required String port}) {
    final newList = [...state.userInfoList];
    // 해당 인덱스의 모델만 copyWith로 포트 번호 교체
    newList[index] = newList[index].copyWith(port: port);

    state = state.copyWith(userInfoList: newList);
  }

  void updatePostingCount({required int index, required String postingCount}) {
    // 사용자가 다 지웠을 때는 0으로 강제 변환하기보다 빈 상태를 유지하는 게 입력하기 편합니다.
    if (postingCount.isEmpty) {
      // 필요한 경우 빈 값 처리 로직 (예: state에 0 저장 혹은 이전 값 유지)
    }

    final newList = [...state.userInfoList];
    int count = int.tryParse(postingCount) ?? 0;
    newList[index] = newList[index].copyWith(postingCount: count);
    state = state.copyWith(userInfoList: newList);
  }

  void removeUserInfo({required int index}) {
    final newList = [...state.userInfoList];
    newList.removeAt(index);
    state = state.copyWith(userInfoList: newList);
  }

  void addBlogInfoSingle({
    required String mainKeyword,
    required String postingTitle,
  }) {
    if (_isNullVaildChk(str1: mainKeyword, str2: postingTitle)) {
      final list = [...state.titleList];
      BlogTitleInfoModel model = BlogTitleInfoModel(
        main_keyword: mainKeyword,
        posting_title: postingTitle,
      );
      list.add(model);

      state = state.copyWith(titleList: list);
    }
  }

  void addBlogInfoMulti({
    required String mainKeyword,
    required String postingTitle,
  }) {
    final keywords = mainKeyword
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final titles = postingTitle
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    final list = [...state.titleList];

    // 두 리스트 중 짧은 쪽 길이에 맞춰 생성
    int count = keywords.length < titles.length
        ? keywords.length
        : titles.length;

    for (int i = 0; i < count; i++) {
      list.add(
        BlogTitleInfoModel(
          main_keyword: keywords[i].trim(),
          posting_title: titles[i].trim(),
        ),
      );
    }

    state = state.copyWith(titleList: list);
  }

  void resetBlogInfoModel() {
    state = state.copyWith(titleList: []);
  }

  void removeBlogInfo({required int index}) {
    final newList = [...state.titleList];
    newList.removeAt(index);
    state = state.copyWith(titleList: newList);
  }

  void userCheckChange({required int index}) {
    final newList = [...state.userInfoList];

    // 2. 해당 인덱스의 객체를 copyWith로 새로 생성하여 교체
    newList[index] = newList[index].copyWith(
      isPostingCheck: !newList[index].isPostingCheck,
    );

    // 3. state 전체를 새 객체로 갈기
    state = state.copyWith(userInfoList: newList);

    print(state.userInfoList[index].isPostingCheck);
  }

  bool _isNullVaildChk({required String str1, required String str2}) {
    if (str1 == "" || str2 == "") {
      return false;
    }
    return true;
  }

  void changeIsProxySetting(bool value) {
    state = state.copyWith(isProxySetting: value);
  }

  void changeDistributionType(DistributionType type) {
    if (type == DistributionType.auto) {
      // 자동이면 각 계정에 5개 씩 분배
      final newList = state.userInfoList
          .map((user) => user.copyWith(postingCount: 5))
          .toList();
      state = state.copyWith(userInfoList: newList);
    }
    state = state.copyWith(distributionType: type);
  }

  void changePostType(PostType type) {
    state = state.copyWith(postType: type);
  }

  void changeBlogInsertType(BlogInsertType type) {
    state = state.copyWith(blogInsertType: type);
    ref.read(mainKeyWordControllerProvider).clear();
    ref.read(blogTitleControllerProvider).clear();
  }

  void changeCreatePostType(CreatePostType type) {
    state = state.copyWith(createPostType: type);
  }

  void changeisQRLinkChange(bool value) {
    state = state.copyWith(isQRLinkChange: value);
  }

  void updateAIImgCount(double value) {
    state = state.copyWith(aiImgCount: value);
  }

  void updateImageStyle(AIPhotoType type) {
    state = state.copyWith(selectedImageStyle: type);
  }

  void changePostingType(PostingType type) {
    state = state.copyWith(postingType: type);
  }

  bool isChkProxy() {
    return state.isProxySetting;
  }

  /// 1. 프록시 설정을 정말 안할건지
  /// 2. 계정이 추가되지 않았을때
  /// 3. 계정이 추가되었고, 수동 분배일 때 갯수가 0개인 userInfo가 있을때
  /// 4. 계정이 추가되었고, 프록시가 ON이며, proxyInfo가 비어있을 때,
  /// 5. 워드프레스 사이트 URL이 아무것도 적혀 있지 않을 때
  /// 6. 블로그 메인 키워드 및 제목 리스트가 0일 때
  /// 7. 글쓰기 지침이 비어 있을 때
  /// 8. 발행 주기가 비어 있을 때
  // MainViewModel 안의 함수
  ValidationResult isChkValidation() {
    // 1. 계정 추가 여부
    if (state.userInfoList.isEmpty) {
      return ValidationResult(false, "네이버 계정을 추가해주세요.");
    }

    // 2. 수동 분배 시 계정 정보 검증
    if (state.distributionType == DistributionType.manual) {
      for (int i = 0; i < state.userInfoList.length; i++) {
        final user = state.userInfoList[i];
        if (user.postingCount <= 0) {
          return ValidationResult(false, "${i + 1}번째 계정의 포스팅 갯수를 입력해주세요.");
        }
        if (state.isProxySetting &&
            (user.proxy_id == "" || user.proxy_pw == "" || user.port == "")) {
          return ValidationResult(false, "${i + 1}번째 계정의 프록시 정보를 입력해주세요.");
        }
      }
    }

    for (int i = 0; i < state.userInfoList.length; i++) {
      final user = state.userInfoList[i];
      if (state.isProxySetting &&
          (user.proxy_id == "" || user.proxy_pw == "" || user.port == "")) {
        return ValidationResult(false, "${i + 1}번째 계정의 프록시 정보를 입력해주세요.");
      }
    }

    // 3. 워드프레스 URL
    if (ref.read(wordpressURLControllerProvider).text.trim().isEmpty) {
      return ValidationResult(false, "워드프레스 사이트 URL을 입력해주세요.");
    }

    // 4. 제목 리스트
    if (state.titleList.isEmpty) {
      return ValidationResult(false, "메인 키워드 및 제목을 추가해주세요.");
    }

    // 5. 발행 주기
    final term =
        int.tryParse(ref.read(postingCycleControllerProvider).text) ?? 0;
    if (term <= 0) {
      return ValidationResult(false, "올바른 발행 주기를 입력해주세요.");
    }

    // 모든 검증 통과
    return ValidationResult(true, "");
  }

  // [수정] 로그 수신 전용 메서드
  void _listenToLogs(String userId) {
    // 기존 로그 초기화
    state = state.copyWith(logList: []);

    // 기존에 돌고 있는 구독이 있다면 먼저 닫아줍니다.
    _logSubscription?.cancel();

    // 1. 유즈케이스 가져오기
    final subscribeUseCase = ref.read(subscribeLogUseCaseProvider);

    // 2. 스트림 구독 시작 (Base URL은 DataSource나 UseCase 내부에서 이미 처리되지만, 필요시 조합)
    // 1. 실행 결과를 변수에 할당
    _logSubscription = subscribeUseCase
        .execute(userId)
        .listen(
          (newLog) {
            // 2. 서버에서 보낸 "close" 이벤트 감지 (데이터 포맷에 따라 조건문 조정 필요)
            if (newLog.contains("close") || newLog.contains("작업이 모두 완료되었습니다")) {
              print("✅ 모든 작업 완료 신호 수신. 스트림을 닫습니다.");
              _closeStream(); // 스트림 종료 함수 호출
              return;
            }

            if (newLog.isNotEmpty) {
              state = state.copyWith(logList: [...state.logList, newLog]);
            }
          },
          onError: (error) {
            print("SSE 에러 발생: $error");
            state = state.copyWith(
              logList: [...state.logList, "연결 에러 발생: $error"],
            );
          },
          onDone: () {
            print("📡 서버에 의해 스트림이 완전히 닫혔습니다.");
          },
        );
  }

  // 3. 스트림을 안전하게 닫는 함수
  void _closeStream() {
    _logSubscription?.cancel();
    _logSubscription = null;
    // 필요하다면 여기서 '완료' 상태를 state에 반영
    state = state.copyWith(
      logList: [...state.logList, "🏁 모든 포스팅 작업이 종료되었습니다."],
    );
  }

  // 서버로 보낼 JSON 매핑 메소드
  // [수정] 서버로 보낼 JSON 매핑 메소드
  Future<void> sendToServer() async {
    state = state.copyWith(isLoading: true);

    // 1. 컨트롤러들로부터 값 추출 (기존과 동일)
    final proxyUrl = ref.read(proxyUrlControllerProvider).text;
    final siteUrl = ref.read(wordpressURLControllerProvider).text;
    final aiWriteRole = ref.read(aiwriteOrderControllerProvider).text;
    final postingTerm =
        int.tryParse(ref.read(postingCycleControllerProvider).text) ?? 0;

    // 2. JSON 데이터 구성 (기존과 동일)
    final Map<String, dynamic> requestData = {
      "proxy": proxyUrl,
      "proxyUse": state.isProxySetting,
      "authList": state.userInfoList.map((e) => e.toJson()).toList(),
      "postType": state.postType.name,
      "siteUrl": siteUrl,
      "postTitle": state.titleList.map((e) => e.toJson()).toList(),
      "autoChangeQRLink": state.isQRLinkChange,
      "aiWriteRole": aiWriteRole,
      "postingTerm": postingTerm,
      "postingTermType": state.postingType.name,
    };

    try {
      final useCase = ref.read(sendPostingDataUseCaseProvider);
      final result = await useCase.execute(requestData);

      // [디버깅 추가] 서버가 준 데이터의 '진짜 타입'을 로그창에 찍어보세요.
      print("DEBUG: 서버 응답 타입: ${result.runtimeType}");
      print("DEBUG: 서버 응답 실제 내용: $result");

      // 만약 String으로 들어온다면 JSON으로 변환해주는 로직 추가
      dynamic finalResult = result;
      if (result is String) {
        finalResult = jsonDecode(result);
      }

      // 1. finalResult로 체크
      if (finalResult == null || finalResult is! Map) {
        state = state.copyWith(
          logList: [...state.logList, "서버 데이터 형식 오류 (${result.runtimeType})"],
        );
        return;
      }

      // 2. 변환
      final response = Map<String, dynamic>.from(finalResult);

      // 3. 'status' 키가 존재하는지 확인 후 처리
      if (response['status'] == 'success') {
        print("서버 전송 성공");

        final String userIdFromRoot =
            response['currentUserId']?.toString() ?? "";

        if (userIdFromRoot.isNotEmpty) {
          _listenToLogs(userIdFromRoot);
        } else {
          state = state.copyWith(
            logList: [...state.logList, "서버 응답에 사용자 ID가 없습니다."],
          );
        }
      } else {
        final errorMsg = response['message'] ?? "알 수 없는 에러";
        print("서버 응답 오류: $errorMsg");
        state = state.copyWith(logList: [...state.logList, "서버 오류: $errorMsg"]);
      }
    } catch (e) {
      print("통신 실패 상세: $e");
      state = state.copyWith(logList: [...state.logList, "통신 실패: $e"]);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult(this.isValid, this.message);
}
