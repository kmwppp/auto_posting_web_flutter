import 'dart:convert';

import 'package:auto_posting_web/data/model/blog_title_info_model.dart';
import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_enums.dart';
import 'main_provider.dart';
import 'main_state.dart';

class MainViewModel extends Notifier<MainState> {
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

  void updatePort({required int index, required String port}) {
    final newList = [...state.userInfoList];
    // 해당 인덱스의 모델만 copyWith로 포트 번호 교체
    newList[index] = newList[index].copyWith(port: port);

    state = state.copyWith(userInfoList: newList);
  }

  void updatePostingCount({required int index, required String postingCount}) {
    final newList = [...state.userInfoList];

    // String을 int로 변환 (변환 실패 시 기본값 0)
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

  // 서버로 보낼 JSON 매핑 메소드
  Future<void> sendToServer() async {
    // 1. 컨트롤러들로부터 값 추출
    final proxyUrl = ref.read(proxyUrlControllerProvider).text;
    final siteUrl = ref.read(wordpressURLControllerProvider).text;
    final aiWriteRole = ref.read(aiwriteOrderControllerProvider).text;
    final postingTerm =
        int.tryParse(ref.read(postingCycleControllerProvider).text) ?? 0;

    // 2. 최종 JSON 데이터 구성
    final Map<String, dynamic> requestData = {
      "proxy": proxyUrl,
      "proxyUse": state.isProxySetting,

      // 리스트 모델들을 JSON 리스트로 변환
      "authList": state.userInfoList.map((e) => e.toJson()).toList(),

      // Enum 값들은 .name 또는 특정 스트링으로 변환 필요
      "postType": state.postType.name,
      "siteUrl": siteUrl,

      "postTitle": state.titleList.map((e) => e.toJson()).toList(),

      "autoChangeQRLink": state.isQRLinkChange,
      "aiWriteRole": aiWriteRole,
      "postingTerm": postingTerm,

      // PostingType (예: immediately)
      "postingTermType": state.postingType.name,
    };

    // 확인용 출력
    print(jsonEncode(requestData));

    // TODO: 이후 http 패키지 등을 사용하여 서버 전송 로직 수행
  }
}
