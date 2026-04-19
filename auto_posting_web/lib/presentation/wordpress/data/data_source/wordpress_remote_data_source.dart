import 'package:dio/dio.dart';

class WordpressRemoteDataSource {
  final Dio _dio;

  WordpressRemoteDataSource(this._dio);

  final String MAIN_SERVER = "https://hntrack.co.kr";

  Future<dynamic> postPostingData(Map<String, dynamic> data) async {
    // URL을 직접 합쳐서 보냅니다.
    // 결과: http://52.62.79.242/api/blog/posting
    final response = await _dio.post(
      '$MAIN_SERVER/api/wordpress/posting',
      data: data,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getCredentials(int ownerId) async {
    final response = await _dio.get(
      '$MAIN_SERVER/api/wordpress/credentials/$ownerId',
    );

    return response.data as Map<String, dynamic>;
  }
}
