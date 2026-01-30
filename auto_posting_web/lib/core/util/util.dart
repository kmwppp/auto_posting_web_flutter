class Util {
  static String phoneNumberSet(String phoneNum) {
    // [^0-9]는 숫자가 아닌 모든 문자를 의미합니다.
    String result = phoneNum.replaceAll(RegExp(r'[^0-9]'), '');
    return result; // 01000000000
  }
}
