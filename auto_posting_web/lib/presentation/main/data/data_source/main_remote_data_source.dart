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

  Future<dynamic> postStopWorking(String userId) async {
    // URL을 직접 합쳐서 보냅니다.
    // 결과: http://52.62.79.242/api/blog/posting
    final response = await _dio.post('$MAIN_SERVER/api/blog/stop/$userId');
    return response.data;
  }

  Future<dynamic> postIsWorking(String userId) async {
    // URL을 직접 합쳐서 보냅니다.
    // 결과: http://52.62.79.242/api/blog/posting
    final response = await _dio.post('$MAIN_SERVER/api/blog/status/$userId');
    return response.data;
  }

  Stream<String> subscribeLogStream(String streamUrl) {
    print("$MAIN_SERVER$streamUrl");
    return SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: '$MAIN_SERVER$streamUrl',
      header: {"Accept": "text/event-stream"},
    ).map((event) => event.data ?? "");
  }

  Future<dynamic> getCredentials(int userId) async {
    try {
      // 결과 주소: https://hntrack.co.kr/api/blog/credentials/5
      final response = await _dio.get(
        '$MAIN_SERVER/api/blog/credentials/$userId',
      );

      if (response.statusCode == 200) {
        return response.data;
        // Dio는 기본적으로 jsonDecode를 수행하므로 response.data를 바로 사용합니다.
        // final List<dynamic> dataList = response.data;
        // return dataList
        //     .map((json) => BlogCredentialModel.fromJson(json))
        //     .toList();
      } else {
        throw Exception("데이터를 불러오는 데 실패했습니다 (Status: ${response.statusCode})");
      }
    } on DioException catch (e) {
      // Dio 에러 핸들링
      throw Exception("네트워크 오류 발생: ${e.message}");
    } catch (e) {
      throw Exception("알 수 없는 오류 발생: $e");
    }
  }

  Future<bool> deleteCredential({
    required int ownerId,
    required String loginId,
  }) async {
    try {
      final response = await _dio.delete(
        '$MAIN_SERVER/api/blog/credentials',
        queryParameters: {'owner_id': ownerId, 'login_id': loginId},
      );

      // 서버 응답이 200(성공)이면 true 반환
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("❌ 삭제 요청 실패: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      print("❌ 알 수 없는 에러: $e");
      return false;
    }
  }
}
