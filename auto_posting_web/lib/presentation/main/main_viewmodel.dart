import 'dart:async';
import 'dart:convert';

import 'package:auto_posting_web/data/model/blog_title_info_model.dart';
import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/provider_container.dart';
import 'data/model/main_return_model.dart';
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
  void addUserInfo({
    required int? currentUserId,
    required String userId,
    required String userPassword,
  }) {
    String current = currentUserId?.toString() ?? "";
    print("currentId: $current");
    if (_isNullVaildChk(str1: userId, str2: userPassword)) {
      List<MainUserInfoModel> list = state.userInfoList;
      MainUserInfoModel model = MainUserInfoModel(
        currentUserId: current,
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
  void _listenToLogs(String streamUrl) {
    print("🚀 [SSE] _listenToLogs 시작됨 - 전달받은 URL: $streamUrl");
    // 기존 로그 초기화
    state = state.copyWith(logList: []);

    // 기존 구독 취소 확인
    if (_logSubscription != null) {
      print("🔄 [SSE] 기존 구독이 존재하여 취소합니다.");
      _logSubscription?.cancel();
    }

    // 1. 유즈케이스 가져오기
    final subscribeUseCase = ref.read(subscribeLogUseCaseProvider);
    print("📡 [SSE] 스트림 구독(listen) 시도 중...");
    // 2. 스트림 구독 시작 (Base URL은 DataSource나 UseCase 내부에서 이미 처리되지만, 필요시 조합)
    // 1. 실행 결과를 변수에 할당
    _logSubscription = subscribeUseCase
        .execute(streamUrl)
        .listen(
          (newLog) {
            print("📩 [SSE 수신 데이터]: $newLog");
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
    print("🔌 [SSE] _closeStream() 호출됨");
    _logSubscription?.cancel();
    _logSubscription = null;
    // 필요하다면 여기서 '완료' 상태를 state에 반영
    state = state.copyWith(
      logList: [...state.logList, "🏁 모든 포스팅 작업이 종료되었습니다."],
    );
  }

  Future<bool> postIsWorking(String userId) async {
    print("🔍 [StatusCheck] 유저 $userId 의 작업 상태 확인 시작");
    try {
      final useCase = ref.read(sendPostingDataUseCaseProvider);
      final result = await useCase.executeIsWorking(userId);

      print("📥 [StatusCheck] 서버 원본 응답: $result");

      dynamic decodedResult = result;
      if (result is String) {
        decodedResult = jsonDecode(result);
      }

      final response = Map<String, dynamic>.from(decodedResult);
      final String status = response['status'] ?? 'error';
      final String streamUrl = response['streamUrl'] ?? '';

      print("📊 [StatusCheck] 파싱 결과 - Status: $status, StreamUrl: $streamUrl");

      if (status == "working") {
        // 1. 로그 리스트에 안내 문구 추가
        state = state.copyWith(
          logList: [...state.logList, "⏳ 기존 작업이 진행 중입니다. 연결을 시도합니다..."],
        );

        // 2. [추가] 뷰에서 감지할 수 있도록 다이얼로그 메세지 설정
        // 만약 state에 dialogMsg나 alertMsg가 있다면 설정
        this.dialogMsg = "진행 중인 포스팅 작업이 확인되었습니다.\n실시간 로그를 연결합니다.";

        // 3. SSE 연결
        if (streamUrl.isNotEmpty) {
          _listenToLogs(streamUrl);
        } else {
          print("🚨 [StatusCheck] status는 working인데 streamUrl이 비어있음!");
        }

        // 4. 리턴값을 주어 UI에서 다이얼로그를 띄우게 함
        return true; //작업중
      }
    } catch (e) {
      print("💥 [StatusCheck] 예외 발생: $e");
      // [예외 - 네트워크 등] errorCode: 2
      final errorMsg = "통신 실패: $e";
      state = state.copyWith(logList: [...state.logList, "❌ $errorMsg"]);
    }

    return false;
  }

  // 서버로 보낼 JSON 매핑 메소드
  // [수정] 서버로 보낼 JSON 매핑 메소드
  Future<MainReturnModel> sendToServer() async {
    state = state.copyWith(isLoading: true);

    // 1. 데이터 준비 (생략되지 않도록 유지)
    final proxyUrl = ref.read(proxyUrlControllerProvider).text;
    final siteUrl = ref.read(wordpressURLControllerProvider).text;
    final aiWriteRole = ref.read(aiwriteOrderControllerProvider).text;
    final postingTerm =
        int.tryParse(ref.read(postingCycleControllerProvider).text) ?? 0;

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

      // JSON 파싱
      dynamic decodedResult = result;
      if (result is String) {
        decodedResult = jsonDecode(result);
      }

      final response = Map<String, dynamic>.from(decodedResult);
      final String status = response['status'] ?? 'error';
      final String serverMessage = response['message'] ?? '알 수 없는 응답';
      final String streamUrl = response['streamUrl']?.toString() ?? "";

      // --- 상황별 리턴 처리 ---

      if (status == 'success') {
        // [성공] errorCode: 0
        state = state.copyWith(logList: [...state.logList, "✅ $serverMessage"]);
        if (streamUrl.isNotEmpty) _listenToLogs(streamUrl);

        return MainReturnModel(msg: serverMessage, errorCode: 0);
      } else if (status == 'fail') {
        // [실패 - 중복 작업] errorCode: 1
        state = state.copyWith(
          logList: [...state.logList, "⚠️ $serverMessage"],
        );

        return MainReturnModel(msg: serverMessage, errorCode: 1);
      } else {
        // [에러 - 서버 내부 오류] errorCode: 2
        state = state.copyWith(
          logList: [...state.logList, "🚨 $serverMessage"],
        );

        return MainReturnModel(msg: serverMessage, errorCode: 2);
      }
    } catch (e) {
      // [예외 - 네트워크 등] errorCode: 2
      final errorMsg = "통신 실패: $e";
      state = state.copyWith(logList: [...state.logList, "❌ $errorMsg"]);

      return MainReturnModel(msg: errorMsg, errorCode: 2);
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
