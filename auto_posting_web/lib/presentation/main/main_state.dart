import 'package:auto_posting_web/data/model/blog_title_info_model.dart';
import 'package:auto_posting_web/data/model/main_user_info_model.dart';

import '../../data/model/blog_title_url_info_model.dart';
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
  final bool isRunning;

  //로딩 상태
  final bool isLoading;
  final bool isStopLoading;
  final bool isProxySetting;
  final List<MainUserInfoModel> userInfoList;
  final DistributionType distributionType;
  final MainBlogType mainBlogType;
  final PostType postType;
  final BlogInsertType blogInsertType;
  final CreatePostType createPostType;
  final PostTitleType postTitleType;
  final bool isQRLinkChange;
  final double aiImgCount;
  final AIPhotoType selectedImageStyle;
  final PostingType postingType;
  final List<BlogTitleInfoModel> titleKeywordList;
  final List<BlogTitleUrlInfoModel> titleUrlList;

  final List<String> logList;

  const MainState({
    required this.isRunning,
    required this.isLoading,
    required this.isStopLoading,
    required this.isProxySetting,
    required this.userInfoList,
    required this.distributionType,
    required this.mainBlogType,
    required this.postType,
    required this.blogInsertType,
    required this.createPostType,
    required this.postTitleType,
    required this.isQRLinkChange,
    required this.aiImgCount,
    required this.selectedImageStyle,
    required this.postingType,
    required this.titleKeywordList,
    required this.titleUrlList,
    required this.logList,
  });

  MainState copyWith({
    bool? isRunning,
    bool? isLoading,
    bool? isStopLoading,
    bool? isProxySetting,
    List<MainUserInfoModel>? userInfoList,
    DistributionType? distributionType,
    MainBlogType? mainBlogType,
    PostType? postType,
    BlogInsertType? blogInsertType,
    CreatePostType? createPostType,
    PostTitleType? postTitleType,
    bool? isQRLinkChange,
    double? aiImgCount,
    AIPhotoType? selectedImageStyle,
    PostingType? postingType,
    List<BlogTitleInfoModel>? titleKeywordList,
    List<BlogTitleUrlInfoModel>? titleUrlList,
    List<String>? logList,
  }) {
    return MainState(
      isRunning: isRunning ?? this.isRunning,
      isLoading: isLoading ?? this.isLoading,
      isStopLoading: isStopLoading ?? this.isStopLoading,
      isProxySetting: isProxySetting ?? this.isProxySetting,
      userInfoList: userInfoList ?? this.userInfoList,
      distributionType: distributionType ?? this.distributionType,
      mainBlogType: mainBlogType ?? this.mainBlogType,
      postType: postType ?? this.postType,
      blogInsertType: blogInsertType ?? this.blogInsertType,
      createPostType: createPostType ?? this.createPostType,
      postTitleType: postTitleType ?? this.postTitleType,
      isQRLinkChange: isQRLinkChange ?? this.isQRLinkChange,
      aiImgCount: aiImgCount ?? this.aiImgCount,
      selectedImageStyle: selectedImageStyle ?? this.selectedImageStyle,
      postingType: postingType ?? this.postingType,
      titleKeywordList: titleKeywordList ?? this.titleKeywordList,
      titleUrlList: titleUrlList ?? this.titleUrlList,
      logList: logList ?? this.logList,
    );
  }

  factory MainState.initial() {
    return MainState(
      isRunning: false,
      isLoading: false,
      isStopLoading: false,
      isProxySetting: true,
      userInfoList: [],
      distributionType: DistributionType.auto,
      mainBlogType: MainBlogType.wordPress,
      postType: PostType.commercial,
      blogInsertType: BlogInsertType.single,
      createPostType: CreatePostType.title,
      postTitleType: PostTitleType.keyword,
      isQRLinkChange: true,
      aiImgCount: 0,
      selectedImageStyle: AIPhotoType.photoRealistic,
      postingType: PostingType.immediately,
      titleKeywordList: [],
      titleUrlList: [],
      logList: [],
    );
  }
}
