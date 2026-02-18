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

  Future<dynamic> postUserList() async {
    final serverUrl = '$MAIN_SERVER/api/admin/userList';
    final response = await _dio.post(serverUrl);
    return response.data;
  }

  Future<dynamic> postUserSuccessLogs(Map<String, dynamic> data) async {
    final serverUrl = '$MAIN_SERVER/api/admin/userInfo/successList';
    final response = await _dio.post(serverUrl, data: data);
    return response.data;
  }
}
