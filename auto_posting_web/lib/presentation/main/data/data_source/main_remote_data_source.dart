import 'package:dio/dio.dart';

class MainRemoteDataSource {
  final Dio _dio;

  MainRemoteDataSource(this._dio);

  // 뒤에 /를 붙여주거나, 합칠 때 신경 써야 합니다.
  final String MAIN_SERVER = "http://52.62.79.242";

  Future<void> postPostingData(Map<String, dynamic> data) async {
    // URL을 직접 합쳐서 보냅니다.
    // 결과: http://52.62.79.242/api/blog/posting
    await _dio.post('$MAIN_SERVER/api/blog/posting', data: data);
  }
}
