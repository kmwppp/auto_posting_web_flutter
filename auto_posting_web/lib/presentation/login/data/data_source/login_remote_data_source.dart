import 'package:dio/dio.dart';

class LoginRemoteDataSource {
  final Dio _dio;

  LoginRemoteDataSource(this._dio);

  final String MAIN_SERVER = "https://hntrack.co.kr";

  Future<dynamic> postLoginData(Map<String, dynamic> data, bool isAdmin) async {
    final serverUrl = !isAdmin
        ? '$MAIN_SERVER/api/login'
        : '$MAIN_SERVER/api/admin/login';
    final response = await _dio.post(serverUrl, data: data);
    return response.data;
  }
}
