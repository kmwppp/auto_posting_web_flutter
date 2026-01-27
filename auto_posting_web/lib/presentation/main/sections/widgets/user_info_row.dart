import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:auto_posting_web/presentation/main/main_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../main_provider.dart';

class UserInfoRow extends ConsumerWidget {
  const UserInfoRow({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final user = state.userInfoList[index];
    final notifier = ref.read(mainViewModelProvider.notifier);
    final distributionType = ref.watch(
      mainViewModelProvider.select((s) => s.distributionType),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "ID: ${state.userInfoList[index].userId} / PW: ${state.userInfoList[index].userPassword}",
                style: context.bodyLarge,
              ),
            ),
            SizedBox(width: 10),
            Text("|    갯수: ", style: context.bodyLarge),
            SizedBox(width: 10),
            Row(
              spacing: 10,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: 74,
                  height: 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: distributionType == DistributionType.manual
                      ? TextField(
                          textAlign: TextAlign.center,
                          // int 타입을 String으로 변환하여 초기값 설정
                          controller:
                              TextEditingController(
                                  text: user.postingCount.toString(),
                                )
                                ..selection = TextSelection.collapsed(
                                  offset: user.postingCount.toString().length,
                                ),
                          onChanged: (value) {
                            // 포트가 아닌 포스팅 개수 업데이트 함수 호출
                            notifier.updatePostingCount(
                              index: index,
                              postingCount: value,
                            );
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          style: context.bodyLarge,
                        )
                      : Text("${user.postingCount}"),
                ),
                Text("개", style: context.bodyLarge),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    notifier.removeUserInfo(index: index);
                  },
                  icon: Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ],
        ),
        if (state.isProxySetting)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14),
              Text("계정 프록시 설정", style: context.bodyLarge),
              SizedBox(height: 10),
              Row(
                spacing: 10,
                children: [
                  Text("아이디: ", style: context.bodyLarge),
                  inputProxySet(
                    user: user,
                    context: context,
                    controller: TextEditingController(text: user.proxy_id)
                      ..selection = TextSelection.collapsed(
                        offset: user.proxy_id.length,
                      ),
                    onChanged: (value) {
                      notifier.updateProxyId(index: index, id: value);
                    },
                    width: 180,
                  ),

                  Text("비밀번호: ", style: context.bodyLarge),
                  inputProxySet(
                    user: user,
                    context: context,
                    controller: TextEditingController(text: user.proxy_pw)
                      ..selection = TextSelection.collapsed(
                        offset: user.proxy_pw.length,
                      ),
                    onChanged: (value) {
                      notifier.updateProxyPw(index: index, pw: value);
                    },
                    width: 180,
                  ),

                  Text("포트번호: ", style: context.bodyLarge),
                  inputProxySet(
                    user: user,
                    context: context,
                    controller: TextEditingController(text: user.port)
                      ..selection = TextSelection.collapsed(
                        offset: user.port.length,
                      ),
                    onChanged: (value) {
                      notifier.updatePort(index: index, port: value);
                    },
                    width: 100,
                  ),
                ],
              ),
            ],
          ),
        SizedBox(height: 14),
        Divider(),
      ],
    );
  }

  Container inputProxySet({
    required MainUserInfoModel user,
    required BuildContext context,
    required TextEditingController controller,
    required void Function(String) onChanged,
    double width = 100, // 너비도 인자로 조절 가능하게 하면 좋습니다.
  }) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      width: width,
      height: 30,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        textAlign: TextAlign.center,
        // 1. 초기값 설정 (사용자가 입력하던 중 위젯이 다시 그려져도 유지되도록)
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(isDense: true, border: InputBorder.none),
        style: context.bodyLarge,
      ),
    );
  }
}
