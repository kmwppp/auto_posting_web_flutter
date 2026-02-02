abstract class MainRepository {
  Future<dynamic> sendPostingData(Map<String, dynamic> data);

  Future<dynamic> sendIsWorking(String userId);

  Stream<String> getLogStream(String userId);
}
