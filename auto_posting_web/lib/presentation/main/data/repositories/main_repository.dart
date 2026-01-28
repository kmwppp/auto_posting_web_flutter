abstract class MainRepository {
  Future<dynamic> sendPostingData(Map<String, dynamic> data);
  Stream<String> getLogStream(String userId);
}
