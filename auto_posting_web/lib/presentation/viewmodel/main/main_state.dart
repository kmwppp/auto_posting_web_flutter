import 'package:auto_posting_web/data/model/main_user_info_model.dart';

enum DistributionType { auto, manual }

class MainState {
  final List<MainUserInfoModel> userInfoList;
  final DistributionType distributionType;

  const MainState({required this.userInfoList, required this.distributionType});

  MainState copyWith({
    List<MainUserInfoModel>? userInfoList,
    DistributionType? distributionType,
  }) {
    return MainState(
      userInfoList: userInfoList ?? this.userInfoList,
      distributionType: distributionType ?? this.distributionType,
    );
  }

  factory MainState.initial() {
    return MainState(userInfoList: [], distributionType: DistributionType.auto);
  }
}
