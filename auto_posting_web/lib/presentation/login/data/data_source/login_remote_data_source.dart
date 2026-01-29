import 'package:dio/dio.dart';

class LoginRemoteDataSource {
  final Dio _dio;

  LoginRemoteDataSource(this._dio);

  final String MAIN_SERVER = "https://hntrack.co.kr";

  Future<dynamic> postLoginData(Map<String, dynamic> data) async {
    final response = await _dio.post('$MAIN_SERVER/api/login', data: data);
    return response.data;
  }
}
