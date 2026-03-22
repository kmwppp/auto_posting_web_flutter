import 'dart:async';
import 'dart:convert';

import 'package:auto_posting_web/data/model/blog_title_info_model.dart';
import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/provider_container.dart';
import '../../data/model/blog_title_url_info_model.dart';
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
  int addUserInfo({
    required int? currentUserId,
    required String userId,
    required String userPassword,
  }) {
    String current = currentUserId?.toString() ?? "";

    // 1. 기본 유효성 검사 (아이디/비번이 비어있으면 실패)
    if (!_isNullVaildChk(str1: userId, str2: userPassword)) {
      return 1;
    }

    // 2. 중복 체크 로직
    // 이미 리스트에 동일한 userId가 있는지 확인
    bool isDuplicate = state.userInfoList.any((user) => user.userId == userId);

    if (isDuplicate) {
      print("⚠️ 중복 아이디 발견: $userId");
      return 2; // 중복이므로 추가하지 않고 false 반환
    }

    // 3. 리스트 추가 로직 (불변성 유지)
    MainUserInfoModel model = MainUserInfoModel(
      currentUserId: current,
      userId: userId,
      userPassword: userPassword,
      postingCount: state.distributionType == DistributionType.auto ? 5 : 0,
      isPostingCheck: false,
      userBlogId: '',
      proxy_id: '',
      proxy_pw: '',
      port: '',
    );

    // 새로운 리스트를 만들어 상태 업데이트
    state = state.copyWith(userInfoList: [...state.userInfoList, model]);

    print("✅ 계정 추가 성공: $userId");
    return 0; // 성공적으로 추가됨
  }

  void updateBlogId({required int index, required String id}) {
    final newList = [...state.userInfoList];
    // 해당 인덱스의 모델만 copyWith로 포트 번호 교체
    newList[index] = newList[index].copyWith(userBlogId: id);

    state = state.copyWith(userInfoList: newList);
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

  /// 계정 삭제 로직 (서버 삭제 + 로컬 리스트 갱신)
  Future<bool> removeUserInfo({
    required int index,
    required int ownerId,
  }) async {
    // 1. 현재 인덱스의 유저 정보 가져오기
    final targetUser = state.userInfoList[index];
    final String loginId = targetUser.userId; // MainUserInfoModel의 계정 ID 필드

    try {
      state = state.copyWith(isLoading: true);

      // 2. 서버 삭제 UseCase 호출
      final deleteUseCase = ref.read(deleteCredentialUseCaseProvider);
      await deleteUseCase.execute(ownerId: ownerId, loginId: loginId);

      final newList = [...state.userInfoList];
      newList.removeAt(index);
      state = state.copyWith(userInfoList: newList);
      return true;
    } catch (e) {
      print("❌ 계정 삭제 중 오류 발생: $e");
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void addBlogInfoSingle({required String first, required String second}) {
    if (_isNullVaildChk(str1: first, str2: second)) {
      if (state.postTitleType == PostTitleType.keyword) {
        final list = [...state.titleKeywordList];
        BlogTitleInfoModel model = BlogTitleInfoModel(
          main_keyword: first,
          posting_title: second,
        );
        list.add(model);

        state = state.copyWith(titleKeywordList: list);
      } else {
        final list = [...state.titleUrlList];
        BlogTitleUrlInfoModel model = BlogTitleUrlInfoModel(
          posting_title: first,
          url: second,
        );
        list.add(model);

        state = state.copyWith(titleUrlList: list);
      }
    }
  }

  void addBlogInfoMulti({required String first, required String second}) {
    if (state.postTitleType == PostTitleType.keyword) {
      final keywords = first
          .split('\n')
          .where((s) =>
      s
          .trim()
          .isNotEmpty)
          .toList();
      final titles = second
          .split('\n')
          .where((s) =>
      s
          .trim()
          .isNotEmpty)
          .toList();

      final list = [...state.titleKeywordList];

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

      state = state.copyWith(titleKeywordList: list);
    } else {
      final title = first
          .split('\n')
          .where((s) =>
      s
          .trim()
          .isNotEmpty)
          .toList();
      final url = second.split('\n').where((s) =>
      s
          .trim()
          .isNotEmpty).toList();

      final list = [...state.titleUrlList];

      // 두 리스트 중 짧은 쪽 길이에 맞춰 생성
      int count = title.length < url.length ? title.length : url.length;

      for (int i = 0; i < count; i++) {
        list.add(
          BlogTitleUrlInfoModel(
            posting_title: title[i].trim(),
            url: url[i].trim(),
          ),
        );
      }

      state = state.copyWith(titleUrlList: list);
    }
  }

  void resetBlogInfoModel() {
    if (state.postTitleType == PostTitleType.keyword) {
      state = state.copyWith(titleKeywordList: []);
    } else {
      state = state.copyWith(titleUrlList: []);
    }
  }

  void removeBlogInfo({required int index}) {
    if (state.postTitleType == PostTitleType.keyword) {
      final newList = [...state.titleKeywordList];
      newList.removeAt(index);
      state = state.copyWith(titleKeywordList: newList);
    } else {
      final newList = [...state.titleUrlList];
      newList.removeAt(index);
      state = state.copyWith(titleUrlList: newList);
    }
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

  void changeMainBlogType(MainBlogType type) {
    state = state.copyWith(mainBlogType: type);
  }

  void changePostType(PostType type) {
    state = state.copyWith(postType: type);
  }

  void changePostTitleType(PostTitleType type) {
    state = state.copyWith(
      postTitleType: type,
      titleKeywordList: [],
      titleUrlList: [],
    );
    ref.read(mainKeyWordControllerProvider).clear();
    ref.read(blogTitleControllerProvider).clear();
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

  void changePostingTermType(PostingTermType type) {
    state = state.copyWith(postingTermType: type);
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

        if (user.userBlogId == "") {
          return ValidationResult(false, "${i + 1}번째 계정의 네이버 블로그 아이디를 입력해주세요.");
        }

        if (state.isProxySetting &&
            (user.proxy_id == "" || user.proxy_pw == "" || user.port == "")) {
          return ValidationResult(false, "${i + 1}번째 계정의 프록시 정보를 입력해주세요.");
        }
      }
    }

    for (int i = 0; i < state.userInfoList.length; i++) {
      final user = state.userInfoList[i];

      if (user.userBlogId == "") {
        return ValidationResult(false, "${i + 1}번째 계정의 네이버 블로그 아이디를 입력해주세요.");
      }

      if (state.isProxySetting &&
          (user.proxy_id == "" || user.proxy_pw == "" || user.port == "")) {
        return ValidationResult(false, "${i + 1}번째 계정의 프록시 정보를 입력해주세요.");
      }
    }

    // 3. 워드프레스 URL
    if (ref
        .read(wordpressURLControllerProvider)
        .text
        .trim()
        .isEmpty) {
      return ValidationResult(false, "워드프레스 사이트 URL을 입력해주세요.");
    }

    // 3-1. 링크 상단 문구
    if (ref
        .read(linkTopTextControllerProvider)
        .text
        .trim()
        .isEmpty) {
      return ValidationResult(false, "링크 상단 문구를 입력해주세요.");
    }

    // 4. 제목 리스트
    if (state.postTitleType == PostTitleType.keyword) {
      if (state.titleKeywordList.isEmpty) {
        return ValidationResult(false, "메인 키워드 및 제목을 추가해주세요.");
      }
    } else {
      if (state.titleUrlList.isEmpty) {
        return ValidationResult(false, "블로그 제목 및 워드프레스 링크를 추가해주세요.");
      }
    }

    // 5. 발행 주기
    final term =
        int.tryParse(ref
            .read(postingCycleControllerProvider)
            .text) ?? 0;
    if (state.postingType == PostingType.publication) {
      if (term <= 0) {
        return ValidationResult(false, "올바른 발행 주기를 입력해주세요.");
      }

      if (state.userInfoList[0].userId != "v2v2kmw") {
        if (term < 5) {
          return ValidationResult(false, "네이버 최적화를 위하여 5분이상으로 세팅해주세요.");
        }
      }
    }

    // 모든 검증 통과
    return ValidationResult(true, "");
  }

  // [수정] 로그 수신 전용 메서드
  void _listenToLogs(String streamUrl) {
    print("🚀 [SSE] _listenToLogs 시작됨 - 전달받은 URL: $streamUrl");
    // 기존 로그 초기화
    if (!state.isRunning) {
      state = state.copyWith(logList: []);
    }

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
      isRunning: false,
    );
  }

  Future<bool> postStopWorking(String userId) async {
    // 1. 로딩 시작
    state = state.copyWith(isStopLoading: true);

    try {
      final useCase = ref.read(sendPostingDataUseCaseProvider);
      final result = await useCase.executeStopWorking(userId);

      dynamic decodedResult = result;
      if (result is String) {
        decodedResult = jsonDecode(result);
      }

      final response = Map<String, dynamic>.from(decodedResult);
      final String status = response['status'] ?? 'error';

      // ✨ 성공일 때만 true 반환
      if (status == 'success') {
        return true;
      }
    } catch (e) {
      // 에러 발생 시 로그를 찍어두면 나중에 디버깅하기 편합니다.
      print("중단 요청 중 오류 발생: $e");
    } finally {
      // 2. 성공하든 실패하든 에러가 나든 마지막엔 무조건 로딩 해제
      state = state.copyWith(isStopLoading: false, isRunning: false);
    }

    return false;
  }

  Future<void> getNowHistoryList(int userId) async {
    try {
      final useCase = ref.read(getNowHistoryListUseCaseProvider);

      // 1. userId를 String으로 변환하여 execute 호출
      final dynamic response = await useCase.execute(userId.toString());

      // 2. 리스폰스 데이터 검증 및 state 업데이트
      if (response != null && response['status'] == 'success') {
        // current_messages 키에서 리스트를 추출 (null일 경우 빈 리스트)
        final List<dynamic> messageData = response['current_messages'] ?? [];

        // String 리스트로 안전하게 변환
        final List<String> fetchedLogs = messageData
            .map((e) => e.toString())
            .toList();

        // 3. 상태 업데이트 (StateNotifier 또는 Notifier 기준)
        // logList라는 필드가 state에 정의되어 있어야 합니다.
        state = state.copyWith(logList: fetchedLogs);

        debugPrint("✅ 실시간 로그 업데이트 완료: ${fetchedLogs.length}건");
      }
    } catch (e) {
      debugPrint("❌ 실시간 로그 로드 실패: $e");
    }
  }

  // userId를 int로 받아서 String으로 넘겨주는 로직
  Future<List<String>> getHistoryDateList(int userId) async {
    try {
      final useCase = ref.read(getHistoryDataListUseCaseProvider);

      // 1. userId를 String으로 변환하여 execute 호출
      final dynamic response = await useCase.execute(userId.toString());

      // 2. 리스폰스 구조 { "dates": [...] } 에서 리스트 추출
      if (response != null && response['dates'] != null) {
        return List<String>.from(response['dates']);
      }
      return ["작업한 로그가 없습니다."];
    } catch (e) {
      debugPrint("❌ 히스토리 로드 실패: $e");
      return ["작업한 로그를 불러오는 중 오류가 발생하였습니다."];
    }
  }

  Future<List<String>> getHistoryList(int userId, String date) async {
    try {
      final useCase = ref.read(getHistoryListUseCaseProvider);

      // 1. userId를 String으로 변환하여 execute 호출
      final dynamic response = await useCase.execute(userId.toString(), date);

      // 2. 리스폰스 데이터 검증 및 message만 추출
      if (response != null && response['logs'] != null) {
        final List<dynamic> logs = response['logs'];

        // map을 사용해서 message 필드만 String 리스트로 변환
        return logs.map((log) => log['message']?.toString() ?? "").toList();
      }

      return [];
    } catch (e) {
      debugPrint("❌ 상세 로그 로드 실패 ($date): $e");
      return [];
    }
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
        await getNowHistoryList(int.parse(userId));

        // 1. 로그 리스트에 안내 문구 추가
        state = state.copyWith(
          logList: [...state.logList, "⏳ 기존 작업이 진행 중입니다. 연결을 시도합니다..."],
          isRunning: true,
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
    final proxyUrl = ref
        .read(proxyUrlControllerProvider)
        .text;
    final siteUrl = ref
        .read(wordpressURLControllerProvider)
        .text;
    final linkTopText = ref
        .read(linkTopTextControllerProvider)
        .text;
    final aiWriteRole = ref
        .read(aiwriteOrderControllerProvider)
        .text;
    final postingTerm =
        int.tryParse(ref
            .read(postingCycleControllerProvider)
            .text) ?? 0;

    final Map<String, dynamic> requestData = {
      "proxy": proxyUrl,
      "proxyUse": state.isProxySetting,
      "authList": state.userInfoList.map((e) => e.toJson()).toList(),
      "mainBlogType": state.mainBlogType.name,
      "postType": state.postType.name,
      "siteUrl": siteUrl,
      "linkTopText": linkTopText,
      "postTitleType": state.postTitleType.name,
      "postKeywordTitleList": state.titleKeywordList
          .map((e) => e.toJson())
          .toList(),
      "postURLTitleList": state.titleUrlList.map((e) => e.toJson()).toList(),
      "autoChangeQRLink": state.isQRLinkChange,
      "aiWriteRole": aiWriteRole,
      "postingType": state.postingType.name,
      "postingTerm": postingTerm,
      "postingTermType": state.postingTermType.name,
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
        // state 현재 작업이 시작 되었는지 업데이트
        // [성공] errorCode: 0
        state = state.copyWith(
          logList: [...state.logList, "✅ $serverMessage"],
          isRunning: true,
        );
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

  Future<bool> fetchSavedCredentials(int userId) async {
    try {
      // 1. UseCase 호출 (서버가 이제 Map을 주니까 dynamic으로 받음)
      final useCase = ref.read(getCredentialsUseCaseProvider);
      final dynamic response = await useCase.execute(userId);

      // 1. 전체 응답 데이터 출력
      // print("================ SERVER RESPONSE ================");
      // print("Full Response: $response");
      // print("================================================");

      // 데이터가 없거나 형식이 이상하면 바로 커트
      if (response == null || response['user_credentials'] == null) {
        return false;
      }

      // --- 데이터 쪼개기 ---
      final List<dynamic> credData = response['user_credentials'];
      final Map<String, dynamic> saveInfo = response['user_save_info'] ?? {};

      // print("------------------------------------------------");
      // print("🛠 저장된 설정 정보(save_info):");
      // print("   - IP: ${saveInfo['ip']}");
      // print("   - URL: ${saveInfo['wp_url']}");
      // print("   - Comment: ${saveInfo['link_comment']}");
      // print("================================================");

      // 2. 계정 리스트 모델 변환 (기존 로직 그대로)
      final List<MainUserInfoModel> savedUserList = credData.map((data) {
        // BlogCredentialModel.fromJson이 있다면 그걸 쓰시고,
        // 없으면 아래처럼 직접 매핑하세요.
        return MainUserInfoModel(
          currentUserId: data['owner_id'].toString(),
          userId: data['login_id'] ?? "",
          userPassword: data['login_pw'] ?? "",
          postingCount: state.distributionType == DistributionType.auto ? 5 : 0,
          isPostingCheck: true,
          userBlogId: data['blog_id'] ?? "",
          proxy_id: data['proxy_id'] ?? "",
          proxy_pw: data['proxy_pw'] ?? "",
          port: data['proxy_port'] ?? "",
        );
      }).toList();

      // 3. 컨트롤러(Provider) 값 업데이트 (State 대신 컨트롤러에 직접 기입)
      ref
          .read(proxyUrlControllerProvider)
          .text = saveInfo['ip'] ?? "";
      ref
          .read(wordpressURLControllerProvider)
          .text = saveInfo['wp_url'] ?? "";

      final String comment = saveInfo['link_comment'] ?? "";
      ref
          .read(linkTopTextControllerProvider)
          .text = comment.isEmpty
          ? "자세한 정보는 아래에서 확인해보세요."
          : comment;

      // 3. 상태 업데이트 (리스트랑 서버 저장 정보 한꺼번에 업데이트)
      state = state.copyWith(userInfoList: savedUserList);

      return true;
    } catch (e) {
      print("Error fetching credentials: $e");
      return false;
    }
  }
}

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult(this.isValid, this.message);
}
