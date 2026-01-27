import 'package:auto_posting_web/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProxyDescriptionPage extends StatelessWidget {
  const ProxyDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "프록시를 사용하려면 이 페이지를 숙지해주세요.",
                  style: context.title.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text("1. 저희는 오로지 ", style: context.title),
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(
                          'https://proxy-seller.com/ko/',
                        );

                        // 웹에서는 별도 권한 체크 없이 바로 실행해도 무방합니다.
                        try {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication, // 새 탭에서 열기
                          );
                        } catch (e) {
                          debugPrint("링크를 열 수 없습니다: $e");
                        }
                      },
                      child: Text(
                        "https://proxy-seller.com/ko/",
                        style: context.title.copyWith(color: Colors.blue),
                      ),
                    ),
                    Text("의 프록시만 사용가능합니다.", style: context.title),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "2. 위 프록시 셀러에서 IPv4를 구매하여 정보를 가져옵니다.",
                  style: context.title,
                ),
                SizedBox(height: 30),
                Divider(),
                Text(
                  "2-1. 프록시를 구매후 주문으로 진입합니다.",
                  style: context.titleMideum.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset('assets/images/first.png'),
                SizedBox(height: 30),
                Divider(),
                Text(
                  "2-2. 아래 내가 구매한 IP 목록을 찾습니다.",
                  style: context.titleMideum.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset('assets/images/second.png'),
                SizedBox(height: 30),
                Divider(),
                Text(
                  "2-3. 구매한 IP, ID, Password, Port를 가져옵니다.",
                  style: context.titleMideum.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset('assets/images/third.png'),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
