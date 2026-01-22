import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_enums.dart';
import 'main_state.dart';

class MainViewModel extends Notifier<MainState> {
  @override
  MainState build() {
    return MainState.initial();
  }

  /// 블로그를 쓰기위한 계정 추가 로직
  void addUserInfo({required String userId, required String userPassword}) {
    if (_isNullVaildChk(userId: userId, userPassword: userPassword)) {
      List<MainUserInfoModel> list = state.userInfoList;
      MainUserInfoModel model = MainUserInfoModel(
        userId: userId,
        userPassword: userPassword,
        postingCount: state.distributionType == DistributionType.auto ? 5 : 0,
        isPostingCheck: false,
      );
      list.add(model);

      state = state.copyWith(userInfoList: list);
    }

    print("state.userInfoList: ${state.userInfoList.length}");
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

  bool _isNullVaildChk({required String userId, required String userPassword}) {
    if (userId == "" || userPassword == "") {
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
}
