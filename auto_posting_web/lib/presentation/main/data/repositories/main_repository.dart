abstract class MainRepository {
  Future<dynamic> sendPostingData(Map<String, dynamic> data);

  Future<dynamic> sendStopWorking(String userId);

  Future<dynamic> sendIsWorking(String userId);

  Stream<String> getLogStream(String userId);

  Future<dynamic> fetchCredentials(int userId);

  Future<bool> deleteCredential({
    required int ownerId,
    required String loginId,
  });
}
