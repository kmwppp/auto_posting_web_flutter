import 'package:auto_posting_web/data/model/blog_credential_model.dart';

abstract class MainRepository {
  Future<dynamic> sendPostingData(Map<String, dynamic> data);

  Future<dynamic> sendIsWorking(String userId);

  Stream<String> getLogStream(String userId);

  Future<List<BlogCredentialModel>> fetchCredentials(int userId);

  Future<bool> deleteCredential({
    required int ownerId,
    required String loginId,
  });
}
