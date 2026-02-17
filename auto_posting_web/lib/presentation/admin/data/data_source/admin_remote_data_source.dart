import 'package:dio/dio.dart';

class AdminRemoteDataSource {
  final Dio _dio;

  AdminRemoteDataSource(this._dio);

  final String MAIN_SERVER = "https://hntrack.co.kr";

  Future<dynamic> postUserStatusData(Map<String, dynamic> data) async {
    final serverUrl = '$MAIN_SERVER/api/admin/status';
    final response = await _dio.post(serverUrl, data: data);
    return response.data;
  }
}
