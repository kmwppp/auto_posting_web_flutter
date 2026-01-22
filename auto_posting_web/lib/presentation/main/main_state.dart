import 'package:auto_posting_web/data/model/main_user_info_model.dart';

import 'main_enums.dart';

/**
 *  userInfoList          : 유저가 등록한 계정 리스트
 *  distributionType      : 포스트 분배 타입
 *  postType              : 포스트 유형
 *  createPostType        : 상업성 글 생성 방식
 *  isQRLinkChange        : QR 링크 자동 변환 여부
 *  aiImgCount            : AI 이미지 생성 갯수
 *  selectedImageStyle    : AI 이미지 스타일 타입
 */

class MainState {
  final bool isProxySetting;
  final List<MainUserInfoModel> userInfoList;
  final DistributionType distributionType;
  final PostType postType;
  final CreatePostType createPostType;
  final bool isQRLinkChange;
  final double aiImgCount;
  final AIPhotoType selectedImageStyle;
  final PostingType postingType;

  const MainState({
    required this.isProxySetting,
    required this.userInfoList,
    required this.distributionType,
    required this.postType,
    required this.createPostType,
    required this.isQRLinkChange,
    required this.aiImgCount,
    required this.selectedImageStyle,
    required this.postingType,
  });

  MainState copyWith({
    bool? isProxySetting,
    List<MainUserInfoModel>? userInfoList,
    DistributionType? distributionType,
    PostType? postType,
    CreatePostType? createPostType,
    bool? isQRLinkChange,
    double? aiImgCount,
    AIPhotoType? selectedImageStyle,
    PostingType? postingType,
  }) {
    return MainState(
      isProxySetting: isProxySetting ?? this.isProxySetting,
      userInfoList: userInfoList ?? this.userInfoList,
      distributionType: distributionType ?? this.distributionType,
      postType: postType ?? this.postType,
      createPostType: createPostType ?? this.createPostType,
      isQRLinkChange: isQRLinkChange ?? this.isQRLinkChange,
      aiImgCount: aiImgCount ?? this.aiImgCount,
      selectedImageStyle: selectedImageStyle ?? this.selectedImageStyle,
      postingType: postingType ?? this.postingType,
    );
  }

  factory MainState.initial() {
    return MainState(
      isProxySetting: false,
      userInfoList: [],
      distributionType: DistributionType.auto,
      postType: PostType.commercial,
      createPostType: CreatePostType.title,
      isQRLinkChange: true,
      aiImgCount: 0,
      selectedImageStyle: AIPhotoType.photoRealistic,
      postingType: PostingType.immediately,
    );
  }
}
