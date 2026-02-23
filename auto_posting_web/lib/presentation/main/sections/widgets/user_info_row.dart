import 'package:auto_posting_web/data/model/main_user_info_model.dart';
import 'package:auto_posting_web/presentation/main/main_enums.dart';
import 'package:auto_posting_web/presentation/main/sections/widgets/posting_count_field.dart';
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
            Text("${index + 1}.", style: context.titleMideum),
            SizedBox(width: 10),
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
                    color: Colors.white,
                  ),
                  width: 74,
                  height: 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: distributionType == DistributionType.manual
                      ? PostingCountField(
                          initialValue: user.postingCount,
                          onChanged: (value) {
                            notifier.updatePostingCount(
                              index: index,
                              postingCount: value,
                            );
                          },
                        )
                      : Text("${user.postingCount}"),
                ),
                Text("개", style: context.bodyLarge),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    notifier.removeUserInfo(
                      index: index,
                      ownerId:
                          int.tryParse(
                            state.userInfoList[index].currentUserId,
                          ) ??
                          0,
                    );
                  },
                  icon: Icon(Icons.close, size: 24),
                ),
              ],
            ),
          ],
        ),
        // if (state.isProxySetting)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14),
            Row(
              children: [
                Text(
                  "네이버 블로그 글쓰기 아이디 확인",
                  style: context.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // 배경색 변경
                  ),
                  onPressed: () {
                    // 버튼 클릭 시 다이얼로그 호출
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("네이버 블로그 아이디 확인 방법"),
                          content: SingleChildScrollView(
                            // 내용이 길 경우 스크롤 가능하게 함
                            child: ListBody(
                              children: const <Widget>[
                                Text("1. 네이버 웹을 실행하여 로그인 합니다."),
                                SizedBox(height: 14),
                                Text("2. 내 블로그로 이동합니다."),
                                SizedBox(height: 14),
                                Text("3. 내 블로그로 이동한 상태에서 글쓰기 버튼을 클릭합니다."),
                                SizedBox(height: 14),
                                Text("4. 글쓰기 페이지 URL을 확인하여 내 블로그 아이디를 확인합니다."),
                                SizedBox(height: 6),
                                Text(
                                  "Ex) https://blog.naver.com/(내 블로그 아이디)?Redirect=Write&",
                                ),

                                SizedBox(height: 14),
                                Text(
                                  "상세 내용: 이 아이디는 블로그 주소(blog.naver.com/내 블로그 아이디)로 활용됩니다. ",
                                ), // 긴 텍스트 예시
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("확인"),
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "네이버 블로그 아이디 확인 방법",
                    style: context.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "네이버 블로그 아이디는 항상 확인해주세요. 오류의 원인이 됩니다.",
              style: context.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("아이디: ", style: context.bodyLarge),
                inputProxySet(
                  user: user,
                  context: context,
                  controller: TextEditingController(text: user.userBlogId)
                    ..selection = TextSelection.collapsed(
                      offset: user.userBlogId.length,
                    ),
                  onChanged: (value) {
                    notifier.updateBlogId(index: index, id: value);
                  },
                  width: 180,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "계정 프록시 설정",
              style: context.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
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

                SizedBox(width: 20),

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
                SizedBox(width: 20),
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
        color: Colors.white,
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
