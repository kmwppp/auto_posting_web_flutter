import 'package:dio/dio.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

class MainRemoteDataSource {
  final Dio _dio;

  MainRemoteDataSource(this._dio);

  // 뒤에 /를 붙여주거나, 합칠 때 신경 써야 합니다.
  final String MAIN_SERVER = "https://hntrack.co.kr";

  Future<dynamic> postPostingData(Map<String, dynamic> data) async {
    // URL을 직접 합쳐서 보냅니다.
    // 결과: http://52.62.79.242/api/blog/posting
    final response = await _dio.post(
      '$MAIN_SERVER/api/blog/posting',
      data: data,
    );
    return response.data;
  }

  Stream<String> subscribeLogStream(String userId) {
    return SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: '$MAIN_SERVER/api/blog/stream/$userId',
      header: {"Accept": "text/event-stream"},
    ).map((event) => event.data ?? "");
  }
}
