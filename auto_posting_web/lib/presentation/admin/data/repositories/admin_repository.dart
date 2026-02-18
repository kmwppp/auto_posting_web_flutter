abstract class AdminRepository {
  Future<dynamic> postUserStatusData(Map<String, dynamic> data);

  Future<dynamic> getUserList();

  Future<dynamic> postUserSuccessLogs(Map<String, dynamic> data);
}
