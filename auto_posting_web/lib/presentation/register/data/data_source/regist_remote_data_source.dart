import 'package:dio/dio.dart';

class RegistRemoteDataSource {
  final Dio _dio;
  RegistRemoteDataSource(this._dio);

  final String MAIN_SERVER = "https://hntrack.co.kr";

  Future<dynamic> postRegistData(Map<String, dynamic> data) async {
    final response = await _dio.post('$MAIN_SERVER/api/regist', data: data);
    return response.data;
  }
}
