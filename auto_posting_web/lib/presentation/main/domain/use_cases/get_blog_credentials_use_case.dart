import 'package:auto_posting_web/data/model/blog_credential_model.dart';

import '../../data/repositories/main_repository.dart';

class GetBlogCredentialsUseCase {
  final MainRepository _repository;

  GetBlogCredentialsUseCase(this._repository);

  Future<List<BlogCredentialModel>> execute(int userId) {
    return _repository.fetchCredentials(userId);
  }
}
